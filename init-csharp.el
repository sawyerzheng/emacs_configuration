;; -*- coding: utf-8; -*-
;; ----- omnisharp server install --------
;; 1) https://github.com/OmniSharp/omnisharp-emacs/blob/master/doc/server-installation.md
;; 2) on windows x64 version has compatibility problem
;; 3) lsp can use omnisharp-roslyn v1.35.4 (Tested).

(use-package csharp-mode
  :straight t)

(use-package omnisharp
  :ensure t

  :config
  ;; for function and class jumping
  (define-key omnisharp-mode-map (kbd "M-.") #'omnisharp-go-to-definition)
  (define-key omnisharp-mode-map (kbd "M-,") #'xref-pop-marker-stack)
  (define-key omnisharp-mode-map (kbd "M-*") #'omnisharp-find-usages)

  ;; rename
  (define-key omnisharp-mode-map (kbd "C-c C-r g") #'omnisharp-rename)

  ;; document
  (define-key omnisharp-mode-map (kbd "C-c C-d") #'omnisharp-current-type-documentation)
  (define-key omnisharp-mode-map (kbd "C-h .") #'omnisharp-current-type-information)

  ;; server
  (define-key omnisharp-mode-map (kbd "C-c C-b") #'omnisharp-start-omnisharp-server)
  )
(add-hook 'csharp-mode-hook 'omnisharp-mode)
(setq omnisharp-server-executable-path "D:\\programs\\omnisharp-win-x86\\OmniSharp.exe")

;; (load-file "~/.conf.d/lsp-csharp.emacs")




(eval-after-load
 'company
 '(add-to-list 'company-backends 'company-omnisharp))


(defun my-csharp-mode-setup ()
  (omnisharp-mode)
  (company-mode)
  (flycheck-mode)

  (setq indent-tabs-mode nil)
  (setq c-syntactic-indentation t)
  (c-set-style "ellemtel")
  ;; (setq c-basic-offset 4)
  ;; (setq tab-width 4)
  ;; (setq evil-shift-width 4)
  (setq truncate-lines t)

  ;csharp-mode README.md recommends this too
  ;(electric-pair-mode 1)       ;; Emacs 24
  ;(electric-pair-local-mode 1) ;; Emacs 25

  (local-set-key (kbd "C-c C-r r") 'omnisharp-run-code-action-refactoring)
  (local-set-key (kbd "C-c C-c") 'recompile)


  )

(add-hook 'csharp-mode-hook 'my-csharp-mode-setup t)

(provide 'init-csharp)
