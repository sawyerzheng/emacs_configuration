(use-package gnus-start
  :config
  (setq gnus-init-file "~/org/private/gnus.el"))


;; 直接使用 系统安装包安装的 mu 就可以，不必手动通过 straight 安装
;; 初始化：mu init --maildir=~/mbsync --my-address user@mail.com user2@mail.com
(use-package mu4e
  :commands (mu4e)
  :config
  (when (featurep 'vertico)
    (setq mu4e-completing-read-function #'completing-read))

  (defun my/mail-update ()
    (interactive)
    (async-shell-command "mbsync qq gmail")))
;; (use-package mu4e-dashboard
;;   :straight (:type git :host github :repo "rougier/mu4e-dashboard"))

(load-file "~/org/private/sendmail-gmail.el")
;; (use-package mu4e
;;   :straight (:host github
;;                    :files ("build/mu4e/*" "*")
;;                    ;; :branch "release/1.8"
;;                    :repo "djcb/mu"
;;                    :pre-build (("meson" "build")
;;                                ("ninja" "-C" "build")))
;;   :commands (mu4e)
;;   :config
;;   ;; (setq mu4e-mu-binary (expand-file-name "../mu/mu" mu4e-builddir))
;;   )

(provide 'init-mail)
