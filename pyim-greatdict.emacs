;; pyim-greatdict ---> generated from nlp  -*- coding: utf-8; -*-

;; * install latest version
;; (setq my-use-git t)
;; (if my-use-git
;;     (progn
;; (load-file "~/.conf.d/quelpa.emacs")
;; (quelpa '(pyim-greatdict :fetcher github :repo "tumashu/pyim-greatdict")))
;;   (progn
;;     (use-package pyim-greatdict
;;       :ensure t)))



(defun pyim-greatdict-enable ()
  "Add greatdict to pyim."
  (interactive)
  (let* ((file (concat "~/backup.d/pinyin_dict/pyim-greatdict.pyim" )))
    (when (file-exists-p file)
      (if (featurep 'pyim)
          (pyim-extra-dicts-add-dict
           `(:name "Greatdict-elpa"
                   :file ,file
                   :coding utf-8-unix
                   :dict-type pinyin-dict
                   :elpa t))
        (message "pyim 没有安装，pyim-greatdict 启用失败。")))))

;; (require 'pyim-greatdict)
(pyim-greatdict-enable)

