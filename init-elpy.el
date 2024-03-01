(use-package elpy
  :straight t
  :commands (elpy-mode)
  :bind (:map elpy-mode-map
              ;; ("M-i" . elpy-company-backend)
              ))

(defun my/elpy-enable ()
  (interactive)
  (unless (functionp 'elpy-mode)
    (require 'elpy))
  (unless (and (boundp 'elpy-enabled-p) elpy-enabled-p)
    (elpy-enable))

  (my-disable-eglot)
  (my-disable-lsp-mode)
  (my-disable-lsp-bridge)


  (add-hook 'python-mode-hook #'elpy-mode)
  (add-hook 'elpy-mode-hook (lambda ()
                              (company-mode -1)
                              (add-to-list 'completion-at-point-functions (cape-company-to-capf 'elpy-company-backend))))


  ;; (add-hook 'python-mode-hook #'auto-complete-mode)
  ;; (add-hook 'python-mode-hook #'corfu-mode)
  )

(defun my/elpy-disable ()
  (interactive)
  (remove-hook 'python-mode-hook #'elpy-mode)
  (remove-hook 'python-mode-hook #'auto-complete-mode)
  (remove-hook 'python-mode-hook #'corfu-mode)
  (elpy-disable))

(defvar my/elpy-map (make-sparse-keymap)
  "my key bindings for elpy mode")
(with-eval-after-load 'elpy
  (define-key elpy-mode-map (kbd "M-'") my/elpy-map)

  (define-key my/elpy-map (kbd "ee") #'elpy-flymake-error-at-point)
  (define-key my/elpy-map (kbd "en") #'elpy-flymake-next-error)
  (define-key my/elpy-map (kbd "ep") #'elpy-flymake-previous-error)
  (define-key my/elpy-map (kbd "el") #'elpy-flymake-show-error)

  (define-key my/elpy-map (kbd "gd") #'elpy-goto-definition)

  (define-key my/elpy-map (kbd "wr") #'elpy-rpc-restart)
  (define-key my/elpy-map (kbd "wR") #'elpy-rpc-reinstall-virtualenv)

  (define-key my/elpy-map (kbd "==") #'elpy-format-code)

  (define-key my/elpy-map (kbd "rr") #'elpy-refactor-rename)
  (define-key my/elpy-map (kbd "ri") #'elpy-refactor-inline)
  (define-key my/elpy-map (kbd "ref") #'elpy-refactor-extract-function)
  (define-key my/elpy-map (kbd "rev") #'elpy-refactor-extract-variable)

  (define-key my/elpy-map (kbd "hh") #'elpy-doc))




(provide 'init-elpy)
