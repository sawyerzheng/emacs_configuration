;; load snippet tables  -*- coding: utf-8; -*-

(use-package yasnippet
  :ensure t)
(use-package yasnippet-snippets
  :ensure t)


(yas-reload-all)
;; add hook to every buffer , yas-minor-mode
(add-hook 'prog-mode-hook #'yas-minor-mode)


;;Select snippet using helm (anything.el)
(defun shk-yas/helm-prompt (prompt choices &optional display-fn)
  "Use helm to select a snippet. Put this into `yas-prompt-functions.'"
  (interactive)
  (setq display-fn (or display-fn 'identity))
  (if (require 'helm-config)
      (let (tmpsource cands result rmap)
	(setq cands (mapcar (lambda (x) (funcall display-fn x)) choices))
	(setq rmap (mapcar (lambda (x) (cons (funcall display-fn x) x)) choices))
	(setq tmpsource
	      (list
	       (cons 'name prompt)
	       (cons 'candidates cands)
	       '(action . (("Expand" . (lambda (selection) selection))))
	       ))
	(setq result (helm-other-buffer '(tmpsource) "*helm-select-yasnippet"))
	(if (null result)
	    (signal 'quit "user quit!")
	  (cdr (assoc result rmap))))
    nil))

;;======================= Popup menu for yas-choose-value ====================
;;; use popup menu for yas-choose-value
(require 'popup)

;; add some shotcuts in popup menu mode
(define-key popup-menu-keymap (kbd "M-n") 'popup-next)
(define-key popup-menu-keymap (kbd "TAB") 'popup-next)
(define-key popup-menu-keymap (kbd "<tab>") 'popup-next)
(define-key popup-menu-keymap (kbd "<backtab>") 'popup-previous)
(define-key popup-menu-keymap (kbd "M-p") 'popup-previous)

(defun yas-popup-isearch-prompt (prompt choices &optional display-fn)
  (when (featurep 'popup)
    (popup-menu*
     (mapcar
      (lambda (choice)
        (popup-make-item
         (or (and display-fn (funcall display-fn choice))
             choice)
         :value choice))
      choices)
     :prompt prompt
     ;; start isearch mode immediately
     :isearch t
     )))

(setq yas-prompt-functions '(yas-popup-isearch-prompt yas-ido-prompt yas-no-prompt))
;;=============================================================================
