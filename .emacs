(add-to-list 'load-path "~/.emacs.d/site-lisp/")



;; Basic .emacs with a good set of defaults, to be used as template for usage
;; with OCaml and OPAM
;;
;; Author: Louis Gesbert <louis.gesbert@ocamlpro.com>
;; Released under CC0

;; Generic, recommended configuration options


;; Added by Package.el.  This must come before configurations of
;; installed packages.  Don't delete this line.  If you don't want it,
;; just comment it out by adding a semicolon to the start of the line.
;; You may delete these explanatory comments.
(require 'package)
;(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)
(package-initialize)



;; Load company-coq when opening Coq files
(add-hook 'coq-mode-hook #'company-coq-mode)

;; ANSI color in compilation buffer
(require 'ansi-color)
(defun colorize-compilation-buffer ()
  (toggle-read-only)
  (ansi-color-apply-on-region (point-min) (point-max))
  (toggle-read-only))
(add-hook 'compilation-filter-hook 'colorize-compilation-buffer)

;; Some key bindings

(global-set-key [f3] 'next-match)
(defun prev-match () (interactive nil) (next-match -1))
(global-set-key [(shift f3)] 'prev-match)
(global-set-key [backtab] 'auto-complete)
;; OCaml configuration
;;  - better error and backtrace matching

(defun set-ocaml-error-regexp ()
  (set
   'compilation-error-regexp-alist
   (list '("[Ff]ile \\(\"\\(.*?\\)\", line \\(-?[0-9]+\\)\\(, characters \\(-?[0-9]+\\)-\\([0-9]+\\)\\)?\\)\\(:\n\\(\\(Warning .*?\\)\\|\\(Error\\)\\):\\)?"
    2 3 (5 . 6) (9 . 11) 1 (8 compilation-message-face)))))

(add-hook 'tuareg-mode-hook 'set-ocaml-error-regexp)
(add-hook 'caml-mode-hook 'set-ocaml-error-regexp)
;; ## added by OPAM user-setup for emacs / base ## 56ab50dc8996d2bb95e7856a6eddb17b ## you can edit, but keep this line
(require 'opam-user-setup "~/.emacs.d/opam-user-setup.el")
;; ## end of OPAM user-setup addition for emacs / base ## keep this line


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; powerline
(powerline-default-theme)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; unicad -- guess file encoding
;;(require 'unicad)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; grep+
(require 'grep+)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; slime
;; (setq inferior-lisp-program "~/ccl/lx86cl64") 
;; (setq inferior-lisp-program "/usr/bin/ecl")
(setq inferior-lisp-program "~/sbcl/bin/sbcl")
;; (setq inferior-lisp-program "/usr/bin/clisp")
;; (setq inferior-lisp-program "~/acl82/alisp")
(setq common-lisp-hyperspec-root (expand-file-name "~/.emacs.d/clhs7/HyperSpec/"))
(slime-setup '(slime-fancy)) ; almost everything

;; do not use slime company
;(slime-setup '(slime-company))

;(define-key company-active-map (kbd "\C-n") 'company-select-next)
;(define-key company-active-map (kbd "\C-p") 'company-select-previous)
;(define-key company-active-map (kbd "\C-d") 'company-show-doc-buffer)
;(define-key company-active-map (kbd "M-.") 'company-show-location)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; auto-complete
(require 'auto-complete-config)
(ac-config-default)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; ac-slime
(add-hook 'slime-mode-hook 'set-up-slime-ac)
(add-hook 'slime-repl-mode-hook 'set-up-slime-ac)
(eval-after-load "auto-complete"
 '(add-to-list 'ac-modes 'slime-repl-mode 'slime-mode))









;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; prolog mode

(require 'prolog)
(autoload 'run-prolog "prolog" "Start a Prolog sub-process." t)
(autoload 'prolog-mode "prolog" "Major mode for editing Prolog programs." t)
(autoload 'mercury-mode "prolog" "Major mode for editing Mercury programs." t)
(setq prolog-system 'swi)  ; optional, the system you are using;
                           ; see `prolog-system' below for possible values
(setq prolog-program-name "/usr/bin/swipl")
(setq auto-mode-alist (append '(("\\.pl$" . prolog-mode) ; default to what ?
                                ("\\.m$" . mercury-mode)
                                ("\\.yap$" . prolog-mode)
                                ("\\.P$" . xsb-mode) ;; <-- for XSB only
                                ;; ("\\.ecl$" . prolog-mode) ;; <-- for ECLiPSe only
                                )
                               auto-mode-alist))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; eclipse mode
(autoload 'eclipse-mode "eclipse.el" "ECLiPSe editing mode" t)
(autoload 'eclipse-esp-mode "eclipse.el" "ECLiPSe-ESP editing mode" t)
(setq auto-mode-alist (cons '("\\.ecl" . eclipse-mode) auto-mode-alist))
(setq auto-mode-alist (cons '("\\.esp" . eclipse-esp-mode) auto-mode-alist))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; mercury debugger
(add-to-list 'load-path 
	"/usr/lib/mercury/elisp")
(autoload 'mdb "gud" "Invoke the Mercury debugger" t)




;; =================== Mercury setup ====================
(require 'flymake)
(require 'flycheck)
(require 'flymake-cursor)
(require 'flycheck-mercury)

(add-hook 'flycheck-mode-hook 'flycheck-color-mode-line-mode)

(defvar *flymake-mercury-checker* "~/.emacs.d/mercury-support/mercury-checker.sh")

(push '("\\([^:]*\\):\\([0-9]+\\):[0-9]+: \\(.*\\)" 1 2 nil 3) flymake-err-line-patterns)

(defun flymake-mercury-init ()
  (let* ((temp-file (flymake-init-create-temp-buffer-copy
                     'flymake-create-temp-inplace))
         (local-file (file-relative-name
                      temp-file
                      (file-name-directory buffer-file-name))))
    (list *flymake-mercury-checker* (list local-file))))

(add-to-list 'flymake-allowed-file-name-masks '("\\.m" flymake-mercury-init nil flymake-get-real-file-name))

;; (add-hook 'mercury-mode-hook
;;           '(lambda ()
;;              (if (not (null buffer-file-name)) (flymake-mode))))

(add-hook 'prolog-mode-hook
          '(lambda ()
             (if (eq 'mercury prolog-system)
                 (if (not (null buffer-file-name)) (flymake-mode)))))




;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; flycheck-ocaml
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(with-eval-after-load 'merlin
  ;; Disable Merlin's own error checking
  (setq merlin-error-after-save nil)
  
  ;; Enable Flycheck checker
  (flycheck-ocaml-setup))

(add-hook 'tuareg-mode-hook #'merlin-mode)





;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; highlight-parentheses
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(require 'highlight-parentheses)
(define-globalized-minor-mode global-highlight-parentheses-mode
  highlight-parentheses-mode
  (lambda ()
    (highlight-parentheses-mode t)))
(global-highlight-parentheses-mode t)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; autopair
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(require 'autopair)
(require 'auto-pair+)
(add-hook 'emacs-lisp-mode-hook
          #'(lambda ()
              (push '(?` . ?')
                    (getf autopair-extra-pairs :comment))
              (push '(?` . ?')
                    (getf autopair-extra-pairs :string))))
(add-hook 'lisp-mode-hook
          #'(lambda ()
              (push '(?` . ?')
                    (getf autopair-extra-pairs :comment))
              (push '(?` . ?')
                    (getf autopair-extra-pairs :string))))
(add-hook 'c-mode-common-hook #'(lambda () (autopair-mode)))
(add-hook 'lisp-mode-hook #'(lambda () (autopair-mode)))
;(add-hook 'slime-repl-mode-hook #'(lambda () (autopair-mode)))
(add-hook 'emacs-lisp-mode-hook #'(lambda () (autopair-mode)))

(autopair-global-mode) ;; to enable in all buffers


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; indent when ENTER pressed in lisp mode
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun my-newline-and-indent ()
  (interactive)
  (newline-and-indent)
  (slime-reindent-defun))
(define-key lisp-mode-shared-map (kbd "RET") 'my-newline-and-indent) 


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; highlight-indentation
(add-hook 'slime-mode-hook 'highlight-indentation-current-column-mode)
(add-hook 'slime-repl-mode-hook 'highlight-indentation-current-column-mode)
(add-hook 'emacs-lisp-mode-hook 'highlight-indentation-current-column-mode)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; etags-table
(require 'etags-select)
(require 'etags-table)
(setq etags-table-search-up-depth 10)
(setq etags-table-alist
      (list

       ;; TODO create the system-level tags

       ;; For jumping to Mercury standard headers:
       '(".*\\.m" "~/.emacs.d/tags/MERCURY-TAGS")
       ;; For jumping to XSB system's libraries:
       '(".*\\.P$" "~/.emacs.d/tags/XSB-TAGS")
       ;; For jumping to YAP's libraries:
       '(".*\\.pl$" "~/.emacs.d/tags/YAP-TAGS")
       ;; For jumping to yap's libraries:
       '(".*\\.yap$" "~/.emacs.d/tags/YAP-TAGS")
       ;; For jumping to ECLiPSe system's libraries
       '(".*\\.ecl$" "~/.emacs.d/tags/ECLIPSE-TAGS")
       ;; '(".*\\.pl$" "~/sys-tags/eclipse/TAGS")
       ;; For jumping to C system's libraries
       ;; '(".*\\.[ch]$" "~/sys-tags/c/TAGS")  <-- always crashes
       ;; For jumping across project:
       ;; '("/home/devel/proj1/" "/home/devel/proj2/TAGS" "/home/devel/proj3/TAGS")
       ;; '("/home/devel/proj2/" "/home/devel/proj1/TAGS" "/home/devel/proj3/TAGS")
       ;; '("/home/devel/proj3/" "/home/devel/proj1/TAGS" "/home/devel/proj2/TAGS")
       ))
(defun etags-select-get-tag-files ()
  "Get tag files."
  (if etags-select-use-xemacs-etags-p
      (buffer-tag-table-list)
    (mapcar 'tags-expand-table-name tags-table-list)
    (tags-table-check-computed-list)
    tags-table-computed-list))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; auto-complete-etags
(require 'auto-complete-etags)
(require 'auto-complete-etags-mercury)

(defun add-ac-source-etags ()
  (add-to-list 'ac-sources 'ac-source-etags))

(defun add-prolog-ac-source-etags ()
  (if (eq 'mercury prolog-system)
      (add-to-list 'ac-sources 'ac-source-etags-mercury)
    (add-to-list 'ac-sources 'ac-source-etags)))

(add-hook 'prolog-mode-hook 'add-prolog-ac-source-etags)
(add-hook 'eclipse-mode-hook 'add-prolog-ac-source-etags)

(require 'auto-complete-etags-docs)
(aced-update-ac-source-etags)


(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(ac-ignore-case t)
 '(ac-modes
   (quote
    (slime-repl-mode emacs-lisp-mode lisp-interaction-mode c-mode cc-mode c++-mode java-mode clojure-mode scala-mode scheme-mode ocaml-mode tuareg-mode perl-mode cperl-mode python-mode ruby-mode ecmascript-mode javascript-mode js-mode js2-mode php-mode css-mode makefile-mode sh-mode fortran-mode f90-mode ada-mode xml-mode sgml-mode slime-mode lisp-mode prolog-mode prolog-inferior-mode ciao-mode mercury-mode xsb-mode eclipse-mode)))
 '(ac-use-fuzzy nil)
 '(ac-use-menu-map t)
 '(ac-use-overriding-local-map t)
 '(ahs-modes
   (quote
    (actionscript-mode apache-mode bat-generic-mode c++-mode c-mode csharp-mode css-mode dos-mode emacs-lisp-mode html-mode ini-generic-mode java-mode javascript-mode js-mode lisp-interaction-mode lua-mode latex-mode makefile-mode makefile-gmake-mode markdown-mode moccur-edit-mode nxml-mode nxhtml-mode outline-mode perl-mode cperl-mode php-mode python-mode rc-generic-mode reg-generic-mode ruby-mode sgml-mode sh-mode squirrel-mode text-mode tcl-mode visual-basic-mode slime-mode slime-repl-mode lisp-mode mercury-mode)))
 '(ahs-suppress-log nil)
 '(ansi-color-faces-vector
   [default bold shadow italic underline bold bold-italic bold])
 '(backup-directory-alist (quote (("." . "~/.local/share/emacs/backups"))))
 '(beacon-color "#F8BBD0")
 '(company-quickhelp-color-background "#b0b0b0")
 '(company-quickhelp-color-foreground "#232333")
 '(compilation-context-lines 2)
 '(compilation-error-screen-columns nil)
 '(compilation-scroll-output t)
 '(compilation-search-path (quote (nil "src")))
 '(cua-mode t nil (cua-base))
 '(current-language-environment "UTF-8")
 '(custom-enabled-themes (quote (zerodark)))
 '(custom-safe-themes
   (quote
    ("de0b7245463d92cba3362ec9fe0142f54d2bf929f971a8cdf33c0bf995250bcf" "0cd56f8cd78d12fc6ead32915e1c4963ba2039890700458c13e12038ec40f6f5" "3e83abe75cebf5621e34ce1cbe6e12e4d80766bed0755033febed5794d0c69bf" "2642a1b7f53b9bb34c7f1e032d2098c852811ec2881eec2dc8cc07be004e45a0" "1e9001d2f6ffb095eafd9514b4d5974b720b275143fbc89ea046495a99c940b0" "24fc62afe2e5f0609e436aa2427b396adf9a958a8fa660edbaab5fb13c08aae6" "5d75f9080a171ccf5508ce033e31dbf5cc8aa19292a7e0ce8071f024c6bcad2a" "bd82c92996136fdacbb4ae672785506b8d1d1d511df90a502674a51808ecc89f" "e7b49145d311e86da34a32a7e1f73497fa365110a813d2ecd8105eaa551969da" "6a7513261a7d6dde1c604b0fc4ed81de8ae0b7b6c2ad038346d49fdd2643f1b8" "b3697d12fb7c087e1337432be92026b5fd218e7e43277918c0fce680d573a90c" "d5aec3a39364bc4c6c13f472b2d0cdaebd5cff7a6e4839749be2156fcc075006" "cdb4ffdecc682978da78700a461cdc77456c3a6df1c1803ae2dd55c59fa703e3" "1b47cb8ebf110c94419d755855a3848fc9b2453d0730d56ee5fd4950ba92fdbe" "0eccc893d77f889322d6299bec0f2263bffb6d3ecc79ccef76f1a2988859419e" "f633d825e380caaaefca46483f7243ae9a663f6df66c5fad66d4cab91f731c86" "7beac4a68f03662b083c9c2d4f1d7f8e4be2b3d4b0d904350a9edf3cf7ce3d7f" "19b9349a6b442a2b50e5b82be9de45034f9b08fa36909e0b1be09433234610bb" "6bc387a588201caf31151205e4e468f382ecc0b888bac98b2b525006f7cb3307" "c5ad91387427abc66af38b8d6ea74cade4e3734129cbcb0c34cc90985d06dcb3" "a85a62923d1ed60fb8f54a3f5d42646df79c5046ed1964e79c419e82428ea086" "332fcf3c7208aca9fab65d54203f78a242482e7fd65f5725a2482c20b1730732" "bffb799032a7404b33e431e6a1c46dc0ca62f54fdd20744a35a57c3f78586646" "0bff60fb779498e69ea705825a2ca1a5497a4fccef93bf3275705c2d27528f2f" "e11880d349e5b3f3d47e5bd6f7d9ff773ab6301e124ec7dbbbfbba5fb8482390" "33e37cd55e9ee63a8fafedb09007d2f36756abff8d551eed965a08d015f36005" "8b73cfb1b5e312c021de063ab4b194ed228b8f0414e996aa5256350cd78c3e1d" "73ccd3f2e411ebbb31dd9e4f023938ddc76ef7ff66abdb51d1587195152fb7d2" "9b35c097a5025d5da1c97dba45fed027e4fb92faecbd2f89c2a79d2d80975181" "4780d7ce6e5491e2c1190082f7fe0f812707fc77455616ab6f8b38e796cbffa9" "acfac6b14461a344f97fad30e2362c26a3fe56a9f095653832d8fc029cb9d05c" "e396098fd5bef4f0dd6cedd01ea48df1ecb0554d8be0d8a924fb1d926f02f90f" "73c69e346ec1cb3d1508c2447f6518a6e582851792a8c0e57a22d6b9948071b4" "70f5a47eb08fe7a4ccb88e2550d377ce085fedce81cf30c56e3077f95a2909f2" "c3e6b52caa77cb09c049d3c973798bc64b5c43cc437d449eacf35b3e776bf85c" "5a0eee1070a4fc64268f008a4c7abfda32d912118e080e18c3c865ef864d1bea" "36ca8f60565af20ef4f30783aa16a26d96c02df7b4e54e9900a5138fb33808da" "bf798e9e8ff00d4bf2512597f36e5a135ce48e477ce88a0764cfb5d8104e8163" "c9ddf33b383e74dac7690255dd2c3dfa1961a8e8a1d20e401c6572febef61045" "2a7beed4f24b15f77160118320123d699282cbf196e0089f113245d4b729ba5d" "cbd85ab34afb47003fa7f814a462c24affb1de81ebf172b78cb4e65186ba59d2" "8f5b54bf6a36fe1c138219960dd324aad8ab1f62f543bed73ef5ad60956e36ae" "04dd0236a367865e591927a3810f178e8d33c372ad5bfef48b5ce90d4b476481" "5e3fc08bcadce4c6785fc49be686a4a82a356db569f55d411258984e952f194a" "7153b82e50b6f7452b4519097f880d968a6eaf6f6ef38cc45a144958e553fbc6" "a0feb1322de9e26a4d209d1cfa236deaf64662bb604fa513cca6a057ddf0ef64" "20bf9f519f78b247da9ccf974c31d3537bee613ff11579f539b2781246dee73b" "1068ae7acf99967cc322831589497fee6fb430490147ca12ca7dd3e38d9b552a" "d8dc153c58354d612b2576fea87fe676a3a5d43bcc71170c62ddde4a1ad9e1fb" "2540689fd0bc5d74c4682764ff6c94057ba8061a98be5dd21116bf7bf301acfb" default)))
 '(diary-entry-marker (quote font-lock-variable-name-face))
 '(ecb-auto-activate t)
 '(ecb-clear-caches-before-activate nil)
 '(ecb-compilation-buffer-names
   (quote
    (("*Calculator*")
     ("*vc*")
     ("*vc-diff*")
     ("*Apropos*")
     ("*Occur*")
     ("*shell*")
     ("\\*[cC]ompilation.*\\*" . t)
     ("\\*i?grep.*\\*" . t)
     ("*JDEE Compile Server*")
     ("*Help*")
     ("*Completions*")
     ("*Backtrace*")
     ("*Compile-log*")
     ("*bsh*")
     ("*Messages*")
     ("*slime-events*")
     ("*inferior-lisp*")
     ("*prolog*")
     ("*response*"))))
 '(ecb-compilation-major-modes (quote (compilation-mode slime-repl-mode)))
 '(ecb-compile-window-height 0.3)
 '(ecb-compile-window-width (quote edit-window))
 '(ecb-display-default-dir-after-start t)
 '(ecb-enlarged-compilation-window-max-height 1.0)
 '(ecb-layout-always-operate-in-edit-window (quote (delete-other-windows switch-to-buffer)))
 '(ecb-options-version "2.50")
 '(ecb-other-window-behavior (quote edit-and-compile))
 '(ecb-select-edit-window-on-redraw t)
 '(ecb-source-path (quote ("~")))
 '(ecb-split-edit-window-after-start nil)
 '(ecb-tip-of-the-day nil)
 '(ecb-windows-width 0.2)
 '(ede-project-directories (quote nil))
 '(electric-indent-mode nil)
 '(emms-mode-line-icon-image-cache
   (quote
    (image :type xpm :ascent center :data "/* XPM */
static char *note[] = {
/* width height num_colors chars_per_pixel */
\"    10   11        2            1\",
/* colors */
\". c #1ba1a1\",
\"# c None s None\",
/* pixels */
\"###...####\",
\"###.#...##\",
\"###.###...\",
\"###.#####.\",
\"###.#####.\",
\"#...#####.\",
\"....#####.\",
\"#..######.\",
\"#######...\",
\"######....\",
\"#######..#\" };")))
 '(evil-emacs-state-cursor (quote ("#D50000" hbar)))
 '(evil-insert-state-cursor (quote ("#D50000" bar)))
 '(evil-normal-state-cursor (quote ("#F57F17" box)))
 '(evil-visual-state-cursor (quote ("#66BB6A" box)))
 '(fci-rule-color "#c7c7c7" t)
 '(font-use-system-font t)
 '(global-auto-highlight-symbol-mode t)
 '(global-linum-mode t)
 '(global-semantic-decoration-mode t)
 '(global-semantic-highlight-edits-mode t)
 '(global-semantic-highlight-func-mode t)
 '(global-semantic-idle-local-symbol-highlight-mode t nil (semantic/idle))
 '(global-semantic-idle-scheduler-mode t)
 '(global-semantic-idle-summary-mode t)
 '(global-semantic-mru-bookmark-mode t)
 '(global-semantic-show-parser-state-mode t)
 '(global-semantic-tag-folding-mode t)
 '(global-semanticdb-minor-mode t)
 '(gnus-logo-colors (quote ("#4c8383" "#bababa")))
 '(gnus-mode-line-image-cache
   (quote
    (image :type xpm :ascent center :data "/* XPM */
static char *gnus-pointer[] = {
/* width height num_colors chars_per_pixel */
\"    18    13        2            1\",
/* colors */
\". c #1ba1a1\",
\"# c None s None\",
/* pixels */
\"##################\",
\"######..##..######\",
\"#####........#####\",
\"#.##.##..##...####\",
\"#...####.###...##.\",
\"#..###.######.....\",
\"#####.########...#\",
\"###########.######\",
\"####.###.#..######\",
\"######..###.######\",
\"###....####.######\",
\"###..######.######\",
\"###########.######\" };")))
 '(grep-highlight-matches t)
 '(grep-scroll-output t)
 '(highlight-indent-guides-auto-enabled nil)
 '(highlight-symbol-colors
   (quote
    ("#F57F17" "#66BB6A" "#0097A7" "#42A5F5" "#7E57C2" "#D84315")))
 '(highlight-symbol-foreground-color "#546E7A")
 '(highlight-tail-colors (quote (("#F8BBD0" . 0) ("#FAFAFA" . 100))))
 '(hl-paren-colors
   (quote
    ("#B9F" "#B8D" "#B7B" "#B69" "#B57" "#B45" "#B33" "#B11")))
 '(home-end-enable t)
 '(indent-tabs-mode nil)
 '(indicate-empty-lines t)
 '(inhibit-startup-screen t)
 '(line-move-visual t)
 '(next-error-highlight t)
 '(next-error-highlight-no-select t)
 '(next-line-add-newlines nil)
 '(nrepl-message-colors
   (quote
    ("#336c6c" "#205070" "#0f2050" "#806080" "#401440" "#6c1f1c" "#6b400c" "#23733c")))
 '(org-fontify-whole-heading-line t)
 '(package-archives
   (quote
    (("marmalade" . "http://marmalade-repo.org/packages/")
     ("melpa" . "http://melpa.milkbox.net/packages/"))))
 '(package-selected-packages
   (quote
    (minimal-theme flucui-themes flatland-theme faff-theme eziam-theme exotica-theme eink-theme eclipse-theme dracula-theme doneburn-theme darcula-theme cyberpunk-2019-theme cyberpunk-theme madhat2r-theme punpun-theme rebecca-theme zeno-theme zenburn-theme yoshi-theme chyla-theme chocolate-theme challenger-deep-theme badger-theme avk-emacs-themes autumn-light-theme atom-dark-theme arjen-grey-theme arc-dark-theme apropospriate-theme anti-zenburn-theme ample-zen-theme ample-theme almost-mono-themes alect-themes airline-themes ahungry-theme zerodark-theme afternoon-theme abyss-theme tabbar tree-mode ecb etags-table etags-select highlight-indentation autopair highlight-parentheses auto-highlight-symbol flymake-cursor iedit flycheck-ocaml flycheck-mercury flycheck ac-slime ac-etags slime-company slime powerline company-coq proof-general)))
 '(pdf-view-midnight-colors (quote ("#232333" . "#c7c7c7")))
 '(pos-tip-background-color "#ffffff")
 '(pos-tip-foreground-color "#78909C")
 '(red "#ffffff")
 '(require-final-newline t)
 '(scroll-bar-mode (quote right))
 '(select-active-regions (quote only))
 '(semantic-edits-verbose-flag nil)
 '(semantic-idle-summary-function (quote semantic-format-tag-summarize-with-file))
 '(semantic-idle-work-parse-neighboring-files-flag t)
 '(semantic-idle-work-update-headers-flag t)
 '(semantic-tag-folding-show-tooltips t)
 '(sentence-end-double-space nil)
 '(show-paren-mode t)
 '(show-trailing-whitespace t)
 '(slime-auto-select-connection (quote always))
 '(slime-auto-start (quote always))
 '(slime-autodoc-use-multiline-p t)
 '(slime-complete-symbol*-fancy t)
 '(slime-kill-without-query-p t)
 '(slime-net-coding-system (quote utf-8-unix))
 '(slime-when-complete-filename-expand t)
 '(tabbar-background-color "#ffffff")
 '(vc-annotate-background "#d4d4d4")
 '(vc-annotate-color-map
   (quote
    ((20 . "#437c7c")
     (40 . "#336c6c")
     (60 . "#205070")
     (80 . "#2f4070")
     (100 . "#1f3060")
     (120 . "#0f2050")
     (140 . "#a080a0")
     (160 . "#806080")
     (180 . "#704d70")
     (200 . "#603a60")
     (220 . "#502750")
     (240 . "#401440")
     (260 . "#6c1f1c")
     (280 . "#935f5c")
     (300 . "#834744")
     (320 . "#732f2c")
     (340 . "#6b400c")
     (360 . "#23733c"))))
 '(vc-annotate-very-old-color "#23733c")
 '(visible-bell t)
 '(window-divider-default-right-width 1)
 '(window-divider-mode t))



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; no tabs by default. modes that really need tabs should enable
;; indent-tabs-mode explicitly. makefile-mode already does that, for
;; example.
(setq-default indent-tabs-mode nil)
;; if indent-tabs-mode is off, untabify before saving
;; (add-hook 'write-file-hooks
;;           (lambda () (if (not indent-tabs-mode)
;;                                          (untabify (point-min) (point-max)))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;; Some utilities for windows.
(recentf-mode)                      ;; Add menu-item "File--Open recent"
;; Define some additional "native-Windows" keystrokes (^tab, Alt/F4, ^A, ^F, ^O,
;; ^S, ^W) and redefine (some of) the overridden Emacs functions.
(global-set-key [C-tab] 'other-window)
(global-set-key [M-f4] 'save-buffers-kill-emacs)
(global-set-key "\C-a" 'mark-whole-buffer)
(global-set-key "\C-f" 'isearch-forward)
(global-set-key [f3] 'isearch-repeat-forward)
(global-set-key "\C-o" 'find-file)
(global-set-key "\C-s" 'save-buffer)
(global-set-key "\C-w" 'kill-this-buffer)
(global-set-key (kbd "C-S-o") 'open-line)
(global-set-key (kbd "C-S-w") 'kill-region)
(define-key isearch-mode-map "\C-f" 'isearch-repeat-forward)
;;;; End of utilities.


;;;; Some goodies
(global-set-key (kbd "C-x C-b") 'bs-show)         ; Using BufferSelection for switching between buffers.
;;;; End of goodies


;; tabbar again
(defun tabbar-buffer-groups ()
  "Return the list of group names the current buffer belongs to.
 This function is a custom function for tabbar-mode's tabbar-buffer-groups.
 This function group all buffers into 2 groups, depending to the result value of `ecb-compilation-buffer-p'.
This allows grouping in eclipse style."
  (cond
   ((ecb-compilation-buffer-p (buffer-name))
    '("Compilation Buffers")
    )
   (t
    '("Editing Buffers")
    )
   ))
(setq tabbar-buffer-groups-function 'tabbar-buffer-groups)  
(tabbar-mode)

(global-ede-mode)
(ecb-activate)
