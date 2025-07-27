;; -*- coding: utf-8; -*-


(defun my/window-list-visible-frames ()
  (apply #'append (mapcar (lambda (frame) (window-list frame)) (visible-frame-list))))

(use-package ace-window
  :init
  (setq aw-scope 'global)

  (defun my/ace-window (&optional arg)
    "fix ace-window error which need manually select window when only two window exits at terminal"
    (interactive "P")
    (if my/doom-p
        (call-interactively #'ace-window)
      (if (<= (length (my/window-list-visible-frames)) 3)
	  (if (equal (length (visible-frame-list)) 1)
	      (call-interactively #'other-window)
	    (call-interactively #'ace-window))

        (call-interactively #'ace-window)))
    )
  :commands (ace-window)
  :bind (("M-o" . my/ace-window)  ; 1) C-u M-o swap 2) C-u C-u M-o delete
         ("M-O" . ace-swap-window)
         ("M-D" . ace-delete-window))
  :config
  ;;=== window labels
  ;; default is 0 1 ... 9
  (setq aw-keys '(?a ?s ?d ?f ?g ?h ?k ?l))

  (setq aw-background nil)

  (defvar aw-dispatch-alist
    '((?x aw-delete-window "Delete Window")
      (?m aw-swap-window "Swap Windows")
      (?M aw-move-window "Move Window")
      (?c aw-copy-window "Copy Window")
      (?j aw-switch-buffer-in-window "Select Buffer")
      (?n aw-flip-window)
      (?u aw-switch-buffer-other-window "Switch Buffer Other Window")
      (?c aw-split-window-fair "Split Fair Window")
      (?v aw-split-window-vert "Split Vert Window")
      (?b aw-split-window-horz "Split Horz Window")
      (?o delete-other-windows "Delete Other Windows")
      (?? aw-show-dispatch-help))
    "List of actions for `aw-dispatch-default'.")

  (custom-set-faces
   '(aw-leading-char-face ((t (:foreground "white" :background "red"
                               :weight bold :height 2.0 :box (:line-width 5 :color "red")))))))

;; (global-unset-key (kbd "M-o"))
;; (global-set-key (kbd "M-o") 'ace-window)

(provide 'init-ace-window)
