;; -*- coding: utf-8; -*-
(use-package lsp-bridge
  :straight (lsp-bridge :type git :host github :repo "manateelazycat/lsp-bridge" :files ("*"))
  :commands (lsp-bridge-rename lsp-bridge-mode global-lsp-bridge-mode)
  ;; :hook (after-init . global-lsp-bridge-mode)
  :bind (:map lsp-bridge-mode-map
              ("M-." . lsp-bridge-find-def)
              ("M-," . lsp-bridge-return-from-def)
              ("M-*" . lsp-bridge-find-references)
              ("M-?" . lsp-bridge-find-references)
              ("C-M-." . lsp-bridge-popup-documentation-scroll-up)
              ("C-M-," . lsp-bridge-popup-documentation-scroll-down))
  :custom
  (lsp-bridge-enable-signature-help t)
  (lsp-bridge-enable-candidate-doc-preview t)

  ;; :bind-keymap
  ;; ("M-\"" . my-lsp-bridge-keymap)
  ;; :init
  ;; (when (featurep 'evil)
  ;;   :m "gd" #'lsp-bridge-find-def
  ;;   :m "gD" #'lsp-bridge-find-references
  ;;   :m "gI" #'lsp-bridge-find-impl)

  :config
  (setq lsp-bridge-c-lsp-server "ccls")

  (defun my-lsp-bridge-toggle-acm-english-completion ()
    (interactive)
    (if acm-enable-english-helper
        (setq acm-enable-english-helper nil)
      (setq acm-enable-english-helper t)))

  (defun my-lsp-bridge-toggle-condidate-doc-preview ()
    (interactive)
    (if lsp-bridge-enable-candidate-doc-preview
        (setq lsp-bridge-enable-candidate-doc-preview nil)
      (setq lsp-bridge-enable-candidate-doc-preview t)))

  (defun my-lsp-toggle-variable (var)
    ;; (interactive)
    (if var
        (setq var nil)
      (setq var t)))
  (defvar my-lsp-bridge-keymap
    (let ((map (make-sparse-keymap)))

      (define-key map (kbd "gd") #'lsp-bridge-find-def)
      (define-key map (kbd "gD") #'lsp-bridge-find-references)
      (define-key map (kbd "gi") #'lsp-bridge-find-impl)
      (define-key map (kbd "gI") #'lsp-bridge-find-impl-other-window)
      (define-key map (kbd "gr") #'lsp-bridge-return-from-def)

      (define-key map (kbd "hh") #'lsp-bridge-lookup-documentation)

      (define-key map (kbd "rr") #'lsp-bridge-rename)
      (define-key map (kbd "rf") #'lsp-bridge-rename-file)
      (define-key map (kbd "rh") #'lsp-bridge-rename-highlight)

      (define-key map (kbd "en") #'lsp-bridge-jump-to-next-diagnostic)
      (define-key map (kbd "ep") #'lsp-bridge-jump-to-prev-diagnostic)
      (define-key map (kbd "el") #'lsp-bridge-list-diagnostics)
      (define-key map (kbd "ei") #'lsp-bridge-ignore-current-diagnostic)

      (define-key map (kbd "wr") #'lsp-bridge-restart-process)
      (define-key map (kbd "wk") #'lsp-bridge-kill-process)

      (define-key map (kbd "Te") #'my-lsp-bridge-toggle-acm-english-completion)
      (define-key map (kbd "Td") #'my-lsp-bridge-toggle-condidate-doc-preview)


      map)
    "my keymap for `lsp-bridge'")

  (define-key lsp-bridge-mode-map (kbd "M-\'") my-lsp-bridge-keymap)


  (setq lsp-bridge-python-file
        (expand-file-name "../../../repos/lsp-bridge/lsp_bridge.py" (locate-library "lsp-bridge")))
  (setq lsp-bridge-python-command
        (cond (my/windows-p "d:/soft/miniconda3/envs/tools/python.exe")
              (t "~/miniconda3/envs/tools/bin/python")))


  ;; for commit 14e8c0baefd931a8436d80578e64ebd2deac6b98

  (require 'yasnippet)
  (require 'lsp-bridge)
  (require 'lsp-bridge-jdtls) ;; provide Java third-party library jump and -data directory support, optional

  (yas-global-mode 1)
  ;; (global-lsp-bridge-mode)

  ;; doc tooltip
  (if my/4k-p
      (setq lsp-bridge-lookup-doc-tooltip-border-width 20)
    (setq lsp-bridge-lookup-doc-tooltip-border-width 5)))


(provide 'init-lsp-bridge)
