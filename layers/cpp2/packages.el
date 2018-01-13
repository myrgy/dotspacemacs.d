;; cpp2

(setq cpp2-packages
      '(
        gdb-mi
        modern-cpp-font-lock
        (helm-ctest :require helm)
        ))

(defun cpp2/init-gdb-mi ()
  (use-package gdb-mi
    :defer t
    :init
    (setq
     ;; use gdb-many-windows by default when `M-x gdb'
     gdb-many-windows t
     ;; Non-nil means display source file containing the main routine at startup
     gdb-show-main t))
  :config
  (progn
    (require 'compile)
    (dolist (mode '(c-mode c++-mode))
      (spacemacs/declare-prefix-for-mode mode "md" "debug")
      (spacemacs/set-leader-keys-for-major-mode mode
        "dd" 'gdb
        "dc" 'gud-cont
        "dn" 'gud-next
        "ds" 'gud-step
        "db" 'gud-break
        "dB" 'gud-remove
        "dr" 'gud-go
        "da" 'gdb-io-eof
        "dk" 'gud-up
        "dj" 'gud-down
        "du" 'gud-until
        ))))

(defun cpp2/init-modern-cpp-font-lock ()
  (use-package modern-cpp-font-lock
    :init
    (add-hook 'c++-mode-hook #'modern-c++-font-lock-mode)
    :config
    (spacemacs|diminish modern-c++-font-lock-mode)
    ))

(defun cpp2/init-helm-ctest()
  (use-package helm-ctest
    :config
    (progn
      (dolist (mode '(c-mode c++-mode))
        (spacemacs/set-leader-keys-for-major-mode mode
          "ct" 'helm-ctest)
        ))))

;; (defun cpp2/which-func ()
;;   (which-function-mode t)
;;   (setq mode-line-format (delete (assoc 'which-func-mode
;;                                         mode-line-format) mode-line-format)
;;         which-func-header-line-format '(which-func-mode ("" which-func-format)))
;;   (defadvice which-func-ff-hook (after header-line activate)
;;     (when which-func-mode
;;       (setq mode-line-format (delete (assoc 'which-func-mode
;;                                             mode-line-format) mode-line-format)
;;             header-line-format which-func-header-line-format)))
;;     )
