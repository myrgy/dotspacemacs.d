;; cpp2

(setq cpp2-packages
      '(
        cc-mode
        ;; gdb-mi
        ;; modern-cpp-font-lock
        gdb-gud
        clang-format
        cquery
        company-lsp
        ))

(defun cpp2/init-cc-mode ()
  (use-package cc-mode
    :defer t
    :init
    (progn
      (add-to-list 'auto-mode-alist
                   `("\\.h\\'" . ,c-c++-default-mode-for-headers)))
    :config
    (progn
      (require 'compile)
      (c-toggle-auto-newline 1)
      (dolist (mode c-c++-modes)
        (spacemacs/declare-prefix-for-mode mode "mc" "compile")
        (spacemacs/declare-prefix-for-mode mode "mg" "goto")
        (spacemacs/declare-prefix-for-mode mode "mp" "project")
        (spacemacs/set-leader-keys-for-major-mode mode
          "ga" 'projectile-find-other-file
          "gA" 'projectile-find-other-file-other-window)))))

(defun cpp2/init-gdb-gud ()
  (progn
    (setq gdb-many-windows t)

    (defvar all-gud-modes
      '(gud-mode comint-mode gdb-locals-mode gdb-frames-mode  gdb-breakpoints-mode)
      "A list of modes when using gdb")
    (defun kill-all-gud-buffers ()
      "Kill all gud buffers including Debugger, Locals, Frames, Breakpoints.
Do this after `q` in Debugger buffer."
      (interactive)
      (save-excursion
        (let ((count 0))
          (dolist (buffer (buffer-list))
            (set-buffer buffer)
            (when (member major-mode all-gud-modes)
              (setq count (1+ count))
              (kill-buffer buffer)
              (delete-other-windows))) ;; fix the remaining two windows issue
          (message "Killed %i buffer(s)." count))))
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
    (dolist (mode c-c++-modes)
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

(defun cpp2/init-clang-format ()
  (use-package clang-format
    :init
    (progn
      (dolist (mode c-c++-modes)
        (spacemacs/declare-prefix-for-mode mode "m=" "format")
        (spacemacs/set-leader-keys-for-major-mode mode
          "==" 'spacemacs/clang-format-region-or-buffer
          "=f" 'spacemacs/clang-format-function)))))

(defun cpp2/init-modern-cpp-font-lock ()
  (use-package modern-cpp-font-lock
    :init
    (add-hook 'c++-mode-hook #'modern-c++-font-lock-mode)
    :config
    (spacemacs|diminish modern-c++-font-lock-mode)))

(defun cpp2/post-init-cquery ()
  (with-eval-after-load 'cquery
    (use-package helm-xref)
    ;; (setq cquery-sem-highlight-method 'font-lock)
    (setq cquery-sem-highlight-method 'overlay)
    (cquery-use-default-rainbow-sem-highlight)
    (setq cquery-extra-init-params
          '(:cacheFormat "msgpack" :completion (:detailedLabel t) :xref (:container t))))

  (with-eval-after-load 'projectile
  ;; (spacemacs|use-package-add-hook projectile
    ;; :post-config
    (add-to-list 'projectile-globally-ignored-directories ".cquery_cached_index")))

(defun cpp2/post-init-company-lsp ()
  (spacemacs|add-company-backends :backends company-lsp :modes c-mode-common))

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
