;; -*- coding: utf-8-unix; -*-
(use-package dap-mode
  :after evil
  :hook (
		 ;; (prog-mode . dap-mode)
		 (dap-mode . dap-tooltip-mode)
		 (dap-mode . tooltip-mode)
		 )
  ;; :ensure-system-package
  ;; (ptvsd . "pip install ptvsd")
  :config
  (setq dap-print-io t)
  ;; enables mouse hover support
  ;; (dap-tooltip-mode 1)
  ;; use tooltips for mouse hover
  ;; if it is not enabled `dap-mode' will use the minibuffer.
  ;; (tooltip-mode 1)

  (add-hook 'dap-stopped-hook
			(lambda (arg) (call-interactively #'dap-hydra)))

  (add-hook 'dap-mode-hook
			(lambda ()
			  (local-unset-key (kbd "<f7>"))
			  (local-set-key (kbd "<f7>") 'dap-hydra)))
  )

(use-package dap-ui
  :hook (dap-mode . dap-ui-mode)
  )

;;============ windows
(defun my/window-visible (b-name)
  "Return whether B-NAME is visible."
  (-> (-compose 'buffer-name 'window-buffer)
      (-map (window-list))
      (-contains? b-name)))

(defun my/show-debug-windows (session)
  "Show debug windows."
  (let ((lsp--cur-workspace (dap--debug-session-workspace session)))
    (save-excursion
      ;; display locals
      (unless (my/window-visible dap-ui--locals-buffer)
        (dap-ui-locals))
      ;; display sessions
      (unless (my/window-visible dap-ui--sessions-buffer)
        (dap-ui-sessions)))))

(add-hook 'dap-stopped-hook 'my/show-debug-windows)

(defun my/hide-debug-windows (session)
  "Hide debug windows when all debug sessions are dead."
  (unless (-filter 'dap--session-running (dap--get-sessions))
    (and (get-buffer dap-ui--sessions-buffer)
         (kill-buffer dap-ui--sessions-buffer))
    (and (get-buffer dap-ui--locals-buffer)
         (kill-buffer dap-ui--locals-buffer))))

(add-hook 'dap-terminated-hook 'my/hide-debug-windows)


;;=========== minor modes when debug
;; -*- lexical-binding: t -*-
(define-minor-mode +dap-running-session-mode
  "A mode for adding keybindings to running sessions"
  nil
  nil
  (make-sparse-keymap)
  (evil-normalize-keymaps) ;; if you use evil, this is necessary to update the keymaps
  ;; The following code adds to the dap-terminated-hook
  ;; so that this minor mode will be deactivated when the debugger finishes
  (when +dap-running-session-mode
    (let ((session-at-creation (dap--cur-active-session-or-die)))
      (add-hook 'dap-terminated-hook
                (lambda (session)
                  (when (eq session session-at-creation)
                    (+dap-running-session-mode -1)))))))

;; Activate this minor mode when dap is initialized
;; (add-hook 'dap-session-created-hook '+dap-running-session-mode)

;; Activate this minor mode when hitting a breakpoint in another file
;; (add-hook 'dap-stopped-hook '+dap-running-session-mode)

;; Activate this minor mode when stepping into code in another file
;; (add-hook 'dap-stack-frame-changed-hook (lambda (session)
;;                                           (when (dap--session-running session)
;;                                             (+dap-running-session-mode 1))))

;;=====  java options
(setenv "JAVA_OPTS" "-Xdebug -Xrunjdwp:transport=dt_socket,server=y,suspend=n,address=1044")

(provide 'init-dap-mode)
