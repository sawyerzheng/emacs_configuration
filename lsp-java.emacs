;; -*- coding: utf-8-unix; -*-
(require 'cc-mode)


(use-package projectile :ensure t)
(use-package treemacs :ensure t)
(use-package yasnippet :ensure t)
(use-package lsp-mode :ensure t)
(use-package hydra :ensure t)
(use-package company-lsp :ensure t)
(use-package lsp-ui :ensure t)

(use-package lsp-java
  :ensure t
  :after lsp
  :config (add-hook 'java-mode-hook 'lsp))


;; (use-package lsp-mode
;;   :hook (XXX-mode . lsp)
;;   :commands lsp)

;; optionally
(use-package lsp-ui
  :ensure t
  :commands lsp-ui-mode)
(use-package company-lsp
  :ensure t
  :commands company-lsp)

;; helm-lsp-workspace-symbol
;; help-lsp-global-workspace-symbol
(use-package helm-lsp
  :ensure t
  :commands helm-lsp-workspace-symbol)

;; https://github.com/emacs-lsp/lsp-treemacs#summary
(use-package lsp-treemacs
  :ensure t
  :commands lsp-treemacs-errors-list)
;; optionally if you want to use debugger

;; (use-package dap-LANGUAGE) to load the dap adapter for your language
(use-package dap-mode
  :ensure t
  :after lsp-mode
  :config
  (dap-mode t)
  (dap-ui-mode t))

(use-package dap-java :after (lsp-java))

;;===== sts4,  Spring Tools 4 ===============
(require 'lsp-java-boot)

;; to enable the lenses
(add-hook 'lsp-mode-hook #'lsp-lens-mode)
(add-hook 'java-mode-hook #'lsp-java-boot-lens-mode)

;; living application info hovers
(add-hook 'java-mode-hook #'lsp-java-boot-lens-mode)

;; inhibit annoying debug notices
(setq lsp-inhibit-message t)

;;=========== indentation ================
(add-hook 'java-mode-hook (lambda ()
                            (setq c-basic-offset 4
                                  tab-width 4
                                  indent-tabs-mode t)))

(add-hook 'lsp-mode-hook (lambda ()
                            (setq c-basic-offset 4
                                  tab-width 4
                                  indent-tabs-mode t)))

;;=== flycheck
(add-hook 'java-mode '(lambda ()
		       (flycheck-mode)))


;;=========== key mapping ==============================
(global-set-key (kbd "C-c C-x") 'hydra-java-quick/body)
(defhydra hydra-java-quick (:hint nil :exit t)
  "
^Edit^                           ^Tast or Task^
^^^^^^-------------------------------------------------------
_c_: meghanada-compile-file      _b_: lsp-java-build-project
_d_: lsp-treemacs-java-deps-list _e_: meghanada-exec-main
_s_: lsp-treemacs-symbols        _h_: helm-lsp-workspace-symbol
_i_: lsp-ui-imenu                _q_: exit 
_t_: treemacs                    _r_: run-with-gradlew
_f_: helm-find                   _m_: More detail documents
"
  ("c" meghanada-compile-file)
  ("b" lsp-java-build-project)


  ("e" meghanada-exec-main)
  ;; ("r" (lambda () (interactive)(gradlew "run")))
  ("r" gradlew)
  ("d" lsp-treemacs-java-deps-list)

  ("m" toggle-show-doc)
  ("f" helm-find)
  ("h" helm-lsp-workspace-symbol)
  ("s" lsp-treemacs-symbols)
  ("i" lsp-ui-imenu)
  ("t" treemacs)
  ("q" exit)
  ("z" nil "leave"))


;;============= test commmands ===============
;; Execute gradlew for a project. Option is a string for args.
(defun gradlew (&optional option)
  "run gradlew command at project root"
  (interactive)
  ;; default gradlew option --> run
  (unless option
    (setq option "run"))

  ;; gradle command
  (if (equal system-type 'gnu/linux)
      (setq soft "gradlew")
    (setq soft "gradlew.bat"))
  ;; project directory
  (setq proj-path (lsp-java--get-root))

  ;; create a buffer for output
  (if option
      (setq newBuffName (format "*Gradlew %s*" (capitalize (car (split-string option)))))
    (setq newBuffName "*Gradlew*"))
  (setq newBuff (get-buffer-create newBuffName))
  ;; clear previous content
  (with-current-buffer newBuff
      (setf (buffer-string) ""))

  
  ;; build file
  (setq buildFile (expand-file-name "build.gradle" proj-path))
  ;; concat command
  (setq command (expand-file-name soft proj-path))
  ;;  (setq exp (concat command " " option " -b " buildFile))
  (setq exp (concat "gradle wrapper" " " option " -b " buildFile))
  (princ exp newBuff)
  (princ "\n" newBuff)
  (princ "=======" newBuff)
  (princ "\n" newBuff)
  ;; execute and print the output
  ;; (setq words (shell-command-to-string exp))
  ;; (princ words newBuff)
  (princ "\n" newBuff)
  (with-current-buffer newBuff
    ;; (princ buildFile newBuff)
    ;; (setq args (concat " wrapper " option " -b " "\"" buildFile "\""))
    ;; (print args newBuff)
    ;; (call-process "gradle" nil newBuff nil args)

    ;; 注意：call-process 调用%rest ARGS 方法，不能是list
    ;; 或多个子字符串合在一起,
    ;; 只能是一个个单独的字符串，一一列举
    (call-process "gradle" nil newBuff nil  "-q" option "-b" buildFile)
    )

  ;; (switch-to-buffer-other-frame newBuff)
  ;; (local-set-key (kbd "q") 'kill-this-buffer)

  ;; === focus on current previous window
  ;; (display-buffer newBuff nil (window-frame))

  ;; === focus on the new window

  (when (not (buffer-file-name)) (save-buffer))
  (when (buffer-modified-p) (save-buffer))
  (save-some-buffers)
  (pop-to-buffer newBuff)

  (with-current-buffer newBuff
    ;; (groovy-mode)
    (ignore-errors
      (funcall 'groovy-mode)
      (read-only-mode -1))
    (local-set-key (kbd "q") 'quit-window)
    )
  )


(defun run-with-gradlew ()
  "Run 'gradlew run' only"
  (interactive)
  (setq choices '("build" "init" "run"))
  (gradlew (ido-completing-read "gradlew command: " choices)))

(defalias 'rwg 'run-with-gradlew
  "Alias of function run-with-gradlew")

;; (ido-completing-read "gradlew command: " choices)


;;========== lsp-ui-imenu
(add-hook 'lsp-ui-imenu-mode-hook
	  '(lambda ()
	     (local-set-key (kbd "n") 'next-line)
	     (local-set-key (kbd "p") 'previous-line)))

;;=========== toggle document tip
(defun toggle-show-doc ()
  "toggle if show the java doc"
  (interactive)
  (if (not lsp-ui-doc-enable)
      (progn
	(custom-set-variables
	 '(lsp-ui-doc-enable t)
	 '(lsp-ui-doc-max-height 20)
	 '(lsp-ui-doc-max-width 80)
	 '(lsp-ui-doc-position (quote at-point))
	 '(lsp-ui-imenu-enable t)
	 '(lsp-ui-peek-enable t)
	 '(lsp-ui-sideline-enable t))
	(lsp-ui-doc-mode t)
	(lsp-ui-sideline-mode t))
    (progn
      (custom-set-variables
       '(lsp-ui-doc-enable nil)
       '(lsp-ui-doc-max-height 20)
       '(lsp-ui-doc-max-width 80)
       '(lsp-ui-doc-position (quote at-point))
       '(lsp-ui-imenu-enable nil)
       '(lsp-ui-peek-enable nil)
       '(lsp-ui-sideline-enable nil))
      (lsp-ui-doc-mode -1)
      (lsp-ui-sideline-mode -1))
    ))

;;=============== pseudo terminal (pty) ==============
;; (with-temp-buffer
  ;; (make-process :name "gradle" :command '( nil "gradle" "--help") :buffer "*Gradle Run*"))

(defun run-gradlew-with-string ()
  (interactive)
  (let (args))
    (setq args (read-string "Your gradlew args: "))
    (gradlew args))
