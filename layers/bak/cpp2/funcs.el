
(defun spacemacs/clang-format-function (&optional style)
  "Format the current function with clang-format according to STYLE."
  (interactive)
  (save-excursion
    (c-mark-function)
    (clang-format (region-beginning) (region-end) style)
    (deactivate-mark) ; If the function is already formatted, then remove the mark
    (message "Formatted function %s" (c-defun-name))))

(defun spacemacs/clang-format-region-or-buffer (&optional style)
  "Format the current region or buffer with clang-format according to STYLE."
  (interactive)
  (save-excursion
    (if (region-active-p)
        (progn
          (clang-format-region (region-beginning) (region-end) style)
          (message "Formatted region"))
      (progn
        (clang-format-buffer style)
        (message "Formatted buffer %s" (buffer-name))))))

(defun spacemacs//clang-format-on-save ()
  "Format the current buffer with clang-format on save when
`c-c++-enable-clang-format-on-save' is non-nil."
  (when c-c++-enable-clang-format-on-save
    (spacemacs/clang-format-region-or-buffer)))

(defun spacemacs/clang-format-on-save ()
  "Add before-save hook for clang-format."
  (add-hook 'before-save-hook 'spacemacs//clang-format-on-save nil t))
