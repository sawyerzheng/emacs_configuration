(provide 'init-tab)

;; (use-package centaur-tabs
;;   :straight (:type git :host github :repo "ema2159/centaur-tabs")
;;   :commands (centaur-tabs-mode
;;              centaur-tabs-forward
;;              centaur-tabs-backward)
;;   )


(use-package sort-tab
  :straight (sort-tab :type git :host github :repo "manateelazycat/sort-tab")
  :commands (sort-tab-mode)
  :config
  ;; (sort-tab-mode +1)
  )
