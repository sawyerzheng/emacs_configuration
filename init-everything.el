(use-package everything
  :if my/windows-p
  :straight (:type built-in)
  :commands (everything everything-find-file everything-toggle-case)
  :config
  (setq everything-cmd (executable-find "es.exe")))

(use-package consult-everything
  :straight (consult-everything :host github :repo "jthaman/consult-everything")
  :config
  (require 'consult-everything)
  (defun consult--everything-builder (input)
    "Build command line given INPUT."
    (pcase-let* ((cmd (split-string-and-unquote consult-everything-args))
                 (`(,arg . ,opts) (consult--command-split input))
                 (`(,re . ,hl) (funcall consult--regexp-compiler arg 'basic
                                        (and (not (member "-i" cmd))
                                             (not (member "-case" cmd))))))
      (when re
        (cons (append cmd (list (consult--join-regexps re 'orderless)) opts) hl)
        ;; (list :command
        ;;       (append cmd (list (consult--join-regexps re 'orderless)) opts)
        ;;       :highlight hl)
        ))))

(provide 'init-everything)
