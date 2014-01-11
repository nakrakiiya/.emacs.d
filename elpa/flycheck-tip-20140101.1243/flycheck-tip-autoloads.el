;;; flycheck-tip-autoloads.el --- automatically extracted autoloads
;;
;;; Code:


;;;### (autoloads (flycheck-tip-cycle-reverse flycheck-tip-cycle)
;;;;;;  "flycheck-tip" "flycheck-tip.el" (21201 19158 875190 745000))
;;; Generated autoloads from flycheck-tip.el

(autoload 'flycheck-tip-cycle "flycheck-tip" "\
Move to next error if it's exists.
If it wasn't exists then move to previous error.
Move to previous error if REVERSE is non-nil.

\(fn &optional REVERSE)" t nil)

(autoload 'flycheck-tip-cycle-reverse "flycheck-tip" "\
Do `flycheck-tip-cycle by reverse order.

\(fn)" t nil)

;;;***

;;;### (autoloads nil nil ("flycheck-tip-pkg.el") (21201 19158 919615
;;;;;;  271000))

;;;***

(provide 'flycheck-tip-autoloads)
;; Local Variables:
;; version-control: never
;; no-byte-compile: t
;; no-update-autoloads: t
;; coding: utf-8
;; End:
;;; flycheck-tip-autoloads.el ends here
