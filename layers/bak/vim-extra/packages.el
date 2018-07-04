(setq vim-extra-packages
      '(
        evil-vimish-fold
        evil-string-inflection
        ))

(setq vim-extra-excluded-packages '())

(defun vim-extra/init-evil-vimish-fold ()
  ;; (use-package vimish-fold :ensure t)
  (use-package evil-vimish-fold
    :ensure t
    :init
    (evil-vimish-fold-mode t)))

(defun vim-extra/evil-string-inflection ()
  (use-package evil-string-inflection))
