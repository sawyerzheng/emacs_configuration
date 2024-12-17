(require 'init-doom-themes)
(require 'doom-themes)

;; modus-themes
(my/straight-if-use '(modus-themes :type git :host github :repo "protesilaos/modus-themes"))
(with-eval-after-load 'modus-themes
  :config
  (progn
    (setq modus-themes-headings
          '((0 . (variable-pitch 1.6))
            (1 . (variable-pitch 1.4))
            (2 . (1.3))
            (agenda-date . (1.3))
            (agenda-structure . (variable-pitch light 1.6))
            (t . (1.1))))

    (setq modus-themes-common-palette-overrides
          '((border-mode-line-active unspecified)
            (border-mode-line-inactive unspecified)
            ;; Blue background, neutral foreground, intense blue border
            ;; (bg-mode-line-active bg-blue-intense)
            (fg-mode-line-active fg-main)
            ;; (border-mode-line-active blue-intense)
            ))

    ;; (setq modus-themes-common-palette-overrides
    ;;       '())
    ;; (load-theme 'modus-vivendi t)
    ))

(my/straight-if-use 'kaolin-themes)



;; no save theme prop
(setq custom-safe-themes t)

(defvar my/selected-theme
  'doom-vibrant
  )
(setq my/selected-theme
      (if (display-graphic-p)
          'doom-vibrant
        ;; 'modus-vivendi
        ;; 'modus-vivendi-tritanopia
	'tsdh-dark
        ))


;; (defun my/selected-theme ()
;;   ;; (if (display-graphic-p)
;;   ;;     'doom-one
;;   ;;   'tsdh-dark)
;;   'doom-vibrant
;;   )
;; theme

(defun my/load-theme ()
  (interactive)
  (load-theme my/selected-theme t))

(if (daemonp)
    (add-hook 'server-after-make-frame-hook
              (lambda ()
                ;; first to load theme
                (my/load-theme)

                ;; patch for corfu in terminal
                (when (facep 'corfu-current)
                  (set-face-attribute 'corfu-current nil :background "#4c4c4c"))

                (when (facep 'acm-terminal-current-input)
                  (set-face-attribute 'acm-terminal-current-input nil :background "#4c4c4c")))


              )
  (my/load-theme))

;; (add-hook 'my/startup-hook #'my/load-theme)

;; (use-package beacon
;;   :straight t
;;   :config
;;   (beacon-mode 1))



(defun my/change-org-markdown-face (&optional frame)
  (interactive)
  (unless (featurep 'org)
    (require 'org))
  ;; org mode
  (when (and (facep 'org-level-1) my/use-head-face-scaling)
    (set-face-attribute 'org-document-title nil
                        :height 1.8)
    (set-face-attribute 'org-level-1 nil
                        :height 1.5)
    (set-face-attribute 'org-level-2 nil
                        :height 1.3)
    (set-face-attribute 'org-level-3 nil
                        :height 1.2))

  ;; ein:markdown
  (when (and (boundp 'ein:markdown-mode-map))
    (set-face-attribute 'ein:markdown-header-face-1 nil
                        :height  (face-attribute 'org-document-title :height)
                        :weight (face-attribute 'org-document-title :weight)
                        :foreground (face-attribute 'org-document-title :foreground)
                        :background (face-attribute 'org-document-title :background)
                        :overline (face-attribute 'org-document-title :overline))
    (set-face-attribute 'ein:markdown-header-face-2 nil
                        :height (face-attribute 'org-level-1 :height)
                        :weight (face-attribute 'org-level-1 :weight)
                        :foreground (face-attribute 'outline-1 :foreground)
                        :background (face-attribute 'org-level-1 :background)
                        :overline (face-attribute 'org-level-1 :overline))
    (set-face-attribute 'ein:markdown-header-face-3 nil
                        :height (face-attribute 'org-level-2 :height)
                        :weight (face-attribute 'org-level-2 :weight)
                        :foreground (face-attribute 'outline-2 :foreground)
                        :background (face-attribute 'org-level-2 :background)
                        :overline (face-attribute 'org-level-2 :overline))
    (set-face-attribute 'ein:markdown-header-face-4 nil
                        :height (face-attribute 'org-level-3 :height)
                        :weight (face-attribute 'org-level-3 :weight)
                        :foreground (face-attribute 'outline-3 :foreground)
                        :background (face-attribute 'org-level-3 :background)
                        :overline (face-attribute 'org-level-3 :overline))
    (set-face-attribute 'ein:markdown-header-face-5 nil
                        :height (face-attribute 'org-level-4 :height)
                        :weight (face-attribute 'org-level-4 :weight)
                        :foreground (face-attribute 'outline-4 :foreground)
                        :background (face-attribute 'org-level-4 :background)
                        :overline (face-attribute 'org-level-4 :overline)))
  ;; pure markdown
  (when (and (facep 'markdown-header-face-1))
    (set-face-attribute 'markdown-header-face-1 nil
                        :height (face-attribute 'org-document-title :height)
                        :weight (face-attribute 'org-document-title :weight)
                        :foreground (face-attribute 'org-document-title :foreground)
                        :background (face-attribute 'org-document-title :background)
                        :overline (face-attribute 'org-document-title :overline))
    (set-face-attribute 'markdown-header-face-2 nil
                        :height (face-attribute 'org-level-1 :height)
                        :weight (face-attribute 'org-level-1 :weight)
                        :foreground (face-attribute 'outline-1 :foreground)
                        :background (face-attribute 'org-level-1 :background)
                        :overline (face-attribute 'org-level-1 :overline))
    (set-face-attribute 'markdown-header-face-3 nil
                        :height (face-attribute 'org-level-2 :height)
                        :weight (face-attribute 'org-level-2 :weight)
                        :foreground (face-attribute 'outline-2 :foreground)
                        :background (face-attribute 'org-level-2 :background)
                        :overline (face-attribute 'org-level-2 :overline))
    (set-face-attribute 'markdown-header-face-4 nil
                        :height (face-attribute 'org-level-3 :height)
                        :weight (face-attribute 'org-level-3 :weight)
                        :foreground (face-attribute 'outline-3 :foreground)
                        :background (face-attribute 'org-level-3 :background)
                        :overline (face-attribute 'org-level-3 :overline))
    (set-face-attribute 'markdown-header-face-5 nil
                        :height (face-attribute 'org-level-4 :height)
                        :weight (face-attribute 'org-level-4 :weight)
                        :foreground (face-attribute 'outline-4 :foreground)
                        :background (face-attribute 'org-level-4 :background)
                        :overline (face-attribute 'org-level-4 :overline))))

(defun my/ein-advice-change-markdown-face (theme)
  (my/change-org-markdown-face))
(advice-add #'consult-theme :after #'my/ein-advice-change-markdown-face)

(with-eval-after-load 'org
  (my/change-org-markdown-face))
(with-eval-after-load 'markdown-mode
  (my/change-org-markdown-face))



(provide 'init-theme)
