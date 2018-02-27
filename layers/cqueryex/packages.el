(defconst cqueryex-packages
  '(
    evil
    lsp-ui
    lsp-ui-flycheck
    lsp-mode
    cquery
    ;; (company-lsp : requires cquery company)
    ))

(defun cqueryex/post-init-evil ()
  (add-to-list 'evil-emacs-state-modes 'xref--xref-buffer-mode)
  ;;   ;; (evil-define-key 'normal xref--xref-buffer-mode-map
  ;;   ;;   "q" 'quit-window
  ;;   ;;   "gj" 'xref-next-line
  ;;   ;;   "gk" 'xref-prev-line
  ;;   ;;   (kbd "C-j") 'xref-next-line
  ;;   ;;   (kbd "C-k") 'xref-prev-line
  ;;   ;;   "]" 'xref-next-line
  ;;   ;;   "[" 'xref-prev-line
  ;;   ;;   "r" 'xref-query-replace-in-results

  ;;   ;;   ;; open
  ;;   ;;   (kbd "<return>") 'xref-goto-xref
  ;;   ;;   (kbd "S-<return>") 'xref-show-location-at-point
  ;;   ;;   "o" 'xref-show-location-at-point ; TODO: Remove binding?
  ;;   ;;   "go" 'xref-show-location-at-point)

  (define-key evil-motion-state-map (kbd "M-?") 'xref-find-references)
  (define-key evil-motion-state-map (kbd "C-,") #'my-xref/find-references)
  (define-key evil-motion-state-map (kbd "C-j") #'my-xref/find-definitions)
  )

(defun cqueryex/post-init-lsp-ui ()
  (require 'lsp-imenu)
  (require 'lsp-ui)
  ;; (add-hook 'lsp-after-open-hook #'lsp-enable-imenu)
  ;; (lsp-enable-imenu)
  ;; (when ( > = emacs-major-version 26 )
  ;;   (lsp-ui-doc-mode 1))
  (add-hook 'lsp-after-open-hook #'lsp-enable-imenu)

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

(defun cqueryex/post-init-lsp-ui-flycheck ()
  (require 'lsp-ui-flycheck)
  (lsp-ui-flycheck-enable))
(setq-default flycheck-disabled-checkers '(c/c++-clang c/c++-gcc)) ;; in flycheck.el

(setq company-quickhelp-delay 0)
(setq company-show-numbers t)

;; (advice-add 'spacemacs/jump-to-definition :before #'my-advice/xref-set-jump)
;; (advice-add 'spacemacs/jump-to-reference :before #'my-advice/xref-set-jump)

;; ;; See also https://github.com/cquery-project/cquery/wiki/Emacs
(defun cqueryex/post-init-cquery ()
  (require 'cquery)
  ;; (with-eval-after-load 'cquery
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

  (lsp-cquery-enable)

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
      "lxa" #'cquery/references-address
      "lxr" #'cquery/references-read
      "lxw" #'cquery/references-write
      "lm" #'cquery-member-hierarchy
      ;; bases
      "li" #'cquery-inheritance-hierarchy
      ;; derived
      "lI" (lambda () (interactive) (cquery-inheritance-hierarchy t))
      ;; callers
      "lc" #'cquery-call-hierarchy
      ;; callees
      "lC" (lambda () (interactive) (cquery-call-hierarchy t))
      ))
  )
