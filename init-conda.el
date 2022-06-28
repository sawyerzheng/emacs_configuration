;; -*- coding: utf-8; -*-
;; activate after `python-mode'
;; (use-package python
;;   :commands (python-mode)
;;   :config
;;   (require 'conda))

;; activate after `consult-recent-file'
;; (use-package consult
;;   :commands (consult-recent-file)
;;   :config
;;   (require 'conda))

;; activate after `find-file'
;; (use-package files
;;   :commands (find-file)
;;   :config
;;   (require 'conda))


(use-package conda
  :straight t  
  ;; :hook (after-init . conda-env-autoactivate-mode)
  :commands (conda-env-list conda-env-activate conda-env-deactivate)
  :config
  (setq conda-message-on-environment-switch t)
  (if (eq system-type 'windows-nt)
      (setq conda-env-home-directory "d:/soft/miniconda3/"
	    conda-anaconda-home "d:/soft/miniconda3")
    (setq conda-env-home-directory "~/miniconda3"
	  conda-anaconda-home "~/miniconda3"))

  ;; 只有通过 `projectile-switch-project' 打开文件才能正常激活环境
  ;; (conda-env-autoactivate-mode 1)
  )

(provide 'init-conda)
