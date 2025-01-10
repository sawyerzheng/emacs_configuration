(my/straight-if-use '(tabby :type git :host github :files ("*.el" "node_scripts") :repo "alan-w-255/tabby.el"))

(use-package tabby
  :commands (tabby-mode)
  :bind (:map tabby-mode-map
              ("M-]" . tabby-accept-completion))
  ;; :hook ((python-base-mode) . tabby-mode)
  :config
  (setq tabby-idle-delay 1.5))


;; (use-package tabby-mode
;;   :straight (:type git :host github :repo "ragnard/tabby-mode")
;;   :config
;;   (setq tabby-api-url "http://172.16.10.86:17089/")
;;   )

(provide 'init-tabby)
