;;; packages.el --- spacemacs-cmake-ide layer packages file for Spacemacs.
;;
;; Copyright (c) 2012-2017 Sylvain Benner & Contributors
;;
;; Author:  <chernikoff@chernikoff-hp>
;; URL: https://github.com/syl20bnr/spacemacs
;;
;; This file is not part of GNU Emacs.
;;
;;; License: GPLv3

;;; Commentary:

;; See the Spacemacs documentation and FAQs for instructions on how to implement
;; a new layer:
;;
;;   SPC h SPC layers RET
;;
;;
;; Briefly, each package to be installed or configured by this layer should be
;; added to `spacemacs-cmake-ide-packages'. Then, for each package PACKAGE:
;;
;; - If PACKAGE is not referenced by any other Spacemacs layer, define a
;;   function `spacemacs-cmake-ide/init-PACKAGE' to load and initialize the package.

;; - Otherwise, PACKAGE is already referenced by another Spacemacs layer, so
;;   define the functions `spacemacs-cmake-ide/pre-init-PACKAGE' and/or
;;   `spacemacs-cmake-ide/post-init-PACKAGE' to customize the package as it is loaded.

;;; Code:

(defconst spacemacs-cmake-ide-packages
  '(
    cmake-ide
    irony
    company-irony
    company-irony-c-headers
    rtags
    helm-rtags
    )
  "The list of Lisp packages required by the spacemacs-cmake-ide layer.

Each entry is either:

1. A symbol, which is interpreted as a package to be installed, or

2. A list of the form (PACKAGE KEYS...), where PACKAGE is the
    name of the package to be installed or loaded, and KEYS are
    any number of keyword-value-pairs.

    The following keys are accepted:

    - :excluded (t or nil): Prevent the package from being loaded
      if value is non-nil

    - :location: Specify a custom installation location.
      The following values are legal:

      - The symbol `elpa' (default) means PACKAGE will be
        installed using the Emacs package manager.

      - The symbol `local' directs Spacemacs to load the file at
        `./local/PACKAGE/PACKAGE.el'

      - A list beginning with the symbol `recipe' is a melpa
        recipe.  See: https://github.com/milkypostman/melpa#recipe-format")

(setq spacemacs-cmake-ide-excluded-packages
      '(auto-complete-clang))

(defun spacemacs-cmake-ide/init-cmake-ide()
  (use-package cmake-ide
    :config
    (cmake-ide-setup)
    )
  )

(defun spacemacs-cmake-ide/init-irony()
  (use-package irony
    :config
    (progn
      (add-hook 'c++-mode-hook 'irony-mode)
      (add-hook 'c-mode-hook 'irony-mode)
      (add-hook 'objc-mode-hook 'irony-mode)
      (add-hook 'irony-mode-hook
                (lambda()
                  (define-key irony-mode-map [remap completion-at-point]
                    'irony-completion-at-point-async)
                  (define-key irony-mode-map [remap complete-symbol]
                    'irony-completion-at-point-async)
                  )
                )
      (add-hook 'irony-mode-hook 'irony-cdb-autosetup-compile-options)
      )
    )
  )

(defun spacemacs-cmake-ide/init-company-irony()
  (use-package company-irony
    :config
    (progn
      (with-eval-after-load 'company
        '(add-to-list 'company-backends 'company-irony)
        )
      )
    )
  )

(defun spacemacs-cmake-ide/init-company-irony-c-headers()
  (use-package company-irony-c-headers
    :config
    (progn
      (with-eval-after-load 'company
        '(add-to-list 'company-backends 'company-irony-c-headers)
        )
      )
    )
  )

(defun spacemacs-cmake-ide/init-rtags()
  (use-package rtags
;    :config
;    (progn
;      ((rtags-enable-standard-keybindings)
;       )
;      )
    )
  )

(defun spacemacs-cmake-ide/init-helm-rtags()
  (use-package helm-rtags
    :config
    (progn
      (setq rtags-use-helm t)
      )
    )
  )

;;; packages.el ends here
