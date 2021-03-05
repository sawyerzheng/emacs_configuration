;; -*- coding: utf-8; -*-
(use-package projectile :ensure t)
(use-package treemacs :ensure t)
(use-package yasnippet :ensure t)
(use-package lsp-mode :ensure t)
(use-package hydra :ensure t)

;; optionally
(use-package lsp-ui
  :ensure t
  ;; :commands lsp-ui-mode
  :custom
  (lsp-ui-doc-enable nil)
  :config
  (require 'lsp-ui-sideline)
  ;; (require 'lsp-ui-flycheck)
  ;; * doc
  (require 'lsp-ui-doc)
  ;; (setq lsp-ui-doc-enable nil)
  ;; * peek
  (require 'lsp-ui-peek)
  ;; (define-key lsp-ui-mode-map
  ;;   [remap xref-find-definitions] #'lsp-ui-peek-find-definitions)
  ;; (define-key lsp-ui-mode-map
  ;;   [remap xref-find-references] #'lsp-ui-peek-find-references)

  (define-key lsp-ui-mode-map (kbd "M-.") #'lsp-ui-peek-find-definitions)
  (define-key lsp-ui-mode-map (kbd "M-,") #'xref-pop-marker-stack)
  (define-key lsp-ui-mode-map (kbd "M-*") #'lsp-ui-peek-find-references)

  ;; lsp-ui-doc
  (define-key lsp-ui-mode-map (kbd "C-c i") #'lsp-ui-doc-focus-frame)
  (define-key lsp-ui-mode-map (kbd "C-c C-i") #'lsp-ui-doc-focus-frame)
  (define-key lsp-ui-mode-map (kbd "C-c o") #'lsp-ui-doc-hide)
  (define-key lsp-ui-doc-frame-mode-map (kbd "C-c o") #'lsp-ui-doc-unfocus-frame)

  ;; flycheck
  (define-key lsp-mode-map (kbd "C-c C-n") 'flycheck-next-error)
  (define-key lsp-mode-map (kbd "C-c C-p") 'flycheck-previous-error)
  (define-key lsp-mode-map (kbd "C-c l") '(lambda ()
                        (interactive)
                        (flycheck-mode 1)
                        (flycheck-list-errors)
                        (pop-to-buffer "*Flycheck errors*")))

  ;; * imenum
  (require 'lsp-ui-imenu)
  (add-hook 'lsp-ui-imenu-mode-hook
      '(lambda ()
         (local-set-key (kbd "n") 'next-line)
         (local-set-key (kbd "p") 'previous-line)))
  (add-to-list 'prog-mode-hook '(lambda ()
                  (local-set-key (kbd "M-i") 'lsp-ui-imenu)))


  )

;; (use-package
  ;; :ensure t)

(defun my-lsp-common-config ()
  ;; document
  (local-unset-key (kbd "C-c C-d"))
  (local-set-key (kbd "C-c C-d") 'lsp-ui-doc-show))
(add-hook 'lsp-mode-hook 'my-lsp-common-config)


;; https://github.com/emacs-lsp/lsp-treemacs#summary
(use-package lsp-treemacs
  :ensure t
  :commands lsp-treemacs-errors-list)
;; optionally if you want to use debugger


;;========== lsp-ui-imenu

;;=========== toggle document tip
(defun toggle-show-doc ()
  "toggle if show the java doc"
  (interactive)
  ;; (if (not lsp-ui-doc-enable)
  (if (not lsp-ui-doc-mode)
      (progn
    (custom-set-variables
     '(lsp-ui-doc-enable t)
     '(lsp-ui-doc-max-height 20)
     '(lsp-ui-doc-max-width 80)
     '(lsp-ui-doc-position (quote at-point)))
     (lsp-ui-doc-mode t))
    (progn
      (custom-set-variables
       '(lsp-ui-doc-enable nil)
       '(lsp-ui-doc-max-height 20)
       '(lsp-ui-doc-max-width 80)
       '(lsp-ui-doc-position (quote at-point)))
      (lsp-ui-doc-mode -1)
      )))

(defun toggle-show-slideline ()
  "toggle if show the java doc"
  (interactive)
  ;; (if (not lsp-ui-doc-enable)
  (if (not lsp-ui-sideline-mode)
      (progn
    (custom-set-variables
     '(lsp-ui-imenu-enable t)
     '(lsp-ui-peek-enable t)
     '(lsp-ui-sideline-enable t))
    (lsp-ui-sideline-mode t))
    (progn
      (custom-set-variables
       '(lsp-ui-imenu-enable nil)
       '(lsp-ui-peek-enable nil)
       '(lsp-ui-sideline-enable nil))
      (lsp-ui-sideline-mode -1))
    ))
