;; -*- coding: utf-8; -*-
;;  pip install python-language-server[all]
;; * problem
;;   * to solve lsp server problem,
;;     1) delete folder: ~/.emacs.d/.cache/lsp/mspyls
;;     2) run (setq lsp-python-ms-auto-install-server t) ;; automatically install mspyls
;;   * Eldoc 
;;     * pyls: Colorful face
;;     * mspyls: poor face
;;
;; (setq lsp-clients-python-command "/usr/local/bin/pyls")
(load-file "~/.conf.d/lsp.emacs")
(load-file "~/.conf.d/pytest.emacs")

;; (load-file "~/.conf.d/lsp-pyright.emacs")
;; (load-file "~/.conf.d/lsp-sonarlint.emacs")

(use-package lsp-python-ms
  :ensure t
  :init (setq lsp-python-ms-auto-install-server t) ;; automatically install mspyls
  :hook (python-mode . (lambda ()
                          (require 'lsp-python-ms)
                          (lsp))))  ; or lsp-deferred



(require 'python)
(use-package lsp-mode
  :ensure t
  :config
  (add-hook 'python-mode-hook 'lsp)
  ;; make sure we have lsp-imenu everywhere we have LSP
  ;; (require 'lsp-imenu)
  ;; (add-hook 'lsp-after-open-hook 'lsp-enable-imenu)
  ;; get lsp-python-enable defined
  ;; NB: use either projectile-project-root or ffip-get-project-root-directory
  ;;     or any other function that can be used to find the root directory of a project
  ;; (lsp-define-stdio-client lsp-python "python"
               ;; #'projectile-project-root
               ;; '("pyls"))

  ;; make sure this is activated when python-mode is activated
  ;; lsp-python-enable is created by macro above
  ;; (add-hook 'python-mode-hook
        ;; (lambda ()
          ;; (lsp-python-enable)))

  ;; lsp extras
  (use-package lsp-ui
    :ensure t
    :config
    (setq lsp-ui-sideline-ignore-duplicate t)
    (add-hook 'lsp-mode-hook 'lsp-ui-mode))

  ;; NB: only required if you prefer flake8 instead of the default
  ;; send pyls config via lsp-after-initialize-hook -- harmless for
  ;; other servers due to pyls key, but would prefer only sending this
  ;; when pyls gets initialised (:initialize function in
  ;; lsp-define-stdio-client is invoked too early (before server
  ;; start)) -- cpbotha
  (defun lsp-set-cfg ()
    (let ((lsp-cfg `(:pyls (:configurationSources ("flake8")))))
      ;; TODO: check lsp--cur-workspace here to decide per server / project
      (lsp--set-configuration lsp-cfg)))

  (add-hook 'lsp-after-initialize-hook 'lsp-set-cfg)
  ;; (setq lsp-pyls-plugins-pycodestyle-enabled nil)
  ;; (setq lsp-pyls-configuration-sources ["flake8"])
  ;; (setq lsp-pyls-plugins-flake8-config-enabled t)
  )


(add-hook 'lsp-mode-hook
	  (lambda ()
	    ;; (local-unset-key (kbd "C-c C-n"))
	    ;; (local-set-key (kbd "C-c C-n") 'flymake-goto-next-error)
	    ;; (local-unset-key (kbd "C-c C-p"))
	    ;; (local-set-key (kbd "C-c C-p") 'flymake-goto-prev-error)
	    ;; (local-unset-key (kbd "C-c C-l"))
	    ;; (local-set-key (kbd "C-c C-l") 'flymake-show-diagnostics-buffer)

	    ;; (local-unset-key (kbd "C - c SPC C - n"))
	    ;; (local-unset-key (kbd "C - c SPC C -"))
	    ;; (local-set-key (kbd "C") 'self-insert-command)
	    ;; (local-unset-key (kbd "M-,"))
	    ;; (local-set-key (kbd "M-,") 'xref-pop-marker-stack)
	    ;; (local-unset-key (kbd "C-,"))
	    ;; (local-set-key (kbd "C-,") 'xref-pop-marker-stack)

	    ;; (local-unset-key (kbd "M-*"))
	    ;; (local-set-key (kbd "M-*") 'lsp-ui-peek-find-references)

	    ))

