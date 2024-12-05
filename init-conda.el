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

(defcustom my/conda-project-env ""
  "the env name"
  :type 'string)

(defcustom my/conda-env-extra-home (cond (my/wsl-p "/mnt/e/soft/envs/linux-conda/envs/")
                                         (my/windows-p "/mnt/e/soft/envs/win-conda/envs/")
                                         (t ""))
  "extra conda env store path"
  :type 'directory)

(my/straight-if-use 'conda)
(use-package conda
  :init

  ;; :hook (my/startup . conda-env-autoactivate-mode)
  :commands (conda-env-list
             conda-env-activate
             conda-env-deactivate
             my/conda-activate)
  :config
  (setq conda-message-on-environment-switch t)
  (if (eq system-type 'windows-nt)
      (setq
       ;; conda-env-home-directory "d:/soft/miniconda3/"
       conda-env-home-directory "e:/soft/envs/win-conda/"
       ;; conda-anaconda-home "d:/soft/miniconda3")
       conda-anaconda-home "e:/soft/miniconda3")
    (setq conda-env-home-directory "~/miniconda3"
	  conda-anaconda-home "~/miniconda3"))

  ;; 只有通过 `projectile-switch-project' 打开文件才能正常激活环境
  ;; (conda-env-autoactivate-mode 1)
  (defun my/conda-activate (&optional prefix)
    "activate the conda env.

* search priority:

1. my/conda-project-env is a directory
2. my/conda-project-env is a env name in my/conda-env-extra-home
3. my/conda-project-env is a env name in conda-env-home-directory
4. input the conda env name manually, if my/conda-project-env is not set or not find

* with prefix

input the conda env directory manually, with my/conda-project-env as default env name candidate

"
    (interactive "P")
    (let* ((project-env my/conda-project-env)
           (project-env-is-set (and (stringp project-env) (not (string-empty-p project-env))))
           (extra-env-home (if (file-exists-p my/conda-env-extra-home)
                               my/conda-env-extra-home
                             conda-env-home-directory))
           (project-env-is-directory (and project-env-is-set (file-exists-p project-env)))
           (project-env-in-extra-env-home (and project-env-is-set (file-exists-p (expand-file-name project-env my/conda-env-extra-home))))
           (project-env-in-default-conda-env-home (and project-env-is-set (file-exists-p (expand-file-name project-env conda-env-home-directory))))
           (project-env-as-directory (cond (project-env-in-extra-env-home
                                            (expand-file-name project-env extra-env-home))
                                           (project-env-in-default-conda-env-home
                                            (expand-file-name project-env conda-env-home-directory))
                                           (t nil))))
      (if prefix
          (conda-env-activate
           (read-directory-name "conda env path: "
                                extra-env-home
                                nil
                                nil
                                (if project-env-in-extra-env-home
                                    project-env
                                  nil)))
        (message "project-env: %s" project-env)
        (cond (project-env-is-directory
               (if (my/conda-env-dir-p project-env)
                   (conda-env-activate project-env)
                 (pyvenv-activate project-env)))
              ((or project-env-in-extra-env-home project-env-in-default-conda-env-home)
               (conda-env-activate project-env-as-directory))
              (t
               (call-interactively #'conda-env-activate))))))

  )

(defun my/conda-env-dir-p (env-directory)
  (file-exists-p (expand-file-name "conda-meta" env-directory)))

;; (defun my/python-env-type (env-directory)
;;   (if (file-exists-p (expand-file-name "conda-meta" env-directory))
;;       ))

(provide 'init-conda)
