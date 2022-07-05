;; -*- coding: utf-8-unix; -*-
(use-package org
  :commands org-mode
  :config
  ;; 点亮列表 '-' 和 '+', '*', '1)'
  (font-lock-add-keywords 'org-mode '(("^[ \t]*[+-] " . 'font-lock-keyword-face)
                                      ("^[ \t]+\\* " . 'font-lock-keyword-face)
                                      ("^[ \t]*[[:digit:]]+) " . 'font-lock-keyword-face)
                                      ))
  
  (setq org-edit-src-content-indentation 0)
  (setq org-src-preserve-indentation nil)
  (setq org-indent-indentation-per-level 2)

  (add-hook 'org-mode-hook
            (lambda ()
              (setq-local tab-width 4)))

  ;; org tempo templates
  (require 'org-tempo)
  (add-to-list 'org-structure-template-alist '("py" . "src python"))
  (add-to-list 'org-structure-template-alist '("el" . "src elisp"))
  (add-to-list 'org-structure-template-alist '("cpp" . "src cpp"))
  (add-to-list 'org-structure-template-alist '("java" . "src java"))
  (add-to-list 'org-structure-template-alist '("sh" . "src shell"))
  (add-to-list 'org-structure-template-alist '("xml" . "src xml"))
  (add-to-list 'org-structure-template-alist '("jp" . "src jupyter-python"))

  ;; Source Code 文本高亮
  (setq org-src-fontify-natively t)
  )


(use-package org-indent
  :hook (org-mode . org-indent-mode))

;; org-download
(use-package org-download
  :straight t
  :after org
  :hook ((org-mode dired-mode) . org-download-enable)
  :bind (:map org-mode-map
              ;; download image object from clipboard
              ("C-c l i i" . org-download-clipboard)
              ("C-c l i c" . org-download-screenshot)
              ;; input link by hand
              ("C-c l i h" . org-download-image))
  :config
  ;; (add-hook 'dired-mode-hook 'org-download-enable)
  (setq-default org-download-image-org-width 0)
  ;; not use heading name to store image
  (setq-default org-download-heading-lvl nil)
  )

;; url
(use-package org-cliplink
  :straight t
  :commands (org-cliplink org-cliplink-capture)
  :bind ("C-c l l c" . org-cliplink)
  :after org)

;; clip
(use-package org-rich-yank
  :straight t
  :after org
  :bind (:map org-mode-map
              ("C-M-y" . org-rich-yank)))

;; beatify
(use-package org-superstar
  :straight t  
  :after org
  :hook (org-mode . org-superstar-mode))

(use-package org-fancy-priorities
  :straight t  
  :after org
  :hook
  (org-mode . org-fancy-priorities-mode)
  :config
  ;; (setq org-fancy-priorities-list '("⚡" "⬆" "⬇" "☕")
  )

(use-package ox
  :straight (:type built-in)
  :commands (org-export-dispatch)
  :config
  (use-package ox-pandoc
    :straight t
    :demand t))

(provide 'init-org)
