;;; auto-complete-etags-mercury.el --- Auto-completion source for etags
;; Modified from auto-complete-etags.el
;; Copyright 2013 Xiaofeng Yang
;; Copyright 2009 Yen-Chin,Lee
;;
;; Author: Yen-Chin,Lee, Xiaofeng Yang
;; Version: $Id: auto-complete-etags.el,v 0.2 2009/04/23 00:38:01 coldnew Exp $
;; Keywords:
;; X-URL: not distributed yet

;; This program is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation; either version 2, or (at your option)
;; any later version.
;;
;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.
;;
;; You should have received a copy of the GNU General Public License
;; along with this program; if not, write to the Free Software
;; Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.

;;; Commentary:

;; Put this file into your load-path and the following into your ~/.emacs:
;;   (require 'auto-complete-etags-mercury)

;;; Code:

(provide 'auto-complete-etags-mercury)
(require 'auto-complete)
(require 'auto-complete-etags-docs)
(eval-when-compile
  (require 'cl))


;;;;##########################################################################
;;;;  User Options, Variables
;;;;##########################################################################

(defface ac-etags-mercury-candidate-face
  '((t (:background "gainsboro" :foreground "deep sky blue")))
  "Face for ac-etags-mercury candidate")

(defface ac-etags-mercury-selection-face
  '((t (:background "deep sky blue" :foreground "white")))
  "Face for the ac-etags-mercury selected candidate.")

;; (defvar ac-source-slime-simple
;;   '((init . ac-slime-init)
;;     (candidates . ac-source-slime-simple-candidates)
;;     (candidate-face . ac-slime-menu-face)
;;     (selection-face . ac-slime-selection-face)
;;     (prefix . slime-symbol-start-pos)
;;     (symbol . "l")
;;     (document . ac-slime-documentation)
;;     (match . ac-source-slime-case-correcting-completions))
;;   "Source for slime completion")

;; (defun ac-etags-mercury-beginning-of-symbol ()
;;   ;; Copied from slime
;;   "Move to the beginning of the CL-style symbol at point."
;;   (while (re-search-backward "\\(\\sw\\|\\s_\\|\\s\\|\\s\\\\|[#@|]\\)\\="
;;                              (when (> (point) 2000) (- (point) 2000))
;;                              t))
;;   (re-search-forward "\\=#[-+<|]" nil t)
;;   (when (and (looking-at "@") (eq (char-before) ?\,))
;;     (forward-char)))


;; (defun ac-etags-mercury-symbol-start-pos ()
;;   ;; Copied from slime
;;   "Return the starting position of the symbol under point.
;; The result is unspecified if there isn't a symbol under the point."
;;   (save-excursion (ac-etags-mercury-beginning-of-symbol) (point)))

;; symbols:
;; aaa.bbb
;; aaa
;;
;; to skip:
;; "" not \"
;; ''
;; spcae
;; ()
;; [|]
;; ,
;; !                               fx                40
;; $
;; !.                              fx                40
;; !:                              fx                40
;; @                               xfx               90
;; ^                               xfy               99
;; ^                               fx                100
;; :                               yfx               120
;; `op`                      yfx               120       (1)
;; **                              xfy               200
;; -                               fx                200
;; *                               yfx               400
;; /                               yfx               400
;; //                              yfx               400
;; <<                              yfx               400
;; >>                              yfx               400
;; +                               fx                500
;; +                               yfx               500
;; ++                              xfy               500
;; -                               yfx               500
;; --                              yfx               500
;; /\\                             yfx               500
;; \\/                             yfx               500
;; ..                              xfx               550
;; :=                              xfx               650
;; =^                              xfx               650
;; <                               xfx               700
;; =                               xfx               700
;; =..                             xfx               700
;; =:=                             xfx               700
;; =<                              xfx               700
;; ==                              xfx               700
;; =\\=                            xfx               700
;; >                               xfx               700
;; >=                              xfx               700
;; @<                              xfx               700
;; @=<                             xfx               700
;; @>                              xfx               700
;; @>=                             xfx               700
;; \\=                             xfx               700
;; \\==                            xfx               700
;; ~=                              xfx               700
;; \\+                             fy                900
;; ~                               fy                900
;; <=                              xfy               920
;; <=>                             xfy               920
;; =>                              xfy               920
;; &                               xfy               1025
;; ->                              xfy               1050
;; ;                               xfy               1100
;; ::                              xfx               1175
;; ==>                             xfx               1175
;; --->                            xfy               1179
;; -->                             xfx               1200
;; :-                              fx                1200
;; :-                              xfx               1200
;; ?-                              fx                1200

(setq mercury-seperators
  (regexp-opt '(
                "!." "!:"                
                "**"              
                "//" "<<" ">>"                
                "++" 
                "--" 
                "/\\" "\\/" ".." ":=" "=^"
                 "=.." "=:=" "=<" "==" "=\\="  ">="
                "@<" "@=<" "@>" "@>=" "\\=" "\\==" "~=" "\\+"  "<=" "<=>" "=>" 
                "->"  "::" "==>" "--->" "-->" ":-" "?-"

                "\"" "'" " " "(" ")" "[" "]" "|" "," "!" "$" "@" "^" ":" "`" "-" "*" "/" "+" "-" "\\" "<" "=" ">" "~" "&" ";")))

(defun ac-prefix-etags-mercury ()
  (if (re-search-backward mercury-seperators (line-beginning-position) t)
      (progn
        (forward-char)
        (point))
    (line-beginning-position)))



(defvar ac-source-etags-mercury
  '((candidates . (lambda ()
                    (all-completions ac-target (tags-completion-table))))
    (candidate-face . ac-etags-mercury-candidate-face)
    (selection-face . ac-etags-mercury-selection-face)
    (prefix . ac-prefix-etags-mercury)
    (document . aced-etags-complete-doc)
    (requires . 2))
  "Source for ac-etags-mercury.")


;;; auto-complete-etags.el ends here




