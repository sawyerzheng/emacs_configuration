(defvar my/org-roam-keymap (make-sparse-keymap))
(my/straight-if-use 'org-roam)
(my/straight-if-use 'consult-org-roam)
(use-package consult-org-roam
  :commands (consult-org-roam-mode
	     consult-org-roam-search
	     consult-org-roam-file-find
	     consult-org-roam-forward-links
	     consult-org-roam-backlinks
	     consult-org-roam-backlinks-recursive))

(use-package org-roam
  :custom
  (org-roam-directory "~/org/roam")
  :bind (("C-c n l" . org-roam-buffer-toggle)
         ("C-c n f" . org-roam-node-find)
         ("C-c n g" . org-roam-graph)
         ("C-c n i" . org-roam-node-insert)
         ("C-c n c" . org-roam-capture)
         ;; Dailies
         ("C-c n d d" . org-roam-dailies-capture-today)
         ("C-c n d D" . org-roam-dailies-goto-date)
         ("C-c n d t" . org-roam-dailies-goto-today)
         ("C-c n d y" . org-roam-dailies-goto-yesterday)
         )
  :defines (my/org-roam-keymap)
  :config
  (use-package org-roam-dailies
    :config
    (setq org-roam-dailies-capture-templates '(("d" "default" entry "* %?" :target
  (file+head "%<%Y-%m-%d>.org" "#+title: %<%Y-%m-%d>\n")))))


  ;; If you're using a vertical completion framework, you might want a more informative completion interface
  (setq org-roam-node-display-template (concat "${title:*} " (propertize "${tags:10}" 'face 'org-tag)))

  (setq org-roam-capture-templates '(("d" "default" plain "%?" :target
                                      (file+head "%<%Y%m%d%H%M%S>-${slug}.org" "${title}\n")
                                      :unnarrowed t)))
  (org-roam-db-autosync-mode)
  ;; If using org-roam-protocol
  (require 'org-roam-protocol)

  ;; (let ((map my/org-roam-keymap))
  ;;   (define-key map (kbd "l") #'org-roam-buffer-toggle)
  ;;   (define-key map (kbd "f") #'org-roam-node-find)
  ;;   (define-key map (kbd "g") #'org-roam-graph)
  ;;   (define-key map (kbd "i") #'org-roam-node-insert)
  ;;   (define-key map (kbd "c") #'org-roam-capture)
  ;;   (define-key map (kbd "j") #'org-roam-node-insert))

  :bind (:map my/org-roam-keymap
              ("l" . org-roam-buffer-toggle)
              ("f" . org-roam-node-find)
              ("g" . org-roam-graph)
              ("i" . org-roam-node-insert)
              ("c" . org-roam-capture)
              ;; Dailies
              ("j" . org-roam-dailies-capture-today)
              )
  )

(my/straight-if-use '(org-roam-ui :host github :repo "org-roam/org-roam-ui" :branch "main" :files ("*.el" "out")))

(use-package org-roam-ui
  :after org-roam
  ;;         normally we'd recommend hooking orui after org-roam, but since org-roam does not have
  ;;         a hookable mode anymore, you're advised to pick something yourself
  ;;         if you don't care about startup time, use
  ;;  :hook (my/startup . org-roam-ui-mode)
  :defines (my/org-roam-keymap)
  :config
  (setq org-roam-ui-sync-theme t
        org-roam-ui-follow t
        org-roam-ui-update-on-save t
        org-roam-ui-open-on-start t)


  ;; (define-key my/org-roam-keymap (kbd "u") #'org-roam-ui-open)
  :bind (:map my/org-roam-keymap
              ("u" . org-roam-ui-open))
  :bind ("C-c n u" . org-roam-ui-open))

(provide 'init-org-roam)
