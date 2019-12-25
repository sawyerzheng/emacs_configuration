
;;==================== Spelling -- Aspell --- Flyspell ==================
;;(if (equal system-type 'windows-nt) 
;;    (set-default 'ispell-program-name "hunspell")
;;  (set-default 'ispell-program-name "aspell")
;;(set-default 'ispell-program-name "ispell")
(set-default 'ispell-program-name "hunspell")

;;for text mode
;;(dolist (hook '(text-mode-hook))
;;  (add-hook hook (lambda () (flyspell-mode 1))))
(dolist (hook '(change-log-mode-hook log-edit-mode-hook))
        (add-hook hook (lambda () (flyspell-mode -1))))

;; for c++ mode
;; (add-hook 'c++-mode-hook
;; 	  (lambda ()
;; 	    (flyspell-prog-mode t)))
;; ;; key binding for flyspell
;; easy spell check
;;(global-set-key (kbd "<f8>") 'ispell-word)
;;(global-set-key (kbd "C-S-<f8>") 'flyspell-mode)
;;(global-set-key (kbd "C-M-<f8>") 'flyspell-buffer)
;;(global-set-key (kbd "C-<f8>") 'flyspell-check-previous-highlighted-word)
;; for gui popup
(eval-after-load "flyspell"
  '(progn
     (advice-add 'flyspell-emacs-popup :around #'flyspell-emacs-popup-choose)))
;; for terminal popup
(eval-after-load "flyspell"
  '(progn
     (fset 'flyspell-emacs-popup 'flyspell-emacs-popup-textual)))
;; skip Org mode Source code
(add-to-list 'ispell-skip-region-alist '("^#+BEGIN_SRC" . "^#+END_SRC"))


;; ================== defun for flyspell ==================
;; for key bindings
(defun flyspell-check-next-highlighted-word ()
  "Custom function to spell check next highlighted word"
  (interactive)
  (flyspell-goto-next-error)
  (ispell-word)
  )
(global-set-key (kbd "M-<f8>") 'flyspell-check-next-highlighted-word)

;; popup for terminal 
(defun flyspell-emacs-popup-textual (event poss word)
  "A textual flyspell popup menu."
  (require 'popup)
  (let* ((corrects (if flyspell-sort-corrections
		       (sort (car (cdr (cdr poss))) 'string<)
		     (car (cdr (cdr poss)))))
	 (cor-menu (if (consp corrects)
		       (mapcar (lambda (correct)
				 (list correct correct))
			       corrects)
		     '()))
	 (affix (car (cdr (cdr (cdr poss)))))
	 show-affix-info
	 (base-menu  (let ((save (if (and (consp affix) show-affix-info)
				     (list
				      (list (concat "Save affix: " (car affix))
					    'save)
				      '("Accept (session)" session)
				      '("Accept (buffer)" buffer))
				   '(("Save word" save)
				     ("Accept (session)" session)
				     ("Accept (buffer)" buffer)))))
		       (if (consp cor-menu)
			   (append cor-menu (cons "" save))
			 save)))
	 (menu (mapcar
		(lambda (arg) (if (consp arg) (car arg) arg))
		base-menu)))
    (cadr (assoc (popup-menu* menu :scroll-bar t) base-menu))))
;; for gui popup
(defun flyspell-emacs-popup-choose (org-fun event poss word)
  (if (window-system)
      (funcall org-fun event poss word)
    (flyspell-emacs-popup-textual event poss word)))
