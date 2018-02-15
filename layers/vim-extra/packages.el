(setq vim-extra-packages
      '(
        evil-vimish-fold
        evil-string-inflection
        ))

(setq vim-extra-excluded-packages '())

(defun vim-extra/init-evil-vimish-fold ()
  (use-package vimish-fold)
  (use-package evil-vimish-fold
    :init
    (evil-vimish-fold-mode 1)))

(defun vim-extra/evil-string-inflection ()
  (use-package evil-string-inflection))
