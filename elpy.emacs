;; -*- coding: utf-8-unix; -*-

(use-package elpy
  :ensure t)
;; enable elpy 
(elpy-enable)
(add-hook 'python-mode-hook 'elpy-mode)
;; Test Runner
;; (setq elpy-test-runner "py.test")
;;================= python interactive console ============
;;========= use python itself
;; (setq python-shell-interpreter "python"
;;       python-shell-interpreter-args "-i")

;;========= use jupyter console
;; https://elpy.readthedocs.io/en//latest/ide.html#interpreter-setup
;; (setq python-shell-interpreter "jupyter"
;;       python-shell-interpreter-args "console --simple-prompt"
;;       python-shell-prompt-detect-failure-warning nil)
;; (add-to-list 'python-shell-completion-native-disabled-interpreters
;;              "jupyter")

;;========= use ipython fully
(setq python-shell-interpreter "ipython"
      python-shell-interpreter-args "-i --simple-prompt")

;;----------------------------------------------------------
(defun my-elpy/switch-shell ()
  "Command to switch between python shells."
  (interactive)
  (let (choices
	select)
    (setq choices '("python" "ipython" "jupyter"))
    (setq select (ido-completing-read "python shell: " choices))
    (elpy-shell-kill-all)
    (my-elpy/set-shell select)))

(defun my-elpy/set-shell (select)
  "set python shell type"
  (if (equal select "python")
      (setq python-shell-interpreter "python"
	    python-shell-interpreter-args "-i")
    
    
    (if (equal select "ipython")
	(setq python-shell-interpreter "ipython"
	      python-shell-interpreter-args "-i --simple-prompt")
      
      (progn
	(setq python-shell-interpreter "jupyter"
	      python-shell-interpreter-args "console --simple-prompt"
	      python-shell-prompt-detect-failure-warning nil)
	(add-to-list 'python-shell-completion-native-disabled-interpreters
		     "jupyter")))))
	
;;===================== python console =========================

;; clean annoying long mode line
;;(elpy-clean-modeline)

;; use flycheck instead of flymake
;; (when (load "flycheck" t t)
;;   (setq elpy-modules (delq 'elpy-module-flymake elpy-modules))
;;   (add-hook 'elpy-mode-hook 'flycheck-mode))


;; emacs 26 flymake indicator
;; (setq elpy-remove-modeline-lighter t)

;; (advice-add 'elpy-modules-remove-modeline-lighter
;;             :around (lambda (fun &rest args)
;;                       (unless (eq (car args) 'flymake-mode)
;;                         (apply fun args))))

;;============== disable flymake and flycheck for python-mode
(defun disable-flymake()
  "for disable flymake-mode"
  (interactive)
  (flymake-mode -1)
  (flymake-mode 1)
  (flycheck-mode -1))
(add-hook 'python-mode-hook 'disable-flymake)
(add-hook 'elpy-mode-hook 'disable-flymake)
(add-hook 'python-mode-hook
	  (lambda ()
	     (auto-complete-mode -1))) ;; disable auto-complete-mode
;; ==================  Navigation =========================
;; https://elpy.readthedocs.io/en/latest/ide.html#command-elpy-goto-definition
;; jedi and company-jedi can only install one of them, they are exclusive.
;; https://stackoverflow.com/questions/24814988/emacs-disable-auto-complete-in-python-mode


;; go to definition, enhanced version
(defun elpy-goto-definition-or-rgrep ()
  "Go to the definition of the symbol at point, if found. Otherwise, run `elpy-rgrep-symbol'."
  (interactive)
  (ring-insert find-tag-marker-ring (point-marker))
  (condition-case nil (elpy-goto-definition)
    (error (elpy-rgrep-symbol
	    (concat "\\(def\\|class\\)\s" (thing-at-point 'symbol) "(")))))
;; key binding “M-.”
(define-key elpy-mode-map (kbd "M-.") 'elpy-goto-definition-or-rgrep)

;; Enable full font locking of inputs in the python shell
(advice-add 'elpy-shell--insert-and-font-lock
            :around (lambda (f string face &optional no-font-lock)
                      (if (not (eq face 'comint-highlight-input))
                          (funcall f string face no-font-lock)
                        (funcall f string face t)
                        (python-shell-font-lock-post-command-hook))))

;; (advice-add 'comint-send-input
;;             :around (lambda (f &rest args)
;;                       (if (eq major-mode 'inferior-python-mode)
;;                           (cl-letf ((g (symbol-function 'add-text-properties))
;;                                     ((symbol-function 'add-text-properties)
;;                                      (lambda (start end properties &optional object)
;;                                        (unless (eq (nth 3 properties) 'comint-highlight-input)
;;                                          (funcall g start end properties object)))))
;;                             (apply f args))
;;                         (apply f args))))

;;================== jedi 自动补全功能 ===============================
;; enable elpy jedi backend
(setq elpy-rpc-backend "jedi")

;;==================== yas， 自动扩展=================================
;; Fixing a key binding bug in elpy
(define-key yas-minor-mode-map (kbd "C-c k") 'yas-expand)

;;===================== iedit-mode ====================================
;; Fixing another key binding bug in iedit mode
;; 自动选择相同的单词
(define-key global-map (kbd "C-c o") 'iedit-mode)

;;====================== exec current buffer =============
(defun my-elpy/execute-buffer ()
  "Execute the buffer with python -m path.module.current.
If there is elpy-project-root can't be found, use xah lee's function"
  (interactive)
  (setq root (elpy-project-root))
  (setq file (buffer-file-name))
  (if (and root file)
      (my-elpy/execute-from-project-root file root)
    (progn
      (unless root
	(message "Not find project root, use elpy to set it"))
      (if root
	(message "Not valid file %s" file))))
  )

(defun my-elpy/execute-from-project-root (file root)
  "execute current file with `python -m' command"
  ;; save file
  (when (not (buffer-file-name)) (save-buffer))
  (when (buffer-modified-p) (save-buffer))
  (save-some-buffers)
  (let ((command "python -m")
	(module-name)
	newBuffName
	newBuff
	output
	program
	relative-name)
    (setq file (expand-file-name file))
    (setq root (expand-file-name root))
    (setq relative-name (file-relative-name file root))
    (setq module-name (replace-regexp-in-string "/" "." (file-name-sans-extension relative-name)))
    ;; (message "Error:")
    ;; (message  module-name)
    ;; (message file)
    ;; (message root)
    ;; (message relative-name)
    (setq newBuffName "*Run Python*")
    (setq newBuff (get-buffer-create newBuffName))


    ;; file in the project root
    ;; (if (equal (cl-search "/" module-name) nil)
    ;; 	(setq program (concat "python" " " relative-name))
    ;;   (setq program (concat command " " module-name)))

    ;; clear previous content
    (with-current-buffer newBuff
      (ignore-errors
	(compilation-mode 1)
	(read-only-mode -1))
      (local-set-key (kbd "q") 'quit-window))

    (pop-to-buffer newBuff)
    (setf (buffer-string) "")
    
    (princ (concat "-*- command: "command " " module-name " -*- " "\n\n")
	   newBuff)

    (setq program (concat command " " module-name))
    (cd root)
    (call-process "python" nil newBuff nil "-m" module-name)
    ;; (start-process "python-run-module" newBuff "python" "-m" module-name)
    (cd (file-name-directory file))
    ))

(define-key elpy-mode-map (kbd "C-c r") 'my-elpy/execute-buffer)
;;========================================================

;;=========== elpy-rpc-path
(if (equal system-type 'gnu/linux)
    (setq elpy-rpc-virtualenv-path "/home/sawyer/.virtualenvs/env36/"))
