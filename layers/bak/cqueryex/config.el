(defvar spacemacs-default-reference-handlers '(helm-gtags-find-rtag)
  "List of reference handlers available in every mode.")

(defvar-local spacemacs-reference-handlers '()
  "List of reference handlers local to this buffer.")

(spacemacs|define-reference-handlers c++-mode)
(spacemacs|define-reference-handlers c-mode)
(spacemacs|define-reference-handlers d-mode)
(spacemacs|define-reference-handlers go-mode)
(spacemacs|define-reference-handlers javascript-mode)
(spacemacs|define-reference-handlers haskell-mode)
(spacemacs|define-reference-handlers python-mode)
(spacemacs|define-reference-handlers rust-mode)

(spacemacs|define-jump-handlers c++-mode)
(spacemacs|define-jump-handlers c-mode)
(spacemacs|define-jump-handlers d-mode)
(spacemacs|define-jump-handlers go-mode)
(spacemacs|define-jump-handlers javascript-mode)
(spacemacs|define-jump-handlers haskell-mode)
(spacemacs|define-jump-handlers go-mode)
(spacemacs|define-jump-handlers python-mode)
(spacemacs|define-jump-handlers rust-mode)

(defvar my-xref-blacklist nil
  "List of paths that should not enable xref-find-* or dumb-jump-go")
(defconst c-c++-modes '(c-mode c++-mode)
  "Primary major modes of the `c-c++' layer.")
