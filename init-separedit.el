(use-package separedit
  :straight t
  :init
  (require 'init-helpful)
  (require 'helpful)
  :bind (
         :map prog-mode-map
         ("C-c '" . separedit)
         :map minibuffer-local-map
         ("C-c '" . separedit)
         :map help-mode-map
         ("C-c '" . separedit)
         :map helpful-mode-map
         ("C-c '" . separedit))
  :config
  (setq separedit-default-mode 'org-mode)

  ;; config org-mode without org-indent-mode
  (add-hook 'separedit-buffer-creation-hook #'(lambda ()
                                                (when (eq major-mode 'org-mode))
                                                (setq org-adapt-indentation t)
                                                (setq org-edit-src-content-indentation 2)
                                                (setq org-src-preserve-indentation t)

                                                (org-indent-mode -1)))

  ;; Feature options
  ;; (setq separedit-preserve-string-indentation t)
  ;; (setq separedit-continue-fill-column t)
  ;; (setq separedit-write-file-when-execute-save t)
  ;; (setq separedit-remove-trailing-spaces-in-comment t)
  )
(provide 'init-separedit)
