(provide 'init-eshell)

;; problem: 1. too slow in git directory
;; (use-package aweshell
;;   :if (not my/windows-p)
;;   :hook (eshell-mode . aweshell-toggle)
;;   :straight (aweshell :type git :host github :repo "manateelazycat/aweshell")
;;   :config
;;   (use-package company-mode
;;     :straight t))



(use-package eshell-git-prompt
  :straight (:type git :host github :repo "xuchunyang/eshell-git-prompt")
  )

(use-package esh-autosuggest
  :straight (:source (melpa gpu-elpa-mirror))
  :hook (eshell-mode . esh-autosuggest-mode)
  ;; If you have use-package-hook-name-suffix set to nil, uncomment and use the
  ;; line below instead:
  ;; :hook (eshell-mode-hook . esh-autosuggest-mode)
  :ensure t)
