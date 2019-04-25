;; enable elpy
(elpy-enable)

;; use ipython
;;https://elpy.readthedocs.io/en//latest/ide.html#interpreter-setup
(setq python-shell-interpreter "ipython"
      python-shell-interpreter-args "-i --simple-prompt")

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
  (flycheck-mode -1))
(add-hook 'python-mode-hook 'disable-flymake)
(add-hook 'elpy-mode-hook 'disable-flymake)

;; ==================  Navigation =========================
;; https://elpy.readthedocs.io/en/latest/ide.html#command-elpy-goto-definition

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

(advice-add 'comint-send-input
            :around (lambda (f &rest args)
                      (if (eq major-mode 'inferior-python-mode)
                          (cl-letf ((g (symbol-function 'add-text-properties))
                                    ((symbol-function 'add-text-properties)
                                     (lambda (start end properties &optional object)
                                       (unless (eq (nth 3 properties) 'comint-highlight-input)
                                         (funcall g start end properties object)))))
                            (apply f args))
                        (apply f args))))

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

