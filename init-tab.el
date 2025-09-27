(provide 'init-tab)

;; (use-package centaur-tabs
;;   :straight (:type git :host github :repo "ema2159/centaur-tabs")
;;   :commands (centaur-tabs-mode
;;              centaur-tabs-forward
;;              centaur-tabs-backward)
;;   )

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

(use-package centaur-tabs
  :defer t
  :init
  (setq centaur-tabs-set-icons t
        centaur-tabs-gray-out-icons 'buffer
        centaur-tabs-set-bar 'left
        centaur-tabs-set-modified-marker t
        centaur-tabs-close-button "✕"
        centaur-tabs-modified-marker "•"
        centaur-tabs-icon-type 'nerd-icons
        ;; Scrolling (with the mouse wheel) past the end of the tab list
        ;; replaces the tab list with that of another Doom workspace. This
        ;; prevents that.
        centaur-tabs-cycle-scope 'tabs)

  (if (daemonp)
      (add-hook 'server-after-make-frame-hook #'centaur-tabs-mode)
    (add-hook 'my/startup-hook #'centaur-tabs-mode))

  :bind (:map centaur-tabs-mode-map
	      ("C-<tab>" . centaur-tabs-forward)
	      ("C-<iso-lefttab>" . centaur-tabs-backward)
	      ("C-`" . centaur-tabs-ace-jump))
  :config
  (defun doom-temp-buffer-p (buf)
    "Returns non-nil if BUF is temporary."
    (char-equal ?\s (aref (buffer-name buf) 0)))
  (defun my/special--buffer-p (buf)
    (char-equal ?* (aref (buffer-name buf) 0)))
  (defun +tabs-buffer-list ()
    (seq-filter (lambda (b)
                  (when (buffer-live-p b)
                    (or (eq (current-buffer) b)
                        (and (not (doom-temp-buffer-p b))
			     (not (my/special--buffer-p b))))))
                (if (bound-and-true-p persp-mode)
                    (persp-buffer-list)
                  (buffer-list))))
  (setq centaur-tabs-buffer-list-function #'+tabs-buffer-list)

  (add-hook! '(+doom-dashboard-mode-hook +popup-buffer-mode-hook)
    (defun +tabs-disable-centaur-tabs-mode-maybe-h ()
      "Disable `centaur-tabs-mode' in current buffer."
      (when (centaur-tabs-mode-on-p)
        (centaur-tabs-local-mode)))))

(add-hook 'eaf-mode-hook #'my/enable-tab-mode)
