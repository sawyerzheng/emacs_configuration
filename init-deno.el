(provide 'init-deno)

(use-package websocket
  :straight t)

(use-package deno-bridge
  :straight (:type git :host github :repo "manateelazycat/deno-bridge")
  :defer t)

(use-package insert-translated-name
  :straight (:type git :host github :repo "manateelazycat/insert-translated-name")
  :defer t
  :commands (insert-translated-name-insert
             ))


;; (use-package deno-bridge-jieba
;;   :straight (:type git :host github :repo "ginqi7/deno-bridge-jieba")
;;   :requires deno-bridge
;;   :demand t
;;   )
