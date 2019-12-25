;; -*- coding: utf-8; -*-
(use-package cnfonts
  :ensure t)
(require 'cnfonts)
;; 让 cnfonts 随着 Emacs 自动生效。
(cnfonts-enable)
;; 让 spacemacs mode-line 中的 Unicode 图标正确显示。
;; (cnfonts-set-spacemacs-fallback-fonts)

;; (setq cnfonts-directory "~/.conf.d/custom.d/cnfonts")
;; (setq cnfonts-profiles-directory "~/.conf.d/custom.d/cnfonts")

;; for org mode headline with different font size
(setq cnfonts-use-face-font-rescale t)
