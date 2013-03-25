This package provides Slime's convenient "M-." and "M-," navigation
in `emacs-lisp-mode', together with an elisp equivalent of
`slime-describe-symbol', bound by default to `C-c C-d d`.

When the main functions are given a prefix argument, they will
prompt for the symbol upon which to operate.

Usage:

Enable the package in elisp and ielm modes by simply loading it:

  (require 'elisp-slime-nav)

When installing from an ELPA package, this is not necessary.

Known issues:

  When navigating into Emacs' C source, "M-," will not be bound to
  the same command, but "M-*" will typically do the trick.
