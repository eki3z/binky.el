;;; binky.el --- Jump between points like a rabbit -*- lexical-binding: t -*-

;; Copyright (C) 2023-2025 Eki Zhang

;; Author: Eki Zhang <liuyinz95@gmail.com>
;; Maintainer: Eki Zhang <liuyinz95@gmail.com>
;; Version: 2.1.0
;; Package-Requires: ((emacs "29.1") (dash "2.19.1"))
;; Keywords: convenience
;; Homepage: https://github.com/eki3z/binky.el

;; This file is not a part of GNU Emacs.

;; This program is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program.  If not, see <https://www.gnu.org/licenses/>.

;;; Commentary:

;; This package provides commands to jump between points in buffers and files.
;; Pin position, float position and last jump position are all supported in
;; same mechanism like `point-to-register' and `register-to-point' but with an
;; enhanced experience.

;; TODO rewrite with pcase

;;; Code:

(require 'cl-lib)
(require 'subr-x)
(require 'pulse)
(require 'pcase)
(require 'crm)

(require 'dash)

(declare-function ffip-project-root "find-file-in-project")
(declare-function project-root "project")
(declare-function projectile-project-root "projectile")

;;; Customize

(defgroup binky nil
  "Jump between points like a rabbit."
  :prefix "binky-"
  :group 'convenience
  :link '(url-link :tag "Repository" "https://github.com/eki3z/binky.el"))

(defcustom binky-debug nil
  "Whether or not to output debug messages while in operation.
Messages are written into the *binky-debug* buffer."
  :type 'boolean)

(defcustom binky-project-detection 'auto
  "How to detect the project root of binky records.
nil means to use `default-directory'.
`auto' means to detect the following options in order."
  :type '(choice (const :tag "Auto-detect" auto)
                 (const :tag "Find File in Project" ffip)
                 (const :tag "Projectile" projectile)
                 (const :tag "Built-in Project" project)
                 (const :tag "Disable" nil))
  :package-version '(binky . "1.3.0")
  :group 'binky)

(defcustom binky-prune nil
  "If non-nil, delete related record when buffer was killed."
  :type 'boolean
  :group 'binky)

(defcustom binky-preview-delay 0.5
  "If non-nil, time to wait in seconds before popping up a preview window.
If nil, disable preview, unless \\[help] is pressed."
  :type '(choice number (const :tag "No preview unless requested" nil))
  :group 'binky)

(defcustom binky-preview-side 'bottom
  "Which side to popup preview buffer."
  :type '(choice (const top)
                 (const bottom)
				 (cosnt left)
				 (cosnt right))
  :group 'binky)

(defcustom binky-preview-column
  '((mark    0.03  4)
    (name    0.14  15)
    (line    0.04  6)
    (project 0.14  nil)
    (mode    0.10  nil)
    (context 0     nil))
  "List of elements (COLUMN VERTICAL HORIZONTAL) to display in preview.
COLUMN is one of five properties of record below:

The `mark' is column to show mark.
The `name' is column to show buffer name.
The `line' is column to show line number.
The `mode' is column to show major mode.
The `project' is column to show belonging project.
The `context' is column to show content of line which record located.

VERTICAL and HORIZONTAL are width of the COLUMN depended on
`binky-preview-side'.  VERTICAL used for `top' and `bottom',
HORIZONTAL used for `left' and `right'.
If it's is nil, then COLUMN would not be displayed.
If it's 0, the COLUMN would not be truncated.
If it's a integer, the COLUMN width would be truncated to the upper limit.
If it's float number between 0 and 1, then upper limit is calculated based on
current frame width.
Usually, `context' column should be placed at the end and not truncated."
  :type '(alist
          :key-type symbol
          :options '(mark name line project mode context)
		  :value-type (group (choice number (const nil))
							 (choice number (const nil))))
  :package-version '(binky . "1.3.0")
  :group 'binky)

(defcustom binky-preview-ellipsis ".."
  "String used to abbreviate text in preview."
  :type 'string
  :group 'binky)

(defcustom binky-preview-in-groups nil
  "If non-nil, preview pin records in group by buffer."
  :type 'boolean
  :package-version '(binky . "1.2.1")
  :group 'binky)

(defcustom binky-preview-show-header t
  "If non-nil, showing header in preview."
  :type 'boolean
  :group 'binky)

(defcustom binky-hl-use-pulse t
  "If non-nil, pulse-style highlight would be applied when it's available.
Otherwise, use blink-style instead."
  :type 'boolean
  :package-version '(binky . "1.3.2")
  :group 'binky)

(defcustom binky-hl-duration 0.4
  "If non-nil, used as time in seconds to highlight the line record located.
If nil, disable the highlight feature."
  :type '(choice number (const :tag "Disable highlight" nil))
  :package-version '(binky . "1.3.2")
  :group 'binky)

(defcustom binky-indicator-side 'left
  "Which side to show indicator in window."
  :type '(choice (const left)
                 (const right))
  :package-version '(binky . "1.2.2")
  :group 'binky)

(defcustom binky-cache-directory (locate-user-emacs-file "binky/cache/")
  "Cache directory to store pin records of `binky-records'."
  :type 'directory
  :package-version '(binky . "1.4.1")
  :group 'binky)

;; Faces

(defgroup binky-faces nil
  "The faces of `binky'."
  :group 'binky
  :group 'faces
  :package-version '(binky . "1.3.2"))

(defface binky-preview
  '((t (:italic nil :underline nil :inverse-video nil)))
  "Default face."
  :package-version '(binky . "1.3.2")
  :group 'binky-faces)

(defface binky-preview-mark-float
  '((t (:inherit (binky-preview bold)
        :foreground "violet")))
  "Face used to highlight the float mark of record in preview."
  :package-version '(binky . "1.3.2")
  :group 'binky-faces)

(defface binky-preview-mark-pin
  '((t (:inherit (binky-preview bold)
        :foreground "#5ec4ff")))
  "Face used to highlight the pin mark of record in preview."
  :package-version '(binky . "1.3.2")
  :group 'binky-faces)

(defface binky-preview-mark-back
  '((t (:inherit (binky-preview bold)
        :foreground "#ebbf83")))
  "Face used to highlight the back mark of record in preview."
  :package-version '(binky . "1.3.2")
  :group 'binky-faces)

(defface binky-preview-header
  '((t (:inherit (binky-preview bold)
        :underline t
        :foreground "#8bd49c")))
  "Face used to highlight the header in preview buffer."
  :package-version '(binky . "1.3.2")
  :group 'binky-faces)

(defface binky-preview-name
  '((t (:inherit (binky-preview default))))
  "Face used to highlight the name of record in preview."
  :package-version '(binky . "1.3.2")
  :group 'binky-faces)

(defface binky-preview-name-same
  '((t (:inherit binky-preview-name
        :underline t)))
  "Face used to highlight the name of record in same buffer in preview."
  :package-version '(binky . "1.3.2")
  :group 'binky-faces)

(defface binky-preview-line
  '((t (:inherit binky-preview-mark-pin
        :bold nil)))
  "Face used to highlight the line number of record in preview."
  :package-version '(binky . "1.3.2")
  :group 'binky-faces)

(defface binky-preview-mode
  '((t (:inherit binky-preview-mark-float
        :bold nil)))
  "Face used to highlight the major mode of record in preview."
  :package-version '(binky . "1.3.2")
  :group 'binky-faces)

(defface binky-preview-project
  '((t (:inherit binky-preview-mark-back
        :bold nil)))
  "Face used to highlight the project directory of record in preview."
  :package-version '(binky . "1.3.2")
  :group 'binky-faces)

(defface binky-preview-killed
  '((t (:inherit (binky-preview font-lock-comment-face))))
  "Face used to highlight whole record of killed buffers in preview."
  :package-version '(binky . "1.3.2")
  :group 'binky-faces)

(defface binky-hl
  `((t (:foreground ,(face-foreground 'default)
        :extend t)))
  "Face used to highlight the line added to record."
  :package-version '(binky . "1.3.2")
  :group 'binky-faces)

(defface binky-hl-add-pin
  `((t (:inherit binky-hl
        :background ,(face-foreground 'binky-preview-mark-pin))))
  "Face used to highlight the line added to record."
  :package-version '(binky . "1.3.2")
  :group 'binky-faces)

(defface binky-hl-add-float
  `((t (:inherit binky-hl
        :background ,(face-foreground 'binky-preview-mark-float))))
  "Face used to highlight the line added to record."
  :package-version '(binky . "1.3.2")
  :group 'binky-faces)

(defface binky-hl-delete
  `((t (:inherit binky-hl
        :background "#e27e8d")))
  "Face used to highlight the line deleted from record."
  :package-version '(binky . "1.3.2")
  :group 'binky-faces)

(defface binky-hl-warn
  `((t (:inherit binky-hl
        :background "#ebbf83")))
  "Face used to highlight the line already record."
  :package-version '(binky . "1.3.2")
  :group 'binky-faces)

(defface binky-hl-jump
  `((t (:inherit binky-hl
        :background "#8bd49c")))
  "Face used to highlight the line jumped to."
  :package-version '(binky . "1.3.2")
  :group 'binky-faces)

(defface binky-hl-view
  `((t (:inherit binky-hl
        :background "#8bd49c")))
  "Face used to highlight the line viewed."
  :package-version '(binky . "1.3.2")
  :group 'binky-faces)


;;; Variables

(defvar binky-records nil)

(defvar binky-current-buffer nil
  "Buffer where binky command called from.")

(defvar binky-current-type nil
  "Type of `last-input-event'.")

(defvar binky-record-update-hook nil
  "Hook run when `binky-records' changes.")

(defvar-local binky-project-root nil
  "Project path of current buffer located.")

(defvar-local binky-marked nil
  "If non-nil, the buffer was once recorded by binky.")

(defvar-local binky-hl-overlay nil
  "Overlay used to highlight the line operated on.")


;;; Functions

(defun binky--debug (msg &rest args)
  "Print information into *binky-debug* if `binky-debug' is non-nil.
MSG and ARGS format is as same as `format' command."
  (when binky-debug
    (with-current-buffer "*binky-debug*"
      (unless (derived-mode-p 'special-mode)
        (special-mode))
      (goto-char (point-max))
      (let ((inhibit-read-only t))
        (insert (apply #'format msg args))
        (newline)))))

(defun binky--key (key)
  "Return a pretty description of a character event KEY for binky."
  (and key (single-key-description key t)))

(defun binky--message (mark status &optional duration)
  "Echo information about MARK according to STATUS.
Wait for DURATION seconds and then redisplay."
  (let ((mark (propertize (binky--key mark) 'face 'binky-preview-mark-pin))
        (msg (pcase status
               ('invalid    "is invalid")
               ('backed     "can not be add or delete manualy")
               ('floated    "has already floated the current buffer")
               ('pinned     "has already pinned the current line")
               ('used       "has already been used")
               ('same-line  "already on the same line")
               ('non-exist  "doesn't exist")
               ('group      "toggle preview in group"))))
    (message "Binky: %s %s." mark msg)
    (sit-for (or duration 0.8) t)))

(defun binky--marker (&optional position)
  "Return a marker at point or POSITION and record the buffer by binky.
Optional arg POSITION could be a marker or number."
  (setq-local binky-marked t)
  (copy-marker (or position (point))))

(defun binky--marked-p (buffer)
  "Return t if BUFFER was once marked by binky."
  (or (buffer-local-value 'binky-marked buffer) nil))

(defun binky-project-root ()
  "Get the path to the project root.
Return nil if no project was found."
  (with-memoization binky-project-root
    (and (buffer-file-name)
         (cond
          ((and (memq binky-project-detection '(auto ffip))
                (fboundp 'ffip-project-root))
           (let ((inhibit-message t))
             (ffip-project-root)))
          ((and (memq binky-project-detection '(auto projectile))
                (bound-and-true-p projectile-mode))
           (projectile-project-root))
          ((and (memq binky-project-detection '(auto project))
                (fboundp 'project-current))
           (when-let* ((project (project-current)))
             (expand-file-name
              (if (fboundp 'project-root)
                  (project-root project)
                (car (with-no-warnings
                       (project-roots project)))))))))))

(defun binky--same-line (x y)
  "Return non-nil if marker X and Y on the same line."
  (and (markerp x) (markerp y)
       (eq (marker-buffer x) (marker-buffer y))
       (with-current-buffer (marker-buffer x)
         (equal (line-number-at-pos x 'absolute)
                (line-number-at-pos y 'absolute)))))

(defun binky--parse (record)
  "Parse RECORD and return list of properties.
With format (mark marker buffer name line project mode context file position)."
  (if-let* ((mark (car record))
            (type (nth 1 record))
            (marker (and (markerp (nth 2 record)) (nth 2 record)))
            (position (marker-position marker))
            (buffer (marker-buffer marker)))
      (with-current-buffer buffer
        (list mark type marker buffer
              (buffer-name) (buffer-file-name)
              (file-name-nondirectory
               (directory-file-name (or (binky-project-root)
                                        default-directory)))
              (symbol-name major-mode)
              (line-number-at-pos position 'absolute)
              position
              (save-excursion
                (goto-char marker)
                (buffer-substring (line-beginning-position)
                                  (line-end-position)))))
    record))

(defun binky--prop (record prop)
  "Return the PROP of RECORD, or nil if none."
  (let ((record (binky--parse record)))
    (pcase prop
      (:mark     (nth 0 record))
      (:type     (nth 1 record))
      (:marker   (nth 2 record))
      (:buffer   (nth 3 record))
      (:name     (nth 4 record))
      (:file     (nth 5 record))
      (:project  (nth 6 record))
      (:mode     (nth 7 record))
      (:line     (nth 8 record))
      (:position (nth 9 record))
      (:context  (nth 10 record)))))

(defun binky--record (mark)
  "Return records related to MARK if found, or return nil."
  (assoc mark binky-records))

;; TODO refactor with multi filter instead of nested
(defmacro binky--filter (prop form alist)
  "Return records in ALIST filtered by PROP for which FORM return non-nil.
ALIST must be a binky records list."
  `(--filter (let ((it (binky--prop it ,prop))) ,form) ,alist))

(defun binky--auto-update ()
  "Update back and float type records in `binky-records' automatically."
  ;; delete back record if buffer not exists
  (let ((orig (-clone binky-records)))
    (--each (->> binky-records (binky--filter :type (memq it '(back float))))
      (-let [(mark type marker) it]
        (if-let* ((buf (marker-buffer marker))
                  ((buffer-live-p buf))
                  (new-marker (with-current-buffer buf (point-marker))))
            (when (and (eq type 'float)
                       ;; NOTE in `buffer-list-update-hook', `current-buffer' point to
                       ;; changed buffer, so use `(car (buffer-list))' to get buffer
                       ;; pointed instead.
                       (not (eq buf (nth (if (minibufferp (current-buffer)) 1 0)
                                         (buffer-list)))))
              (unless (binky--same-line new-marker marker)
                (setf (alist-get mark binky-records)
                      (list 'float (binky--marker new-marker)))))
          (setf (alist-get mark binky-records nil 'remove) nil))))
    (unless (equal orig binky-records)
      (run-hooks 'binky-record-update-hook))))

(defun binky--swap-out ()
  "Turn pin records into list of props when a buffer is killed."
  (when-let* ((to-swap (->> binky-records
                           (binky--filter :type (eq it 'pin))
                           (binky--filter :buffer (eq it (current-buffer))))))
    (--each to-swap
      (let ((mark (car it)))
        (if (and (buffer-file-name) (null binky-prune))
            (setcdr (alist-get mark binky-records)
                    (-concat '(nil nil) (-take-last 7 (binky--parse it))))
          (setf (alist-get mark binky-records nil 'remove) nil))))
    (run-hooks 'binky-record-update-hook)))

(defun binky--swap-in ()
  "Turn record from list of infos into marker when a buffer is reopened."
  (when-let* ((to-swap (binky--filter :file (string= it (buffer-file-name))
                                     binky-records)))
    (--each to-swap
      (setcdr (alist-get (nth 0 it) binky-records)
              (list (binky--marker (binky--prop it :position)))))
    (run-hooks 'binky-record-update-hook)))

(defun binky--pin-group (order &optional name)
  "Return alist of pin records in same buffer or file.
NAME is a buffer name, if nil current buffer name is used.
ORDER is `<' or `>' to sort records by position, otherwise no sorting."
  (-sort (-on order (-rpartial #'binky--prop :position))
         (->> binky-records
              (binky--filter :type (eq it 'pin))
              (binky--filter :name (string= it (or name (buffer-name)))))))

(defun binky--pin-preview ()
  "Return pin alist for preview."
  (let ((pin-records (binky--filter :type (eq it 'pin) binky-records)))
    (if binky-preview-in-groups
        (cl-loop for name in (-uniq (--map (binky--prop it :name) pin-records))
                 for group = (binky--pin-group #'< name)
                 if (not (get-buffer name))
                 append group into killed
                 else if (equal name (buffer-name binky-current-buffer))
                 append group into same
                 else append group into live
                 finally return (-concat same live killed))
      pin-records)))

(defun binky--preview-horizontal-p ()
  "Return non-nil if binky preview buffer in horizontally."
  (memq binky-preview-side '(left right)))

(defun binky--preview-column ()
  "Return alist of elements (COLUMN . WIDTH) to display preview."
  (-filter #'cdr
           (--map (let ((width (nth (if (binky--preview-horizontal-p) 2 1) it)))
  					(cons (nth 0 it)
                          (ignore-errors
                            (if (< 0 width 1)
                                (ceiling (* width (frame-width)))
                              width))))
  				  binky-preview-column)))

(defun binky--preview-extract (alist)
  "Return truncated string with selected columns according to ALIST."
  (format "%s%s\n"
          (if (binky--preview-horizontal-p) "" "  ")
          (string-join
           (--map (let* ((limit (cdr it))
					     (str (alist-get (car it) alist))
                         (end (max limit (string-width (symbol-name (car it))))))
			        (if (zerop limit)
                        str
                      ;; FIXME align error if buffer name contain punctuation
                      ;; character "—", use such as `string-pixel-width'
                      (truncate-string-to-width str end nil ?\s
                                                binky-preview-ellipsis)))
                  (binky--preview-column))
           "  ")))

(defun binky--preview-propertize (record)
  "Return formatted string for RECORD in preview."
  (let ((killed (not (binky--prop record :marker))))
    (cons (cons 'mark (concat "  " (binky--mark-propertize record nil killed)))
          (--zip-with
           (let ((column-face (intern (concat "binky-preview-" (symbol-name it)))))
             (cons it (if (or killed (facep column-face))
                          (propertize
                           other 'face
                           (cond (killed 'binky-preview-killed)
                                 ((and (eq it 'name)
                                       (equal other (buffer-name binky-current-buffer)))
                                  'binky-preview-name-same)
                                 (t column-face)))
                        other)))
           '(name line project mode context)
           (list (binky--prop record :name)
		         (number-to-string (binky--prop record :line))
                 (binky--prop record :project)
		         (string-remove-suffix "-mode" (binky--prop record :mode))
		         (string-trim (binky--prop record :context)))))))

(defun binky--preview-header ()
  "Return formatted string of header for preview."
  (binky--preview-extract
   (--map (cons (car it) (propertize (symbol-name (car it)) 'face 'binky-preview-header))
		  (binky--preview-column))))

(defun binky--preview (&optional action)
  "Toggle preview window on the side `binky-preview-side'.
If optional arg ACTION is `close', close preview, if it's `redisplay',
redisplay the preview.  If it's nil, toggle the preview."
  (let ((prev-buf "*binky-preview*"))
    (if (or (eq action 'close)
            (and (null action)
                 (get-buffer-window prev-buf)))
        (let* ((win (get-buffer-window prev-buf)))
          (and (window-live-p win) (delete-window win))
          (and (get-buffer prev-buf) (kill-buffer prev-buf)))
	  (with-current-buffer-window
          prev-buf
		  (cons 'display-buffer-in-side-window
			    `((side          . ,binky-preview-side)
                  (window-height . fit-window-to-buffer)
                  (window-width  . fit-window-to-buffer)))
          nil
        (erase-buffer)
        (let* ((total (-map #'binky--preview-propertize
                            (-concat (binky--filter :type (eq it 'back) binky-records)
                                     (binky--filter :type (eq it 'float) binky-records)
                                     (binky--pin-preview))))
		       (back (and-let* ((back-r (binky--record ?'))
                                ((binky--preview-propertize back-r)))))
		       (dup (and back (rassoc (cdr back) (cdr total)))))
	      ;; insert header if non-nil
	      (when (and (-some #'integerp (-map #'cdr (binky--preview-column)))
			         binky-preview-show-header)
	        (insert (binky--preview-header)))
	      (when dup
	        (setf (cdar dup)
			      (concat (substring (cdar back) -1) (substring (cdar dup) 1))))
          (--each (if dup (cdr total) total)
            (insert (binky--preview-extract it))))
        (setq-local window-min-height 1)
        (setq-local fit-window-to-buffer-horizontally t)
        (setq-local cursor-in-non-selected-windows nil)
	    (setq-local mode-line-format nil)
	    (setq-local truncate-lines t)
        (setq-local buffer-read-only t)))))

(defun binky--highlight (type-name)
  "Highlight the current line with TYPE-NAME related face."
  (when (and (numberp binky-hl-duration)
		     (> binky-hl-duration 0))
    (let ((beg (line-beginning-position))
          (end (line-beginning-position 2))
          (face (intern (concat "binky-hl-" type-name))))
      (if (overlayp binky-hl-overlay)
          (move-overlay binky-hl-overlay beg end)
	    (setq binky-hl-overlay (make-overlay beg end)))
      ;; NOTE only highlight line in selected window
	  (overlay-put binky-hl-overlay 'window (selected-window))
      (if (and binky-hl-use-pulse (pulse-available-p))
          (let* ((pulse-flag t)
                 (pulse-iterations 20)
                 (pulse-delay (/ binky-hl-duration pulse-iterations)))
            (overlay-put binky-hl-overlay 'pulse-delete t)
            ;; NOTE must set :background attribute directly in face, don't
            ;; use :inverse-video etc which don't take effect in pulse
            (pulse-momentary-highlight-overlay binky-hl-overlay face))
        (overlay-put binky-hl-overlay 'face face)
        (sit-for binky-hl-duration)
        (delete-overlay binky-hl-overlay)))))

(defun binky--mark-propertize (record &optional replace-string killed)
  "Return propertized string of mark character of RECORD.
If REPLACE-STRING is non-nil, return it rather than mark.  If KILLED is non-nil,
face `binky-preview-killed' is used instead."
  (propertize (or replace-string (binky--key (nth 0 record))) 'face
              (if killed
                  'binky-preview-killed
                (intern (concat "binky-preview-mark-"
                                (symbol-name (binky--prop record :type)))))))

(defun binky--mark-type (mark)
  "Return type of MARK and update `binky-current-type' if needed.
The `group' means to toggle records preview in groups or not.
The `toggle' means to show or hide preview window.
The `quit' means to quit the command.
The `other' means to jump to record in other window.
The `view' means to view record in other window without jumping.
The `delete' means to delete next record.
The `float' means to add float mark.
The `valid' means to add or jump to mark.
The `invalid' means mark is invalid."
  (let* ((case-fold-search nil)
         (type (pcase (binky--key mark)
                 ("SPC" 'group)
                 ("TAB" 'toggle)
                 ((or "ESC" "C-g") 'quit)
                 (";" 'jump-other)
                 ("," 'view)
                 ("." 'delete)
                 ((pred (string-match-p "^[A-Z]$")) 'float)
                 ((pred (string-match-p "^[a-z']$")) 'valid)
                 (_ 'invalid))))
    (if (eq type 'valid)
        (when (not (memq binky-current-type '(jump-other view delete float)))
          (setq binky-current-type 'pin-or-jump))
      (setq binky-current-type type))
    type))

(defun binky--mark-read (action &optional preview)
  "Read and return a MARK possibly with preview.
Prompt with the string ACTION and  may display a window listing existing
records after `binky-preview-delay' seconds.  When PREVIEW is non-nil,
preview records at once.

Press TAB key to toggle preview window display or not.
Press SPC key to toggle preview window to display in groups or not.
Press ESC key to quit."
  (setq binky-current-buffer (current-buffer))
  (and preview (binky--preview 'redisplay))
  (let ((timer (when (and (numberp binky-preview-delay)
                          (null preview))
		         (run-with-timer binky-preview-delay nil
                                 (apply-partially #'binky--preview 'redisplay)))))
    (unwind-protect
        (progn
          (setq binky-current-type nil)
		  (while (not (memq (binky--mark-type (read-key (concat "Binky " action " :")))
                            '(quit float valid)))
            (pcase binky-current-type
              ('toggle (binky--preview))
              ('jump-other (setq action "jump to other window"))
              ('view (setq action "view"))
              ('delete (setq action "delete"))
              ('invalid (binky--message last-input-event 'invalid))
              ('group
               (progn
                 (setq binky-preview-in-groups (not binky-preview-in-groups))
                 (binky--preview 'redisplay)
                 (binky--message last-input-event 'group)))))
		  (if (eq binky-current-type 'quit)
              (keyboard-quit)
            (downcase last-input-event)))
	  (and (timerp timer) (cancel-timer timer))
      (when (or (eq binky-current-type 'quit) (null preview))
        (binky--preview 'close)))))

(defun binky--mark-add (mark &optional float-p)
  "Add (MARK . MARKER) into records according to FLOAT-P."
  (cond
   ((eq major-mode 'xwidget-webkit-mode)
    (message "%s is not allowed" major-mode))
   ((eq mark ?')
    (binky--message mark 'backed))
   ((binky--record mark)
    (save-excursion
      (goto-char (nth 2 (binky--record mark)))
      (binky--highlight "warn"))
    (binky--message mark 'used))
   (t
    (let ((lst (->> binky-records
                    (binky--filter :type (eq it (if float-p 'float 'pin)))
                    (binky--filter :buffer (eq it (current-buffer))))))
      (if (and float-p lst)
          (progn
            (binky--highlight "warn")
            (binky--message (caar lst) 'floated))
        (if-let*  (((not float-p))
                 (dup (binky--filter :line (equal it (line-number-at-pos (point) t)) lst)))
            (progn
              (binky--highlight "warn")
              (binky--message (caar dup) 'pinned))
          (binky--highlight (concat "add-" (if float-p "float" "pin")))
          (setf (alist-get mark binky-records)
                (list (if float-p 'float 'pin) (binky--marker)))
          (run-hooks 'binky-record-update-hook)))))))

(defun binky--mark-delete (mark)
  "Delete record relate to MARK from `binky-records'."
  (if (eq mark ?')
      (binky--message mark 'backed)
    (if-let*  ((record (binky--record mark)))
        (progn
          (when-let* ((buf (binky--prop record :buffer)))
            (save-excursion
              (with-current-buffer buf
                (goto-char (binky--prop record :position))
                (binky--highlight "delete"))))
          (setf (alist-get mark binky-records nil 'remove) nil)
          (run-hooks 'binky-record-update-hook))
      (binky--message mark 'non-exist))))

(defun binky--mark-jump (mark &optional other)
  "Jump to point related to MARK in records.
If optional arg OTHER is non-nil, jump to other window."
  (if-let* ((record (binky--record mark))
            (last (point-marker)))
      (let* ((target (binky--prop record :marker))
             (pos (binky--prop record :position))
             (buf (and (markerp target) (marker-buffer target))))
        ;; if other is true, select window follow the order:
        (if (and other buf)
            ;; if non-seleted windows contain buf exists
            (if-let*  ((win-list (delete (selected-window)
                                       (get-buffer-window-list buf 'not-minibuf))))
                (select-window
                 ;; 1. goto window which contain target first if exists
                 (or (--first (<= (window-start it) pos (window-end it)) win-list)
                     ;; 2. goto window which display buf if exists
                     (car win-list)))
              ;; 3. switch to other window with buf
              (switch-to-buffer-other-window buf))
          ;; 4. if buf not live, switch to other window with current-buffer
          (and other (switch-to-buffer-other-window (current-buffer)))
          (if buf
              (unless (eq (current-buffer) buf)
                (switch-to-buffer buf))
            (find-file (binky--prop record :file))))
        (goto-char pos)
        (if (binky--same-line last (or target (point-marker)))
            (progn
              (binky--highlight "warn")
              (binky--message mark 'same-line))
          (binky--highlight "jump")
          (setf (alist-get ?' binky-records)
                (list 'back (binky--marker last)))
          (run-hooks 'binky-record-update-hook)))
    (binky--message mark 'non-exist)))

;; TODO rewrite function as jump-other-window
(defun binky--mark-view (mark)
  "View the point in other window according to MARK."
  (if-let* ((record (binky--record mark)))
      (progn
        (unless (binky--prop record :marker)
          (find-file-noselect (binky--prop record :file)))
        (let ((pop-up-windows t))
          (save-selected-window
            (pop-to-buffer (binky--prop record :name) t 'norecord)
            (goto-char (binky--prop record :position))
            (binky--highlight "view"))))
    (binky--message mark 'non-exist)))


;;; Commands

;;;###autoload
(defun binky-binky (&optional persist)
  "Add, delete or jump with marked records in one command.
If prefix type is delete, then call `binky--mark-delete'.
If prefix type is jump-other, then call `binky--mark-jump' to other window.
If prefix type is view, then call `binky--mark-view'.
If prefix is nil and mark exists, then call `binky--mark-jump', or call
`binky--mark-add', when adding a mark, if it is upcase then add a float mark,
or add a pin mark.

Interactively, PERSIST is the prefix argument.  With no prefix argument,
it works as same as single command.  With a prefix argument, repeating commands
until \\[keyboard-quit] pressed."
  (interactive "P")
  ;; TODO show persist info in prompt
  (let ((mark (binky--mark-read "binky" persist)))
    (pcase binky-current-type
      ('delete (binky--mark-delete mark))
      ('jump-other (binky--mark-jump mark t))
      ('view (binky--mark-view mark))
      ('float (binky--mark-add mark 'float))
      (_ (if (or (binky--record mark)
                 (eq mark ?'))
	         (binky--mark-jump mark)
           (binky--mark-add mark))))
    (setq binky-current-type nil)
    (when persist
      (binky--preview 'redisplay)
      (call-interactively #'binky-binky))))

;;;###autoload
(defun binky-next-in-buffer (&optional backward)
  "Jump to next pin record in current buffer if exists.
If BACKWARD is non-nil, jump to previous one."
  (interactive)
  (if-let* ((order (if backward #'> #'<))
            (sorted (binky--pin-group order)))
      (if (and (equal (length sorted) 1)
               (binky--same-line (point-marker) (caddar sorted)))
          (message "Point is on the only pin record in current buffer.")
        (binky--mark-jump
         (car (or (--first (funcall order (point) (binky--prop it :position)) sorted)
                  (car sorted)))))
    (message "No records in current buffer.")))

;;;###autoload
(defun binky-previous-in-buffer ()
  "Jump to previous pin record in current buffer if exists."
  (interactive)
  (binky-next-in-buffer t))

(defun binky-select-cache (file prompt &optional mustmatch)
  "Return binky cache FILE.
Prompting with PROMPT and MUSTMATCH if called interactively, otherwise return
FILE or default cache."
  (if current-prefix-arg
      (read-file-name prompt binky-cache-directory nil mustmatch)
    (expand-file-name (or file "default.eld") binky-cache-directory)))

;;;###autoload
(defun binky-save (&optional file)
  "Save pin records information to FILE.
If optional argument FILE is nil, choose default file instead."
  (interactive)
  (when-let* ((output (binky-select-cache file "[Binky] save records to: ")))
    (make-directory binky-cache-directory t)
    (with-temp-file output
      (let ((print-level nil)
            (print-length nil))
        (pp (--map (->> (binky--parse it) (-replace-at 2 nil) (-replace-at 3 nil))
                   (->> binky-records
                        (binky--filter :file (stringp it))
                        (binky--filter :type (eq it 'pin))))
            (current-buffer))))))

;;;###autoload
(defun binky-restore (&optional file)
  "Restore pin records information from FILE.
This command will overwrite pin records by force."
  (interactive)
  (when-let* ((input (binky-select-cache file "[Binky] read records from: " t))
              ((file-exists-p input)))
    (with-temp-buffer
      (insert-file-contents input)
      (setq binky-records
            (--map (if-let*  ((buf (get-file-buffer (binky--prop it :file))))
                       (with-current-buffer buf
                         (cons (-take 2 it)
                               (list (binky--marker (binky--prop it :position)))))
                     it)
                   (read (current-buffer))))
      (run-hooks 'binky-record-update-hook))))

;;;###autoload
(defun binky-clean (&optional all)
  "Cleanup records in selected buffers, files or ALL positions."
  (interactive "P")
  (if (null all)
      (let* ((target (-uniq (--map (binky--prop it :name) binky-records)))
             (selected (completing-read-multiple "[Binky] clean records in: " target)))
        (setq binky-records (--remove (member (binky--prop it :name) selected)
                                      binky-records)))
    (setq binky-records nil)
    (message "Cleanup all binky records."))
  (run-hooks 'binky-record-update-hook))


;;; Minor mode

;;;###autoload
(define-minor-mode binky-mode
  "Toggle rabbit-jumping style position changes.
This global minor mode allows you to jump easily between buffers
you used and marked position."
  :group 'binky
  :global t
  (--each '((buffer-list-update-hook . binky--auto-update)
            (kill-buffer-hook        . binky--swap-out)
            (find-file-hook          . binky--swap-in))
    (-let [(hook . func) it]
      (funcall (if binky-mode #'add-hook #'remove-hook) hook func))))

(provide 'binky)
;;; binky.el ends here
