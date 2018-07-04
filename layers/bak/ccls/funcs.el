(require 'cl-lib)

(defun ccls//enable ()
  (when
      (and buffer-file-name
           (or (locate-dominating-file default-directory "compile_commands.json")
               (locate-dominating-file default-directory ".ccls")))
    (lsp-ccls-enable)))
