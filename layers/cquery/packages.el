(defconst cquery-packages
  '(
    ;; evil
    ;; lsp-ui
    cquery
    (company-lsp : requires cquery company)
    ))

(defun my-code/post-init-evil ()


  ;; (evil-define-key 'normal xref--xref-buffer-mode-map
  ;;   "q" 'quit-window
  ;;   "gj" 'xref-next-line
  ;;   "gk" 'xref-prev-line
  ;;   (kbd "C-j") 'xref-next-line
  ;;   (kbd "C-k") 'xref-prev-line
  ;;   "]" 'xref-next-line
  ;;   "[" 'xref-prev-line
  ;;   "r" 'xref-query-replace-in-results

  ;;   ;; open
  ;;   (kbd "<return>") 'xref-goto-xref
  ;;   (kbd "S-<return>") 'xref-show-location-at-point
  ;;   "o" 'xref-show-location-at-point ; TODO: Remove binding?
  ;;   "go" 'xref-show-location-at-point)
  )

(defun cquery/post-init-lsp-ui ()
  (require 'lsp-imenu)
  (require 'lsp-ui)
    ;; (add-hook 'lsp-after-open-hook #'lsp-enable-imenu)
    ;; (lsp-enable-imenu)
    ;; (when ( > = emacs-major-version 26 )
    ;;   (lsp-ui-doc-mode 1))

    ;;; Override
    (dolist (mode '("c" "c++" "go" "haskell" "javascript" "python" "rust"))
      (let ((handler (intern (format "spacemacs-jump-handlers-%s-mode" mode))))
        (add-to-list handler 'lsp-ui-peek-find-definitions))
      (let ((handler (intern (format "spacemacs-reference-handlers-%s-mode" mode))))
        (add-to-list handler 'lsp-ui-peek-find-references)))
    (define-key lsp-ui-peek-mode-map (kbd "h") 'lsp-ui-peek--select-prev-file)
    (define-key lsp-ui-peek-mode-map (kbd "l") 'lsp-ui-peek--select-next-file)
    (define-key lsp-ui-peek-mode-map (kbd "j") 'lsp-ui-peek--select-next)
    (define-key lsp-ui-peek-mode-map (kbd "k") 'lsp-ui-peek--select-prev)
    (define-key lsp-ui-peek-mode-map (kbd "q") 'lsp-ui-peek--abort)
    )

;; See also https://github.com/cquery-project/cquery/wiki/Emacs
(defun cquery/init-cquery ()
  (use-package cquery
    :defer t
    :init
    ;; (setq cquery-executable cquery-executable-path)
    ;; Customize `lsp-project-whitelist' `lsp-project-blacklist' to disable auto initialization.
    (add-hook 'c-mode-common-hook #'cquery//enable)

    :config
    (require 'projectile)
    (add-to-list 'projectile-globally-ignored-directories ".cquery_cached_index")

    (defun cquery--get-root ()
      "Return the root directory of a cquery project."
      (expand-file-name (or (locate-dominating-file default-directory "compile_commands.json")
                            (locate-dominating-file default-directory ".cquery")
                            )
                        (user-error "Could not find cquery project root")))


    (dolist (mode '("c" "c++" "go" "haskell" "javascript" "python" "rust"))
      (let ((handler (intern (format "spacemacs-jump-handlers-%s-mode" mode))))
        (add-to-list handler 'lsp-ui-peek-find-definitions))
      (let ((handler (intern (format "spacemacs-reference-handlers-%s-mode" mode))))
        (add-to-list handler 'lsp-ui-peek-find-references)))

    (spacemacs/set-leader-keys-for-minor-mode 'lsp-mode
      "la" #'lsp-ui-find-workspace-symbol
      "lA" #'lsp-ui-peek-find-workspace-symbol
      "lf" #'lsp-format-buffer
      "ll" #'lsp-ui-sideline-mode
      "lD" #'lsp-ui-doc-mode
      "ln" #'lsp-ui-find-next-reference
      "lp" #'lsp-ui-find-previous-reference
      "lr" #'lsp-rename
      )

    ;; (lsp-cquery-enable)

    (setq cquery-sem-highlight-method 'overlay)
    (cquery-use-default-rainbow-sem-highlight)
    (setq cquery-extra-init-params '(:cacheFormat "msgpack" :completion (:detailedLabel t)))

    (defun cquery/base () (interactive) (lsp-ui-peek-find-custom 'base "$cquery/base"))
    (defun cquery/callers () (interactive) (lsp-ui-peek-find-custom 'callers "$cquery/callers"))
    (defun cquery/derived () (interactive) (lsp-ui-peek-find-custom 'derived "$cquery/derived"))
    (defun cquery/vars () (interactive) (lsp-ui-peek-find-custom 'vars "$cquery/vars"))
    (defun cquery/random () (interactive) (lsp-ui-peek-find-custom 'random "$cquery/random"))
    (defun cquery/references-address ()
      (interactive)
      (lsp-ui-peek-find-custom
       'address "textDocument/references"
       (plist-put (lsp--text-document-position-params) :context
                  '(:role 128))))

    (defun cquery/references-read ()
      (interactive)
      (lsp-ui-peek-find-custom
       'read "textDocument/references"
       (plist-put (lsp--text-document-position-params) :context
                  '(:role 8))))

    (defun cquery/references-write ()
      (interactive)
      (lsp-ui-peek-find-custom
       'write "textDocument/references"
       (plist-put (lsp--text-document-position-params) :context
                  '(:role 16))))

    (dolist (mode c-c++-modes)
      (spacemacs/set-leader-keys-for-major-mode mode
        "lb" #'cquery/base
        "lc" #'cquery/callers
        "ld" #'cquery/derived
        "lR" #'cquery-freshen-index
        "lv" #'cquery/vars
        "l SPC" #'cquery/random
        "a" #'cquery/references-address
        "r" #'cquery/references-read
        "w" #'cquery/references-write
        ))
))

;; (defun cquery/init-company-lsp ()
;;   (use-package company-lsp))

(defun cquery/post-init-company-lsp ()
  (spacemacs|add-company-backends :backends company-lsp :modes c-mode-common))
