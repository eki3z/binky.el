;;; binky-margin.el --- Highlight binky records on margins -*- lexical-binding: t -*-

;; Copyright (C) 2023, 2025 liuyinz

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

;; This is a global mode, it enables `binky-mode' to use margin as highlight records,
;; type `M-x binky-margin-mode'.

;;; Code:

(require 'binky)

(defvar-local binky-margin-width-orig nil
  "Default margin width of user setting.")

(defgroup binky-margin nil
  "Highlight binky records on margins."
  :group 'binky)

(defcustom binky-margin-string "\x2691"
  "Which string to show as margin indicator.
If nil, mark character would be used instead.  Recommendation as follow:
\\x2590 => ▐, \\x2665 => ♥, \\x2630 => ☰, \\x2691 => ⚑, \\x221a => √, \\x229b => ⊛."
  :type '(choice string (const :tag "Use mark character" nil))
  :group 'binky-margin)

(defun binky-margin--spec (record)
  "Return margin display string according to RECORD if provided."
  (propertize " " 'display
              `((margin ,(intern (format "%s-margin" binky-indicator-side)))
                ,(binky--mark-propertize record binky-margin-string))))

(defun binky-margin--local-update (&optional update)
  "Remove margin indicators in current buffer and update if UPDATE is non-nil."
  ;; delete all overlays in buffer
  (save-restriction
    (widen)
    (--each (overlays-in (point-min) (point-max))
      (when (overlay-get it 'binky) (delete-overlay it))))
  (when update
    (--each
        (let* ((orig (binky--filter :buffer (eq it (current-buffer)) binky-records))
               (sorted (-mapcat
                        (lambda (type) (binky--filter :type (eq it type) orig))
                        '(back pin float))))
          ;; NOTE remove duplicate marks on same line to ensure priority of
          ;; back > pin > float
          (cl-remove-duplicates sorted :key (lambda (r) (binky--prop r :line))
                                       :test 'equal
                                       :from-end t))
      (let* ((pos (binky--prop it :position))
             (ov (make-overlay pos pos)))
        (overlay-put ov 'binky t)
        (overlay-put ov 'before-string (binky-margin--spec it))))))

(defun binky-margin--update ()
  "Remove and update margin indicators in all marked buffers if needed."
  (--each (-filter #'binky--marked-p (buffer-list))
    (with-current-buffer it
      ;; delete overlays
      (binky-margin--local-update
       (and (bound-and-true-p binky-mode)
            (bound-and-true-p binky-margin-mode)
            (bound-and-true-p binky-margin-local-mode))))))

;;;###autoload
(defun binky-margin-turn-on-maybe ()
  "Turn on `binky-margin-local-mode' if available."
  (when (and (bound-and-true-p binky-mode)
             (bound-and-true-p binky-margin-mode))
    (binky-margin-local-mode 1)))

;;;###autoload
(define-minor-mode binky-margin-local-mode
  "Toggle displaying indicators on the margin locally.
You probably shouldn't use this function directly."
  :group 'binky-margin
  :lighter ""
  (let ((width-var (intern (format "%s-margin-width" binky-indicator-side))))
    (if binky-margin-local-mode
        (progn
          (setq-local binky-margin-width-orig width-var)
          (setq width-var 1))
      (setq width-var binky-margin-width-orig)
      (setq binky-margin-width-orig nil)))
  (--each (get-buffer-window-list)
    (set-window-buffer it (current-buffer)))
  (binky-margin--local-update binky-margin-local-mode))

;;;###autoload
(define-global-minor-mode binky-margin-mode
  binky-margin-local-mode binky-margin-turn-on-maybe
  :group 'binky-margin
  (--each '(binky-mode-hook binky-record-update-hook)
    (funcall (if binky-margin-mode #'add-hook #'remove-hook)
             it #'binky-margin--update)))

(provide 'binky-margin)
;;; binky-margin.el ends here
