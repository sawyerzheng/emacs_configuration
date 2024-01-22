(use-package anaconda-mode
  :straight t
  :config
  (defun my/anaconda-mode-completion-fix ()
    (unless (featurep 'cape)
      (require 'init-corfu))
    (setq-local completion-at-point-functions
                (list
                 #'cape-file
                 (cape-super-capf
                  #'company-anaconda
                  #'tempel-expand))))
  :hook (anaconda-mode . my/anaconda-mode-completion-fix))

(defun my-enable-anaconda-mode ()
  (interactive)
  (add-hook 'python-base-mode-hook #'anaconda-mode)
  (add-hook 'python-base-mode-hook #'anaconda-eldoc-mode)
  (remove-hook 'python-base-mode-hook #'my-start-eglot-fn)
  (remove-hook 'python-base-mode-hook #'my-start-lsp-mode-fn)
  (remove-hook 'python-base-mode-hook #'my-start-lsp-bridge-fn))

(defun my-disable-anaconda-mode ()
  (interactive)
  (remove-hook 'python-base-mode-hook #'anaconda-mode)
  (remove-hook 'python-base-mode-hook #'anaconda-eldoc-mode))

(use-package company-anaconda
  :straight t
  :after anaconda-mode)

(provide 'init-anaconda-mode)
