;; -*- coding: utf-8-unix; -*-
(use-package dap-ui
  :hook (dap-mode . dap-ui-mode))

(use-package dap-mode
  :commands (dap-mode dap-debug)
  :hook ((dap-mode . dap-ui-mode)
         (dap-mode . dap-tooltip-mode)
         (dap-mode . dap-ui-controls-mode)
         (dap-mode . my/dap-init-conf))
  :hook ((java-mode python-mode c++-mode) . dap-mode)
  :init
  (defun my/dap-init-conf ()
    (interactive)
    (cond
     ;; python config
     ((derived-mode-p 'python-mode 'python-ts-mode)
      (require 'dap-python)
      (setq dap-python-debugger 'debugpy)
      ;; 问题修复： pip install git+https://github.com/microsoft/debugpy.git@78b030f5092d91df64860914962333e89852ea9b
      ;; 参考： https://github.com/emacs-lsp/dap-mode/issues/636#issuecomment-1158896842

      (my/dap-python-register-dynamic)
      )

     ;; java config
     ((derived-mode-p 'java-mode)
      (require 'dap-java)
      ;;=====  java options
      (setenv "JAVA_OPTS" "-Xdebug -Xrunjdwp:transport=dt_socket,server=y,suspend=n,address=1044")



      ;; run main function, 参考： https://emacs-china.org/t/lsp-java-main-class/12371/7
      (dap-register-debug-template
       "Java Run"
       (list :type "java"
             :request "launch"
             :args ""
             :noDebug t
             :cwd nil
             :host "localhost"
             :request "launch"
             :modulePaths []
             :classPaths nil
             :name "JavaRun"
             :projectName nil
             :mainClass nil)))

     ;; cpp config
     ((derived-mode-p 'c++-mode c++-ts-mode)
      (require 'dap-cpptools))))


  (defun my/dap-python-register-dynamic ()
    (interactive)
    (dap-register-debug-template "Python: This Module"
                                 (list :type "python"
                                       :cwd (my/get-project-root)
                                       :module (my/python-get-module-name-cmd)
                                       :env '(("DEBUG" . "1"))
                                       :request "launch"
                                       :justMyCode t
                                       :name (format "Python: This Module" (my/python-get-module-name-cmd)))
                                 ))

  :config
  (defun my/dap-debug-advice-fn (debug-args)
    (cond ((derived-mode-p 'python-mode 'python-ts-mode)
           (my/dap-python-register-dynamic))))

  (advice-add 'dap-debug :before #'my/dap-debug-advice-fn)

  ;; show windows
  ;; Enabling only some features
  (setq dap-auto-configure-features '(locals controls tooltip))

  ;; for debug
  (setq dap-print-io t)

  (add-hook 'dap-stopped-hook
            (lambda (arg) (call-interactively #'dap-hydra)))

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

  )

(defun my/dap-hydra ()
  (interactive)
  (cond ((derived-mode-p 'python-mode 'python-ts-mode)
         (progn
           (require 'dap-python)
           (my/dap-python-register-dynamic))
         ))

  (funcall-interactively #'dap-hydra))

(provide 'init-dap-mode)
