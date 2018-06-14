;;; packages.el --- gitlab layer packages file for Spacemacs.
;;
;; Copyright (c) 2012-2018 Sylvain Benner & Contributors
;;
;; Author: Alexander Dalshov <adalshov@sr-dev-103>
;; URL: https://github.com/syl20bnr/spacemacs
;;
;; This file is not part of GNU Emacs.
;;
;;; License: GPLv3

;;; Commentary:

;; See the Spacemacs documentation and FAQs for instructions on how to implement
;; a new layer:
;;
;;   SPC h SPC layers RET
;;
;;
;; Briefly, each package to be installed or configured by this layer should be
;; added to `gitlab-packages'. Then, for each package PACKAGE:
;;
;; - If PACKAGE is not referenced by any other Spacemacs layer, define a
;;   function `gitlab/init-PACKAGE' to load and initialize the package.

;; - Otherwise, PACKAGE is already referenced by another Spacemacs layer, so
;;   define the functions `gitlab/pre-init-PACKAGE' and/or
;;   `gitlab/post-init-PACKAGE' to customize the package as it is loaded.

;;; Code:

(setq gitlab-packages
      '(
        gitlab
        ))

;; List of packages to exclude.
(setq gitlab-excluded-packages '())

;;
(defun gitlab/init-gitlab ()
  "Initialize my package"
  (use-package gitlab
    :defer t
    :init
    (setq gitlab-host ""
          gitlab-username ""
          gitlab-token-id ""))
  )

;;; packages.el ends here
