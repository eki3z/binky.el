# Changelog

## [2.2.0](https://github.com/eki3z/binky.el/compare/v2.1.0..v2.2.0) - 2025-01-23

### Features

- add command binky-clean - ([604cbee](https://github.com/eki3z/binky.el/commit/604cbee86e829f9db47887e092b0835a6dbf47dd))

### Miscellaneous Chores

- update author and homepage - ([49e3dc4](https://github.com/eki3z/binky.el/commit/49e3dc4b0663837ea55694fa230ff5258ca8788d))
- update cliff.toml - ([b598ca1](https://github.com/eki3z/binky.el/commit/b598ca17f11eb8b76bb53d441951cd3390948c3c))

### Refactoring

- use action{;,.} replace ctrl,alt,ctrl-shift- prefix - ([39c1a1e](https://github.com/eki3z/binky.el/commit/39c1a1e78aea36f79104fdc256949901e3d3d2c0))

## [2.1.0](https://github.com/eki3z/binky.el/compare/v2.0.0..v2.1.0) - 2024-05-19

### Bug Fixes

- clarify binky operation is illegal or back - ([5a03275](https://github.com/eki3z/binky.el/commit/5a03275c5dbe537c91db02fabf9706c0fd9fa14d))
- error when press ctrl-' and alt-' - ([fc3033b](https://github.com/eki3z/binky.el/commit/fc3033be09cb7e234395f483d29199e4d69b8471))

### Features

- when call binky-jump-other-window, select existed window and buffer as possible - ([3407be5](https://github.com/eki3z/binky.el/commit/3407be57768ff58b40434a883ed2501f8c1b4404))

### Refactoring

- function binky--mark-type - ([bcbb890](https://github.com/eki3z/binky.el/commit/bcbb8909d0e1d0ca1867f243f89615ed34714836))

## [2.0.0](https://github.com/eki3z/binky.el/compare/v1.4.2..v2.0.0) - 2024-05-17

### Bug Fixes

- remove repeat-mode support - ([8711a7b](https://github.com/eki3z/binky.el/commit/8711a7ba7b9045ee2788c023a2076559cd95feb6))
- correct type of binky-command-prefix - ([5e13f58](https://github.com/eki3z/binky.el/commit/5e13f5844aab20006301476c077cc0155a27d36a))
- typos in readme - ([046b839](https://github.com/eki3z/binky.el/commit/046b8392bae4f0c153e5909a7f7efca4d69c507d))

### Documentation

- add donate link - ([8b803aa](https://github.com/eki3z/binky.el/commit/8b803aa13ceaee30ea57af4c68156c003033fa6f))

### Features

- add option binky-debug - ([d8d30ea](https://github.com/eki3z/binky.el/commit/d8d30ea3d9ce6ccfd8b1254d8fabb86f3e44ed52))

### Miscellaneous Chores

- **(cliff)** adjust format - ([512c4f8](https://github.com/eki3z/binky.el/commit/512c4f833e2e0b488bc1151a346ffd2908db4b21))
- bump copyright years - ([9c0d99b](https://github.com/eki3z/binky.el/commit/9c0d99b345dc310a31a187c52d092965a26de70a))

### Refactoring

- use with-memoization instead - ([b91e67d](https://github.com/eki3z/binky.el/commit/b91e67d7b2d1641bcfd5a25cb74b14e97a956be9))
- simplify binky-preview function - ([0ae75d1](https://github.com/eki3z/binky.el/commit/0ae75d14f9ebef29c2083e71d3ea7931654656c6))
- [**breaking**] update new option to customize binky marks - ([bef6370](https://github.com/eki3z/binky.el/commit/bef63704dab53fb4e32605e099c9eb836e56811c))
- [**breaking**] provide new exclude method - ([d571705](https://github.com/eki3z/binky.el/commit/d5717053910f1d66f16c22a3d8834b43a507575e))
- use dash library instead - ([b7e1b34](https://github.com/eki3z/binky.el/commit/b7e1b34d20af171749e7ab0d91ba867ce938e089))

## [1.4.2](https://github.com/eki3z/binky.el/compare/v1.4.1..v1.4.2) - 2023-12-04

### Documentation

- **(README)** improve comparison experience - ([b27be66](https://github.com/eki3z/binky.el/commit/b27be6624cbdc509dd7b1320e36048e0a3eaa216))
- **(README)** update todo list - ([05792ad](https://github.com/eki3z/binky.el/commit/05792ad3b8b5f60f29a5f2b70eae25118b7056a3))
- update todo list - ([b4667b1](https://github.com/eki3z/binky.el/commit/b4667b1f17a496fc5986fa7f0003d935a07b872d))

### Features

- add option binky-command-prefix and binky-command-map - ([ecc7e9a](https://github.com/eki3z/binky.el/commit/ecc7e9a9a58d6335c41e900196fee610f78867fe))

### Refactoring

- change binky-cache-directory default value - ([bf9bd87](https://github.com/eki3z/binky.el/commit/bf9bd87c44cd5ca5ede0f080fa510240d948a644))

## [1.4.1](https://github.com/eki3z/binky.el/compare/v1.4.0..v1.4.1) - 2023-10-23

### Bug Fixes

- error type format in defcustom - ([a860fe2](https://github.com/eki3z/binky.el/commit/a860fe2a557cdcdc5153d55ed3ab3c42bc4987aa))
- add duplicete status to provide more accurate description - ([6dce296](https://github.com/eki3z/binky.el/commit/6dce29610c2262e2527b430cab4a51ee195282e4))
- wrong value type in defcustoms - ([76fbce5](https://github.com/eki3z/binky.el/commit/76fbce5b634eea0e04c3c996b2c2437bce15a7cb))
- do not highlighting overwritten record if binky-hl-use-pulse is t - ([f954896](https://github.com/eki3z/binky.el/commit/f954896d2add4eaef62326326d53b8779b9158f5))
- error warning before calling commands if binky mode is not enabled - ([d18d4e8](https://github.com/eki3z/binky.el/commit/d18d4e8b61426aa605bfdca0e6158784ebf59abb))

### Refactoring

- internal function binky--message - ([f37ecfd](https://github.com/eki3z/binky.el/commit/f37ecfdea20574d9464574d4bd21f983c9145312))
- internal functions and variables - ([382d1a1](https://github.com/eki3z/binky.el/commit/382d1a1aca192de1046c5e44bdfaa08560006cf2))

## [1.4.0](https://github.com/eki3z/binky.el/compare/v1.3.3..v1.4.0) - 2023-10-20

### Bug Fixes

- wrong overwrite message even add new mark - ([a50d016](https://github.com/eki3z/binky.el/commit/a50d016a751a23358f8f91c0ace63a87d2e5e00e))

### Features

- add command to read/save manual records from last session - ([bc07b17](https://github.com/eki3z/binky.el/commit/bc07b17338f7ea1ed7c152cc698f89d3a3cc5f71))
- support save and restore records with different source - ([838c188](https://github.com/eki3z/binky.el/commit/838c188358247d68b03b8c926629be189baae1f4))

### Refactoring

- internal function binky--auto-update - ([ded43d2](https://github.com/eki3z/binky.el/commit/ded43d2286d1f36e1aedc2b6778b706a5a84a9a4))
- rename commands binky-save/restore - ([7cb000b](https://github.com/eki3z/binky.el/commit/7cb000b91ba3dd63194ad61f16d4652f58ad8644))

## [1.3.3](https://github.com/eki3z/binky.el/compare/v1.3.2..v1.3.3) - 2023-10-14

### Bug Fixes

- don't recomputate project root for no file-visited buffer - ([bc89652](https://github.com/eki3z/binky.el/commit/bc89652905fe6aadddd69694c4d2e0ea616563b1))

### Documentation

- fix typos in version comparison - ([d64f4b7](https://github.com/eki3z/binky.el/commit/d64f4b7564a51d8d31002fa223fc386c75fe9c8a))

### Miscellaneous Chores

- **(changelog)** update docs link for tera - ([19fd177](https://github.com/eki3z/binky.el/commit/19fd177eebf62b8f58497d526dd3fb066ee1ca2e))
- **(ci)** update actions/chekcout - ([8ab7468](https://github.com/eki3z/binky.el/commit/8ab74683ce4bd8fdf58dd188ee035f0af0250095))

### Refactoring

- remove all obsolete alias - ([98e4922](https://github.com/eki3z/binky.el/commit/98e4922fe5038ac5fe61cdc624ec07c60680923a))

## [1.3.2](https://github.com/eki3z/binky.el/compare/v1.3.1..v1.3.2) - 2023-09-04

### Bug Fixes

- **(highlight)** only highlight record in selected window - ([268988d](https://github.com/eki3z/binky.el/commit/268988d0f96c27e52c056d0e043a23d35c584445))
- **(margin)** margin indicator face covered by flymake-note face - ([9dcd48a](https://github.com/eki3z/binky.el/commit/9dcd48aa14b4989ab57c53849aa6cb27a792a89c))
- **(margin)** wrong argument in function binky-margin--spec - ([dffc8fa](https://github.com/eki3z/binky.el/commit/dffc8fad43fd215d1366458719ba4140e33bbcd5))

### Documentation

- fix wrong screenshot link - ([bf5b16c](https://github.com/eki3z/binky.el/commit/bf5b16c86fabf3b7c70e97775d0f8ad00386f65b))

### Features

- **(highlight)** support pulse-style highlight - ([a9133b6](https://github.com/eki3z/binky.el/commit/a9133b6b681fb57c597aa68e364944ae0fc28daa))
- add new command binky-jump-other-window - ([6900672](https://github.com/eki3z/binky.el/commit/690067264b7f5c942db05f0381f75b2d2b971f56))

### Refactoring

- **(faces)** set new default values to binky-faces - ([2dd25e0](https://github.com/eki3z/binky.el/commit/2dd25e019485d4c297166b43bd37761042fc0a1b))
- **(highlight)** [**breaking**] rename vars, faces and functions related to highlight - ([cb74f22](https://github.com/eki3z/binky.el/commit/cb74f22faefc60ec2bf741fce7e9655bcc8090f1))
- rename internal var binky--project-root - ([c6dcaf3](https://github.com/eki3z/binky.el/commit/c6dcaf3caec6056ce4bb17d75e267015a1d81f90))

## [1.3.1](https://github.com/eki3z/binky.el/compare/v1.3.0..v1.3.1) - 2023-09-04

### Bug Fixes

- **(defcustom)** wrong version numbers - ([b010d1c](https://github.com/eki3z/binky.el/commit/b010d1c2264b8db09f7bfaeaab3e0c780d8ac9a2))

### Documentation

- update CHANGELOG - ([61ba795](https://github.com/eki3z/binky.el/commit/61ba795ee06658ebfcf2adc1c081b0dd30313559))
- update screenshot image - ([0da519c](https://github.com/eki3z/binky.el/commit/0da519cea1590f74ef18cc429a71dc576d82fd8d))

### Miscellaneous Chores

- **(LICENSE)** change LICENSE to GPL3 - ([57ea59f](https://github.com/eki3z/binky.el/commit/57ea59f346469d5315795816cb90f8f11d6fab2f))
- **(changelog)** add config cliff.toml - ([20b9b86](https://github.com/eki3z/binky.el/commit/20b9b867da82bd582d6b9c85a11f76785501d57c))

### Refactoring

- simplify internal function binky--parse - ([3ee61df](https://github.com/eki3z/binky.el/commit/3ee61dfbd57a83faf845a66423c0f48205154b90))

## [1.3.0](https://github.com/eki3z/binky.el/compare/v1.2.2..v1.3.0) - 2023-08-29

### Bug Fixes

- error when scroll mouse in binky-mark-read - ([28468bd](https://github.com/eki3z/binky.el/commit/28468bde909f8d9a9f7b26fb5e065a9c5d83fb14))
- don not run binky-recent-alist-update-hook if no changes - ([1f2ce82](https://github.com/eki3z/binky.el/commit/1f2ce82bd7dd8f412074b391b38592c49135d67d))
- wrong function name - ([2948f53](https://github.com/eki3z/binky.el/commit/2948f5319209c5ce898d5cf3ea94d24ef64e584c))

### Features

- add project information for records - ([b6838b6](https://github.com/eki3z/binky.el/commit/b6838b65321b270d5177d1af32ec4131c19e4dec))

### Performance

- only update margins on recorded buffers - ([7b22515](https://github.com/eki3z/binky.el/commit/7b2251558f9eede39f328e51d914907c2bc59f5c))

### Refactoring

- adjust some funcitons behavior - ([83ad537](https://github.com/eki3z/binky.el/commit/83ad537a185dacff6e1aacc8ccb3ca519bb71668))
- simplify internal functions - ([7f35d46](https://github.com/eki3z/binky.el/commit/7f35d460f0028a6737a41df2522616b97b91dbd0))
- rename binky-log-buffer - ([3ce323c](https://github.com/eki3z/binky.el/commit/3ce323c000ba509b8dd99b23b44a0464ffd4dd7f))
- internal functions use cl-loop - ([6305079](https://github.com/eki3z/binky.el/commit/630507927b4ddf255ee62ec05df406a06125649f))
- internal functions - ([a7850d1](https://github.com/eki3z/binky.el/commit/a7850d15a8c516f62e58d5e54c339a8c5e8cd0d4))

## [1.2.2](https://github.com/eki3z/binky.el/compare/v1.2.1..v1.2.2) - 2023-08-11

### Bug Fixes

- key space is not available anymore - ([26ce33d](https://github.com/eki3z/binky.el/commit/26ce33d81ab5a305b4db5565ec4e128235d3c22d))
- ci error on missing file - ([5915e42](https://github.com/eki3z/binky.el/commit/5915e42b7379c4b7d5242d09ca824dc1e9ca04a6))

### Documentation

- update readme - ([9ac28df](https://github.com/eki3z/binky.el/commit/9ac28df77e224ed87d267c3901fec731a1b56237))
- update README - ([c83f576](https://github.com/eki3z/binky.el/commit/c83f57698fff6e4815ffe39bc1bf427e52e6a4a9))
- fix typos in README - ([724eedc](https://github.com/eki3z/binky.el/commit/724eedc00783c50a60f55a350ac1b4e611d3f781))
- remove builtin dependencies description - ([6496ce9](https://github.com/eki3z/binky.el/commit/6496ce970a6cdb7536232720ea02b094642697c3))
- update README - ([3b58dc4](https://github.com/eki3z/binky.el/commit/3b58dc40b4583b7d6b4891b3f366099977c9e4b9))

### Features

- add commands jumping to next/previous record in current buffer - ([3fe9656](https://github.com/eki3z/binky.el/commit/3fe965685d00da7d87c748e9098a9bbaa8a0fb58))

### Refactoring

- print message when toggle group view - ([19bab6e](https://github.com/eki3z/binky.el/commit/19bab6e9f2073ae6ccb917e64df339ee80cd8da3))
- rename var binky-mark-overwrite to binky-overwrite - ([b6008b0](https://github.com/eki3z/binky.el/commit/b6008b084828eced72a48cc1c88da83a18a95779))
- rename internal var and functions - ([150f65c](https://github.com/eki3z/binky.el/commit/150f65c408f791f8a8526f6c4666dcbbbea3e219))
- use seq-* functions as much as possible - ([f8d21ca](https://github.com/eki3z/binky.el/commit/f8d21ca0804a8dc733bafdd1608ca3c05860ce22))
- remove duplicated code - ([a1bb3e4](https://github.com/eki3z/binky.el/commit/a1bb3e4197ffeb4f534ee23b860b577a156eb81a))
- split binky-margin-mode into separate file - ([8311721](https://github.com/eki3z/binky.el/commit/8311721ead515711379cd0e81f8f5cd9dabc4f4f))
- rename binky-mode.el to binky.el - ([779bcc8](https://github.com/eki3z/binky.el/commit/779bcc8216eb3f8c41ef9ce949a79f00e616001f))

## [1.2.1](https://github.com/eki3z/binky.el/compare/v1.2.0..v1.2.1) - 2023-07-22

### Bug Fixes

- recent records error in preview - ([6a8bca5](https://github.com/eki3z/binky.el/commit/6a8bca5fbb7e7250728376aba00fc6ac641ba66e))
- add recent record unexpectedly into manual alist - ([80c4ee4](https://github.com/eki3z/binky.el/commit/80c4ee4accc1c814a65381da13de5e62cbeba22e))
- using unique buffer names in preview - ([2a375d6](https://github.com/eki3z/binky.el/commit/2a375d6c71426a8bc749d90f35b55336b638cd27))
- put killed buffer last in preview - ([58fd3db](https://github.com/eki3z/binky.el/commit/58fd3db021d5a85e28cd8a16f5fa2ddf5e2101dc))
- sorting records in groups according to position - ([7e26345](https://github.com/eki3z/binky.el/commit/7e2634509bc5167fdb17bc6329ee3677c49afa22))

### Documentation

- update usage - ([dc6f5fc](https://github.com/eki3z/binky.el/commit/dc6f5fc18e9c84e81eec3b84ba3927e56e632045))
- fix typos in README - ([56748a8](https://github.com/eki3z/binky.el/commit/56748a89f68a83583c469b510bda292bab1048e7))
- no more recent sorting strategy - ([708bf85](https://github.com/eki3z/binky.el/commit/708bf851de24f5d914ec36a2e806260f3a19e184))
- update readme - ([09d8fa2](https://github.com/eki3z/binky.el/commit/09d8fa212d645518a1b49ea9c1abc7e24084bed8))

### Features

- add option binky-preview-in-groups - ([8893242](https://github.com/eki3z/binky.el/commit/889324260f0a0c5696819ac16d67598300491eab))

### Refactoring

- simplify codes - ([cba1175](https://github.com/eki3z/binky.el/commit/cba11756bd2a6695c9c226d3e0eb5e095f6ecd0d))
- command binky-recent-toggle - ([5cbd21a](https://github.com/eki3z/binky.el/commit/5cbd21ac74527744f24b8dece3db2b6819cb0959))

## [1.2.0](https://github.com/eki3z/binky.el/compare/v1.1.0..v1.2.0) - 2023-07-12

### Bug Fixes

- **(binky-margin-mode)** make margin indicator no italic style - ([61b2833](https://github.com/eki3z/binky.el/commit/61b2833d62c67aadb60d7eaeffc92291ab5ba3d3))
- **(binky-mark-back)** don't record position on the same line - ([d054c4c](https://github.com/eki3z/binky.el/commit/d054c4ca27de70988836c6816d4788894a890210))
- **(preview)** close preview by force when quit the command - ([1e0f9ab](https://github.com/eki3z/binky.el/commit/1e0f9abae41fa1773ee2b1f1275ea687e4f0a045))
- typos in docstring - ([b430ad8](https://github.com/eki3z/binky.el/commit/b430ad8b6bcc03830cd910d0540e149f68780cf8))
- don't auto mark last buffer if current-buffer is minibuffer - ([6aea48d](https://github.com/eki3z/binky.el/commit/6aea48d587b2c378c8ba3f0483b9b93120816c82))
- echo warning if mark is illegal - ([ec94dae](https://github.com/eki3z/binky.el/commit/ec94dae9779825487c3bb2c145dc43a2369b01d2))
- adjust face color for preview - ([df54d32](https://github.com/eki3z/binky.el/commit/df54d3231c950cc074fb7dab54b129d03434d7e7))
- set window-min-height to 1 in preview - ([b30a05f](https://github.com/eki3z/binky.el/commit/b30a05f67a3c725f4257378de081b5d6fafde999))
- error on couldn't truncate some langauga character like chinese - ([3ac9925](https://github.com/eki3z/binky.el/commit/3ac99256cfaa8fb335ea86d1615eb21a9d09473a))

### Documentation

- add FAQ section - ([ae96fdf](https://github.com/eki3z/binky.el/commit/ae96fdf0b4c8a19ab0a31d165a611a7ec634679b))
- update FAQ - ([e3c29d3](https://github.com/eki3z/binky.el/commit/e3c29d3767ea2f56c74855c58f515ff04b92feec))
- fix typos - ([1579f79](https://github.com/eki3z/binky.el/commit/1579f7900a689c0edc00add5179243d9ededd394))
- update todo list - ([2a0e114](https://github.com/eki3z/binky.el/commit/2a0e1147ebcf7d8b82b5a6a9a06848d10b8a7d19))
- fix typos - ([4d95add](https://github.com/eki3z/binky.el/commit/4d95addda3eaa7e32030ed7b9077378e3b917dea))
- update todo list - ([920b3d1](https://github.com/eki3z/binky.el/commit/920b3d17a838959bb62a92904a80d7ed2bd471ec))

### Features

- add support for relative width of preview column - ([5a7eac5](https://github.com/eki3z/binky.el/commit/5a7eac5e7dbfe003217e563be11eb62d5c7a354a))

### Miscellaneous Chores

- update copyright year - ([b1f12ea](https://github.com/eki3z/binky.el/commit/b1f12ead26ec4886354c5ee498e598305901dce8))

### Refactoring

- simplify display buffer alist - ([a4f01e1](https://github.com/eki3z/binky.el/commit/a4f01e1203b73ad2b9192736ea3138cd2a4dc1f6))
- binky-preview - ([a289a58](https://github.com/eki3z/binky.el/commit/a289a5894484b14247cfea3bc3d16cc2380cccd7))
- remove cl-extra dep - ([04f1132](https://github.com/eki3z/binky.el/commit/04f1132ea1945861da0081cb2ad08076d20cea57))
- customization options - ([04db9d7](https://github.com/eki3z/binky.el/commit/04db9d714cad05a013ab681572bbaab2a25c5a2a))

## [1.1.0](https://github.com/eki3z/binky.el/compare/v1.0.0..v1.1.0) - 2022-12-22

### Bug Fixes

- highlight existing position line when add duplicated record - ([7efd1d0](https://github.com/eki3z/binky.el/commit/7efd1d0b74fbe3bd8e2158e8a317f7684a273af4))
- propertize mark in binky--message - ([d1c4824](https://github.com/eki3z/binky.el/commit/d1c4824bee793cabe1515e66187cc08463813b26))
- update dependency to emacs v26.3 - ([4a4a99d](https://github.com/eki3z/binky.el/commit/4a4a99dbc2ae6b37e88dcafa6b4a06ead7b47ab4))

### Documentation

- update readme - ([9b1b4d4](https://github.com/eki3z/binky.el/commit/9b1b4d4b80c9824db4ec63c3998d410cf78ce5fc))

### Features

- support margin indicator for back, auto marks - ([d355f2a](https://github.com/eki3z/binky.el/commit/d355f2ad289ff1ca5b0d5cb0a52da4a036045f47))
- adjust prompt color with binky-* commands - ([ee6d482](https://github.com/eki3z/binky.el/commit/ee6d482e9a27ce1721ef3b716aa76de714b7c665))
- add command binky-view - ([16b1532](https://github.com/eki3z/binky.el/commit/16b1532d025666d863322b22cdabf76530bc8b13))

### Miscellaneous Chores

- update dependency to emacs v27.1 - ([62b9a26](https://github.com/eki3z/binky.el/commit/62b9a26b40c4857700697a2182455b7311b936e1))

### Refactoring

- rename to binky-highlight - ([d55b1ba](https://github.com/eki3z/binky.el/commit/d55b1ba98f70249775da69854b18ed5c53b2a20e))
- remove useless code - ([49dbfad](https://github.com/eki3z/binky.el/commit/49dbfada522216faa4182f3e4232b97c00430346))
- use binky-margin-local-mode instead of binky--margin-setup - ([cdb044b](https://github.com/eki3z/binky.el/commit/cdb044b2c07fbc8769eb95c6fcf8fca6a9144674))
- prefer dolist rather than mapc - ([851ac4e](https://github.com/eki3z/binky.el/commit/851ac4ea6f96be8ea316eaacb2339b98621c025c))

## [1.0.0] - 2022-12-16

### Bug Fixes

- **(doc)** typos - ([2e4ad97](https://github.com/eki3z/binky.el/commit/2e4ad970d91c80bdefcfd977e2e33857ddb874c3))
- wrong position info when swap-in - ([3976b3d](https://github.com/eki3z/binky.el/commit/3976b3daf716611e39afde2ad2d8bf9b3d91f7d0))
- wrong line number in preview - ([fe07943](https://github.com/eki3z/binky.el/commit/fe079431e2ea8faa98b4d1389077192a5f5dc261))
- adjust face binky-highlight-warn - ([3e09212](https://github.com/eki3z/binky.el/commit/3e0921216ed36b3e27b005f3e85b64bd893f3952))
- binky-highlight-jump extend to t - ([95a1527](https://github.com/eki3z/binky.el/commit/95a15274deff19ddbca59fe661c74e34973f07a9))
- set binky-frequency-timer only when sort by frequency - ([ad65400](https://github.com/eki3z/binky.el/commit/ad65400f8bb2c62dbb4ab15c2a685490b9efb226))
- binky-highlight-warn :extend to t - ([82134b8](https://github.com/eki3z/binky.el/commit/82134b8916c9744ddc108812aafe30d3ae9364dd))
- some warnings - ([50cc3f9](https://github.com/eki3z/binky.el/commit/50cc3f9bd16d4b32d71ba37f1f9e97eae83db781))
- compatiability of function pos-eol - ([f10040e](https://github.com/eki3z/binky.el/commit/f10040ef3fb7b67f49f287b4d7401a6caa79e7be))
- typos - ([5bf7121](https://github.com/eki3z/binky.el/commit/5bf7121973db5a27136e59ab30155ecb07036a22))
- defcustom type error - ([dff6000](https://github.com/eki3z/binky.el/commit/dff6000e61c52291a2205c7acee65fe504d4ec1f))
- adjust face style - ([83132f3](https://github.com/eki3z/binky.el/commit/83132f34eeebd8f54d620684b6b4da2a73a6e2cf))

### Documentation

- provide more commands info - ([0328bd0](https://github.com/eki3z/binky.el/commit/0328bd0724da8713694311bec318265724ce9ecb))
- update todo - ([adab57d](https://github.com/eki3z/binky.el/commit/adab57d11440ce66461c4672d56bdb6df00a31f2))
- update preview image - ([9628fef](https://github.com/eki3z/binky.el/commit/9628fef58688e68c4a73963ac34054584e89d55c))
- add comparison with dogears - ([510ac74](https://github.com/eki3z/binky.el/commit/510ac7408a93dbe6cf1f4abe93b49c3cef1821b2))
- fix typos - ([eab34a1](https://github.com/eki3z/binky.el/commit/eab34a1b5a050c1bf94c3992ba8bf57950c7313e))
- update informations - ([0de7dbb](https://github.com/eki3z/binky.el/commit/0de7dbbbdfe3bfae51c14be017c386eddd58c005))
- update command introduction - ([4c85878](https://github.com/eki3z/binky.el/commit/4c8587809f24e9f24ab32778b74239a8513a7a6a))
- add images for margin indicator - ([27cda46](https://github.com/eki3z/binky.el/commit/27cda46b3b130ad891b07aec1f1087f350784fa3))
- fix typos - ([91b4781](https://github.com/eki3z/binky.el/commit/91b4781e73aa10fbb2cc055b00f84e24d0ab25b7))

### Features

- add option binky-preview-side - ([d111298](https://github.com/eki3z/binky.el/commit/d111298291ff3a7d3ea291d65fab49f7f50f8d35))
- implement command binky-binky - ([2d8b654](https://github.com/eki3z/binky.el/commit/2d8b6546fd4cd17d0271d46c6a35c59c3b02339b))
- add feature highlight for binky-add,jump,delete - ([8c17632](https://github.com/eki3z/binky.el/commit/8c176327ba39e2f1723a34285bbc94a31e914f62))
- add option binky-mark-quit - ([53dfa77](https://github.com/eki3z/binky.el/commit/53dfa77655bbd4c6f5764e25ac25c5d861dd5311))
- add option binky-mark-distance - ([c473057](https://github.com/eki3z/binky.el/commit/c473057e00db9d16d285ddbfd53c0bae20d5d8f3))
- add option binky-record-prune and refactor - ([a6def39](https://github.com/eki3z/binky.el/commit/a6def392a71d2b56d117a3c6ef6511a65c0a538a))
- add command binky-auto-toggle - ([d0b5c2f](https://github.com/eki3z/binky.el/commit/d0b5c2f3b33482621ccc2aab712192678e7f3c34))
- support buffer margin indicator - ([dfc69ac](https://github.com/eki3z/binky.el/commit/dfc69ac6a5d451b6990b600e32ffd259f5873a51))
- add face binky-preview-clolumn-name-same - ([9be6064](https://github.com/eki3z/binky.el/commit/9be606483454bf80b80f086afaa55a170461f0d1))

### Refactoring

- **(preview)** use column line rather than position - ([5492d29](https://github.com/eki3z/binky.el/commit/5492d2922363e0bf4016649e2b127af66d91b85c))
- replace binky-binky-recall with C-u prefix arguments - ([998f049](https://github.com/eki3z/binky.el/commit/998f049a2ade08d50d1888f187f73ee02a6ec231))
- remove useless code - ([8ad8f83](https://github.com/eki3z/binky.el/commit/8ad8f839340c2f7c0cb42815b40bdb92e2c72ebd))
- add binky--message - ([adf904a](https://github.com/eki3z/binky.el/commit/adf904aae9a336385d55fe1076b15212819b1e3e))
- binky--mark-read - ([1ae1092](https://github.com/eki3z/binky.el/commit/1ae109228d6907ae675096fab019d81f85403d47))

<!-- generated by git-cliff -->
