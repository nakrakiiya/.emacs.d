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
 '(backup-directory-alist (quote (("." . "~/.local/share/emacs/backups"))))
 '(compilation-context-lines 2)
 '(compilation-error-screen-columns nil)
 '(compilation-scroll-output t)
 '(compilation-search-path (quote (nil "src")))
 '(cua-mode t nil (cua-base))
 '(current-language-environment "UTF-8")
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
 '(grep-highlight-matches t)
 '(grep-scroll-output t)
 '(home-end-enable t)
 '(indent-tabs-mode nil)
 '(indicate-empty-lines t)
 '(inhibit-startup-screen t)
 '(line-move-visual t)
 '(next-error-highlight t)
 '(next-error-highlight-no-select t)
 '(next-line-add-newlines nil)
 '(package-archives
   (quote
    (("marmalade" . "http://marmalade-repo.org/packages/")
     ("melpa" . "http://melpa.milkbox.net/packages/"))))
 '(package-selected-packages
   (quote
    (tabbar tree-mode ecb etags-table etags-select highlight-indentation autopair highlight-parentheses auto-highlight-symbol flymake-cursor iedit flycheck-ocaml flycheck-mercury flycheck ac-slime ac-etags slime-company slime powerline company-coq proof-general)))
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
 '(visible-bell t))



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
