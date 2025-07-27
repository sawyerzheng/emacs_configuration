(use-package cnfonts
  :init
  (setq-default cnfonts-personal-fontnames
		'(("Cascadia Code" "CaskaydiaCove Nerd Font" "Source Code Pro")
		  ))
  (setq cnfonts-use-system-type t)
  :commands (cnfonts-edit-profile)
  :config
  (setq cnfonts-use-face-font-rescale t)
  (push '(#x3400 . #x4DFF) cnfonts-ornaments)
  (defvar my-line-spacing-alist
    '((9 . 0.1) (10 . 0.9) (11.5 . 0.2)
      (12.5 . 0.2) (14 . 0.2) (16 . 0.2)
      (18 . 0.2) (20 . 1.0) (22 . 0.2)
      (24 . 0.2) (26 . 0.2) (28 . 0.2)
      (30 . 0.2) (32 . 0.2)))

  (defun my-line-spacing-setup (fontsizes-list)
    (let ((fontsize (car fontsizes-list))
          (line-spacing-alist (copy-list my-line-spacing-alist)))
      (dolist (list line-spacing-alist)
	(when (= fontsize (car list))
          (setq line-spacing-alist nil)
          (setq-default line-spacing (cdr list))))))

  (add-hook 'cnfonts-set-font-finish-hook #'my-line-spacing-setup)
  (defun my/enable-cnfonts ()
    (interactive)
    (with-eval-after-load 'org
      (when (and (display-graphic-p) (not (daemonp)))
        (unless (fboundp #'cnfonts-mode)
	  (require 'cnfonts))
        (cnfonts-mode 1))))

  :hook (my/startup . my/enable-cnfonts)
  )

(provide 'init-cnfonts)
