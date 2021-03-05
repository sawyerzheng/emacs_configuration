;; -*- coding: utf-8; -*-
(use-package powershell
  :ensure t)

;; 在windows下使用 \ 表示路径
;; (defun win-file-name-completion-advice (res)
;;   (if (stringp res) (replace-regexp-in-string "/" "\\\\" res) res))


;; (defun win-command-completion-advice ()
;;   (let ((filename (comint-match-partial-filename)))
;;     (and filename (not (string-match "\\\\" filename)))))


;; (defun win-path-backslash-stype ()
;;   (advice-add 'comint-completion-file-name-table
;;               :filter-return #'win-file-name-completion-advice)
;;   (advice-add 'shell-command-completion
;;               :before-while #'win-command-completion-advice)
;;   )

;; 仍然不能杜绝 对eshell 产生的副作用, 会导致eshell 不能正常补全file path
;; 解决方法只有重启emacs
;; (add-hook 'shell-mode-hook
;;           'win-path-backslash-stype)
