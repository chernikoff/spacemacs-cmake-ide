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
    (cmake-ide :requires rtags irony company company-irony company-irony-c-headers)
    irony
    company
    (company-irony :toggle (configuration-layer/package-usedp 'company))
    (company-irony-c-headers :requires company irony)
    irony-eldoc
    rtags
    (helm-rtags :requires rtags helm)
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

;(setq spacemacs-cmake-ide-excluded-packages
;      '(auto-complete-clang))

(defun spacemacs-cmake-ide/init-cmake-ide ()
  (use-package cmake-ide)
  :config
  (progn
    (dolist (mode c-c++-modes)
      (spacemacs/set-leader-keys-for-major-mode mode
        "cc" 'cmake-ide-compile
        "pc" 'cmake-ide-run-cmake
        "pC" 'cmake-ide-maybe-run-cmake
        "pd" 'cmake-ide-delete-file
        )
      )
    )
  )

(defun spacemacs-cmake-ide/post-init-cmake-ide()
  (cmake-ide-setup))

(defun spacemacs-cmake-ide/init-irony ()
  (use-package irony
    :init
    (defun my-irony-mode-hook ()
      (define-key irony-mode-map [remap completion-at-point] 'irony-completion-at-point-async)
      (define-key irony-mode-map [remap complete-symbol] 'irony-completion-at-point-async))

    (add-hook 'c++-mode-hook 'irony-mode)
    (add-hook 'c-mode-hook 'irony-mode)
    (add-hook 'irony-mode-hook 'my-irony-mode-hook)
    (add-hook 'irony-mode-hook 'irony-cdb-autosetup-compile-options)
    (spacemacs|diminish irony-mode "I" "I")))

(defun spacemacs-cmake-ide/init-irony-eldoc ()
  (use-package irony-eldoc
    :init
    (add-hook 'c-mode-hook 'eldoc-mode)
    (add-hook 'c++-mode-hook 'eldoc-mode)
    (add-hook 'irony-mode-hook 'irony-eldoc)))

(defun spacemacs-cmake-ide/post-init-company ()
  (with-eval-after-load 'company
    (add-hook 'c-mode-hook (lambda () (add-to-list 'company-backends '(company-irony-c-headers company-irony))))
    (add-hook 'c++-mode-hook (lambda () (add-to-list 'company-backends '(company-irony-c-headers company-irony))))))

(defun spacemacs-cmake-ide/init-company-irony ()
  (use-package company-irony
    :init
    (add-hook 'irony-mode-hook 'company-irony-setup-begin-commands)))

(defun spacemacs-cmake-ide/init-company-irony-c-headers ()
  (use-package company-irony-c-headers))

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
