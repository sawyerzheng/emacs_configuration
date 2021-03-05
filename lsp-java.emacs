;; -*- coding: utf-8-unix; -*-
(require 'cc-mode)

(load-file "~/.conf.d/lsp.emacs")
(use-package lsp-java
  :ensure t
  :after lsp
  )
(add-hook 'java-mode-hook 'lsp)

;; (use-package lsp-mode
;;   :hook (XXX-mode . lsp)
;;   :commands lsp)


;; helm-lsp-workspace-symbol
;; help-lsp-global-workspace-symbol
(use-package helm-lsp
  :ensure t
  :commands helm-lsp-workspace-symbol)



;;===== sts4,  Spring Tools 4 ===============
;; (require 'lsp-java-boot)
;; (add-hook 'java-mode-hook #'lsp-java-boot-lens-mode)
;; living application info hovers
;; (add-hook 'java-mode-hook #'lsp-java-boot-lens-mode)


;; to enable the lenses
(add-hook 'lsp-mode-hook #'lsp-lens-mode)



;; inhibit annoying debug notices
(setq lsp-inhibit-message t)

;; ========= document ====================
;; (add-hook 'java-mode-hook '(lambda ()
;; 			    (if lsp-ui-doc-enable
;; 				(progn
;; 				  (lsp-ui-doc-mode t)
;; 				  ))))
			    
;;=========== indentation ================
(add-hook 'java-mode-hook (lambda ()
                            (setq c-basic-offset 4
                                  tab-width 4
                                  indent-tabs-mode t)))

;; (add-hook 'lsp-mode-hook (lambda ()
;;                             (setq c-basic-offset 4
;;                                   tab-width 4
;;                                   indent-tabs-mode t)))

;;=== flycheck
(add-hook 'java-mode-hook '(lambda ()
		       (flycheck-mode 1)))


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
_v_: toggle-show-slideline
nnn"
  ("c" meghanada-compile-file)
  ("b" lsp-java-build-project)


  ("e" meghanada-exec-main)
  ;; ("r" (lambda () (interactive)(gradlew "run")))
  ("r" gradlew)
  ("d" lsp-treemacs-java-deps-list)

  ("m" toggle-show-doc)
  ("v" toggle-show-slideline)
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



;;=============== pseudo terminal (pty) ==============
;; (with-temp-buffer
  ;; (make-process :name "gradle" :command '( nil "gradle" "--help") :buffer "*Gradle Run*"))

(defun run-gradlew-with-string ()
  (interactive)
  (let (args))
    (setq args (read-string "Your gradlew args: "))
    (gradlew args))

;;================= debug , dap ============================
;; (use-package dap-LANGUAGE) to load the dap adapter for your language
(use-package dap-mode
  :ensure t
  :after lsp-mode
  :config
  (dap-mode t)
  (dap-ui-mode t))
(use-package dap-java
  :after (lsp-java dap-mode))

;; (require 'dap-java)
;; (use-package dap-java :after (lsp-java))
