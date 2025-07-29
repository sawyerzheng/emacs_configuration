;;; init-org-image-slice.el --- Description -*- lexical-binding: t; -*-
;;
;; Copyright (C) 2025
;;
;; Author:  <sawyer@jishutest>
;; Maintainer:  <sawyer@jishutest>
;; Created: July 29, 2025
;; Modified: July 29, 2025
;; Version: 0.0.1
;; Keywords: abbrev bib c calendar comm convenience data docs emulations extensions faces files frames games hardware help hypermedia i18n internal languages lisp local maint mail matching mouse multimedia news outlines processes terminals tex text tools unix vc wp
;; Homepage: https://github.com/sawyerzheng/init-org-image-slice
;; Package-Requires: ((emacs "24.3"))
;;
;; This file is not part of GNU Emacs.
;;
;;; Commentary:
;;
;;  Description
;;
;;; Code:
;;; 支持 org-mode 中，`图片按行滚动',而不出一次滚动整个图片大幅度滚动
;; ;; ref: https://github.com/jcfk/org-sliced-images
(use-package
  :if t ;; 测试发现，切分后的图片有黑条，停止使用
  ;; :after org
  ;; (org-sliced-images-mode 1)
  :commands (org-sliced-images-mode)
  )


(provide 'init-org-image-slice)
;;; init-org-image-slice.el ends here
