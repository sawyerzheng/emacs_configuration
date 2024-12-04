(provide 'init-tab)

;; (use-package centaur-tabs
;;   :straight (:type git :host github :repo "ema2159/centaur-tabs")
;;   :commands (centaur-tabs-mode
;;              centaur-tabs-forward
;;              centaur-tabs-backward)
;;   )

(my/straight-if-use '(sort-tab :type git :host github :repo "manateelazycat/sort-tab"))
(use-package sort-tab
  :commands (sort-tab-mode)
  :config
  ;; (sort-tab-mode +1)
  ;; * for ace-window ingore
  (add-to-list 'aw-ignored-buffers sort-tab-buffer-name)
  )

(defun my/enable-tab-mode ()
  (interactive)
  (unless sort-tab-mode
    (sort-tab-mode 1))
  ;; (if (featurep 'eaf)
  ;;     (progn (global-set-key (kbd "C-<tab>") #'eaf-goto-right-tab)
  ;;            (global-set-key (kbd "C-<iso-lefttab>") #'eaf-goto-left-tab))

  ;;   (global-set-key (kbd "C-<tab>") #'sort-tab-select-next-tab)
  ;;   (global-set-key (kbd "C-<iso-lefttab>") #'sort-tab-select-prev-tab))
  (global-set-key (kbd "C-<tab>") #'sort-tab-select-next-tab)
  (global-set-key (kbd "C-<iso-lefttab>") #'sort-tab-select-prev-tab))

(add-hook 'eaf-mode-hook #'my/enable-tab-mode)
