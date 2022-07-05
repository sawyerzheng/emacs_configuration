(provide 'init-major-modes)

(straight-use-package 'cmake-mode)
(straight-use-package 'yaml-mode)
(straight-use-package 'web-mode)
(straight-use-package 'js2-mode)
(use-package lua-mode
  :straight t
  :mode ("\\.lua\\'" . lua-mode))

(use-package json-mode
  :straight t
  :commands (json-mode json-to-single-line)
  :mode (("\\(?:\\(?:\\.\\(?:b\\(?:\\(?:abel\\|ower\\)rc\\)\\|json\\(?:ld\\)?\\)\\|composer\\.lock\\)\\'\\)" . json-mode)
         ("\\.jsonc\\'" . jsonc-mode))
  :config
  ;; ref: https://stackoverflow.com/a/39864915
  (defun json-to-single-line (beg end)
    "Collapse prettified json in region between BEG and END to a single line"
    (interactive "r")
    (if (use-region-p)
        (save-excursion
          (save-restriction
            (narrow-to-region beg end)
            (goto-char (point-min))
            (while (re-search-forward "\\s-+" nil t)
              (replace-match " "))))
      (print "This function operates on a region"))))

(use-package jam-mode
  :mode (("\\.jam\\'" . jam-mode)
          ("[Jj]amfile\\'" . jam-mode)))

(use-package powershell
  :straight t
  :mode (("\\.ps1\\'" . powershell-mode)))

(use-package yaml-mode
  :straight t
  :mode (("\\.yml\\'" . yaml-mode)
         ("\\.yaml\\'" . yaml-mode)))
