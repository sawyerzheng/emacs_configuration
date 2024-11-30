(provide 'init-major-modes)


(my/straight-if-use 'yaml-mode)
(my/straight-if-use 'web-mode)
(my/straight-if-use 'js2-mode)
(my/straight-if-use 'lua-mode)
(use-package lua-mode
  :mode ("\\.lua\\'" . lua-mode))

(my/straight-if-use 'json-mode)
(use-package json-mode
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

(my/straight-if-use 'powershell)
(use-package powershell
  :mode (("\\.ps1\\'" . powershell-mode)))

(my/straight-if-use 'yaml-mode)
(use-package yaml-mode
  :mode (("\\.yml\\'" . yaml-mode)
         ("\\.yaml\\'" . yaml-mode)))

(my/straight-if-use 'typescript-mode)
(use-package typescript-mode
  :mode (("\\.ts\\'" . typescript-mode)))

(my/straight-if-use '(dockerfile-mode :type git :host github :repo "spotify/dockerfile-mode"))
(use-package dockerfile-mode
  :mode (("[Dd]ockerfile.*" . dockerfile-mode)))

(add-to-list 'auto-mode-alist
             '("conanfile.txt\\'" . conf-mode))
(add-to-list 'auto-mode-alist
             '("\\.service\\'" . conf-mode))
(add-to-list 'auto-mode-alist
             '(".condarc\\'" . conf-mode))
(add-to-list 'auto-mode-alist
             '("isyncrc\\'" . conf-mode))
(add-to-list 'auto-mode-alist
             '(".mbsyncrc\\'" . conf-mode))

(my/straight-if-use 'markdown-mode)
(use-package markdown-mode
  :config
  (require 'init-markdown)
  :mode (("\\.md" . gfm-mode)
	 ))
