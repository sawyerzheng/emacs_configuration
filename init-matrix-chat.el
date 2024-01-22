(use-package ement
  :straight (:type git :host github :repo "alphapapa/ement.el")
  :commands (ement-connect))

(use-package plz
  :straight (:type git :host github :repo "alphapapa/plz.el")
  :commands (plz)
  :config
  (cl-pushnew "--http1.1" plz-curl-default-args :test #'equal)
  )

;; (make-directory-autoloads "~/org/private/" "my-private-autoloads")

;; (use-package matrix-connect
;;   :straight (:type git :host github :repo "alphapapa/matrix-client.el")
;;   :init
;;   (use-package anaphora
;;     :straight t)
;;   (use-package ov
;;     :straight t)
;;   (use-package tracking
;;     :straight t)
;;   (use-package a
;;     :straight t)
;;   (use-package rainbow-identifiers
;;     :straight t)
;;   (use-package dash-functional
;;     :straight t)
;;   )
;; (use-package quelpa
;;   :straight t)
;; (use-package quelpa-use-package
;;   :straight t)
;; (use-package matrix-client
;;   :quelpa (matrix-client :fetcher github :repo "alphapapa/matrix-client.el"
;;                          :files (:defaults "logo.png" "matrix-client-standalone.el.sh")))

(provide 'init-matrix-chat)
