;; -*- coding: utf-8; -*-
(my/straight-if-use '(doom-themes :files ("*.el" "extensions")))
(with-eval-after-load 'doom-themes
  ;; Global settings (defaults)
  (setq doom-themes-enable-bold t ; if nil, bold is universally disabled
	doom-themes-enable-italic t) ; if nil, italics is universally disabled
  ;; (load-theme 'doom-one t)

  ;; Enable flashing mode-line on errors
  (require 'doom-themes-ext-visual-bell)
  (doom-themes-visual-bell-config)

  ;; Enable custom neotree theme (all-the-icons must be installed!)
  ;; (doom-themes-neotree-config)
  ;; or for treemacs users
  (setq doom-themes-treemacs-theme "doom-colors") ; use the colorful treemacs theme
  (require 'doom-themes-ext-treemacs)
  (doom-themes-treemacs-config)

  ;; Corrects (and improves) org-mode's native fontification.
  (require 'doom-themes-ext-org)
  (doom-themes-org-config))

(provide 'init-doom-themes)
