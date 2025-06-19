(my/straight-if-use 'dashboard)
(use-package dashboard
  :init
  ;; (dashboard-setup-startup-hook)
  (setq dashboard-agenda-release-buffers t)
  :hook ((my/startup . open-dashboard)
	 )
  
  ;; :bind ("C-c o d" . open-dashboard)
  :commands (open-dashboard)
  :bind (:map dashboard-mode-map
              ("n" . dashboard-next-line)
              ("p" . dashboard-previous-line)
              ("M-n" . dashboard-next-section)
              ("M-p" . dashboard-previous-section))
  :config
  (setq dashboard-set-heading-icons t
        dashboard-set-file-icons t
        dashboard-projects-backend 'project-el
        dashboard-items '((projects . 5)
                          (recents . 5)
                          ;; (bookmarks . 5)
                          (agenda . 5)
                          )
        )
  (if (require 'nerd-icons nil t)
      (setq dashboard-icon-type 'nerd-icons))
  (defun open-dashboard ()
    "Open the *dashboard* buffer and jump to the first widget."
    (interactive)
    ;; (dashboard-setup-startup-hook)
    ;; Check if need to recover layout
    (if (length> (window-list-1)
                 ;; exclude `treemacs' window
                 (if (and (fboundp 'treemacs-current-visibility)
                          (eq (treemacs-current-visibility) 'visible))
                     2
                   1))
        (setq dashboard-recover-layout-p t))

    ;; Display dashboard in maximized window
    (delete-other-windows)

    ;; Refresh dashboard buffer
    (dashboard-refresh-buffer)

    ;; Jump to the first section
    (dashboard-goto-recent-files)
    (remove-hook 'my/startup-hook #'open-dashboard))

  (defun dashboard-goto-recent-files ()
    "Go to recent files."
    (interactive)
    (let ((func (local-key-binding "r")))
      (and func (funcall func))))

  (add-to-list 'dashboard-items '(projects . 5)))

(provide 'init-dashboard)
