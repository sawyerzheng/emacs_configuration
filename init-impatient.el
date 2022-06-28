;; -*- coding: utf-8; -*-
(use-package impatient-mode
  :straight t
  :after (markdown-mode)
  :bind (:map markdown-mode-command-map
              ("p" . impatient-mode))
  :config
  (setq httpd-port 18080)
  (add-hook 'impatient-mode-hook 'httpd-start)
  (add-hook 'markdown-mode-hook 'impatient-mode)

  ;; markdown filter
  (defun markdown-html (buffer)
    (princ (with-current-buffer buffer
             (format "<!DOCTYPE html><html><title>Impatient Markdown</title><xmp theme=\"united\" style=\"display:none;\"> %s  </xmp><script src=\"http://strapdownjs.com/v/0.2/strapdown.js\"></script></html>" (buffer-substring-no-properties (point-min) (point-max))))
           (current-buffer)))

  (add-hook 'markdown-mode-hook #'impatient-mode)
  (add-hook 'markdown-mode-hook #'(lambda ()
                                    (make-local-variable 'imp-user-filter)
                                    (setq-default imp-user-filter 'markdown-html)
                                    (cl-incf imp-last-state)
                                    (imp--notify-clients))))

(provide 'init-impatient)
