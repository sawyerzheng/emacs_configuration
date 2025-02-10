(provide 'init-regexp)

(my/straight-if-use 'visual-regexp)
(use-package visual-regexp
  :defer t)
(my/straight-if-use 'visual-regexp-steroids)
(use-package visual-regexp-steroids
  :init
  (setq vr/engine 'python)
  :commands (vr/mc-mark
             vr/replace
             vr/query-replace
             vr/isearch-forward
             vr/isearch-backward
             vr/select-replace
             vr/select-query-replace
             vr/select-mc-mark)
  :bind (([remap query-replace] . vr/query-replace))
  :bind (("C-s" . vr/isearch-forward)
         ("C-r" . vr/isearch-backward))
  :bind (:map xah-fly-command-map
              ;; ("n" . vr/isearch-forward)
              )
  :config
  ;; set default python engine flags
  (setq vr/default-regexp-modifiers '(:I t :M t :S nil :U nil))
  (setq vr/command-python (format "%s %s"
                                  (cond
                                   (my/linux-p
				    (if (file-exists-p "/usr/bin/python")
					"/usr/bin/python"
				      "/usr/bin/python3")
				    )
                                   (my/windows-p "d:/soft/miniconda3/python.exe")
                                   (t "python"))
                                  (expand-file-name "../regexp.py" (locate-library "visual-regexp-steroids")))))

;;;###autoload
(defun my/vr-change-engine ()
  (interactive)
  (setq vr/engine (intern (completing-read "choices:" '(emacs python pcre2el)))))

(with-eval-after-load 'visual-regexp
  (require 'visual-regexp-steroids))
