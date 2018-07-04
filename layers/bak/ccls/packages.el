(defconst ccls-packages '((ccls)))

;; https://github.com/MaskRay/ccls/wiki/Emacs
(defun ccls//init-ccls ()
  (use-package ccls
    :defer t
    :init
    :commands lsp-ccls-enable
    ;; Customize `lsp-project-whitelist' `lsp-project-blacklist' to disable auto initialization.
    (add-hook 'c-mode-common-hook #'ccls//enable)
    ))
