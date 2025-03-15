;; -*- coding: utf-8; -*-
;; (use-package elfeed
;;   :straight t
;;   :commands (elfeed elfeed-update elfeed-update-feed elfeed-dashboard)
;;   :config
;;   ;; (setq elfeed-feeds
;;   ;;       '(("http://nullprogram.com/feed/" blog emacs)
;;   ;;         ("https://planet.emacslife.com/atom.xml" emacs)
;;   ;;         ("http://planetpython.org/rss20.xml" python)
;;   ;;         ("http://planet.scipy.org/rss20.xml" python)))
;;   (use-package elfeed-org
;;     :straight t
;;     :config
;;     (setq rmh-elfeed-org-files '("~/org/elfeed.org"))
;;     (elfeed-org))
;;   (use-package elfeed-goodies
;;     :straight t
;;     :config
;;     (elfeed-goodies/setup))
;;   ;; (use-package elfeed-dashboard
;;   ;;   :straight t
;;   ;;   :config
;;   ;;   (setq elfeed-dashboard-file "~/.conf.d/elfeed-dashboard.org")
;;   ;;   (advice-add 'elfeed-search-quit-window :after #'elfeed-dashboard-update-links))
;;   )

(my/straight-if-use 'elfeed)
(my/straight-if-use 'elfeed-org)
(use-package elfeed
  :config
  (use-package elfeed-org
    :config
    (setq rmh-elfeed-org-files '("~/org/elfeed.org"))
    (elfeed-org))

  ;; (use-package elfeed-dashboard
  ;;   :straight t
  ;;   :config
  ;;   (setq elfeed-dashboard-file "~/.conf.d/elfeed-dashboard.org")
  ;;   (advice-add 'elfeed-search-quit-window :after #'elfeed-dashboard-update-links))

  :pretty-hydra
  ((:title (pretty-hydra-title "Elfeed" 'devicon "nf-fa-rss_square" :face 'nerd-icons-orange)
           :color amaranth :quit-key ("q" "C-g"))
   ("Search"
    (("c" elfeed-db-compact "compact db")
     ("g" elfeed-search-update--force "refresh")
     ("G" elfeed-search-fetch "update")
     ("y" elfeed-search-yank "copy URL")
     ("+" elfeed-search-tag-all "tag all")
     ("-" elfeed-search-untag-all "untag all"))
    "Filter"
    (("l" elfeed-search-live-filter "live filter")
     ("s" elfeed-search-set-filter "set filter")
     ("*" (elfeed-search-set-filter "@6-months-ago +star") "starred")
     ("a" (elfeed-search-set-filter "@6-months-ago") "all")
     ("t" (elfeed-search-set-filter "@1-day-ago") "today"))
    "Article"
    (("b" elfeed-search-browse-url "browse")
     ("n" next-line "next")
     ("p" previous-line "previous")
     ("u" elfeed-search-tag-all-unread "mark unread")
     ("r" elfeed-search-untag-all-unread "mark read")
     ("RET" elfeed-search-show-entry "show")
     ("<escape>" nil "quit hydra" :exit t))
    "Browse"
    (("j" my/elfeed-browse-next "browse next")
     ("k" my/elfeed-browse-previous "browse previous"))))
  :bind (("C-x w" . elfeed)
         :map elfeed-search-mode-map
         ("?" . elfeed-hydra/body)
         :map elfeed-show-mode-map
         ("q" . delete-window)
	 ("v" . recenter-top-bottom))
  :hook (elfeed-show-mode . centaur-read-mode)
  :init (setq url-queue-timeout 30
              elfeed-db-directory (locate-user-emacs-file ".elfeed")
              elfeed-show-entry-switch #'pop-to-buffer
              elfeed-show-entry-delete #'delete-window
              elfeed-feeds '(("https://planet.emacslife.com/atom.xml" planet emacslife)
                             ("http://www.masteringemacs.org/feed/" mastering)
                             ("https://oremacs.com/atom.xml" oremacs)
                             ("https://pinecast.com/feed/emacscast" emacscast)
                             ("https://emacstil.com/feed.xml" Emacs TIL)
                             ;; ("https://www.reddit.com/r/emacs.rss" reddit)
                             ))
  :config
  ;; Ignore db directory in recentf
  (push elfeed-db-directory recentf-exclude)

  ;; Add icons via tags
  (when (icons-displayable-p)
    (defun nerd-icon-for-tags (tags)
      "Generate Nerd Font icon based on tags.
  Returns default if no match."
      (cond ((member "youtube" tags) (nerd-icons-faicon "nf-fa-youtube_play" :face '(:foreground "#FF0200")))
            ((member "instagram" tags) (nerd-icons-faicon "nf-fa-instagram" :face '(:foreground "#FF00B9")))
            ((or (member "emacs" tags) (member "emacslife" tags) (member "mastering" tags))
             (nerd-icons-sucicon "nf-custom-emacs" :face '(:foreground "#9A5BBE")))
            ((member "github" tags) (nerd-icons-faicon "nf-fa-github"))
            (t (nerd-icons-faicon "nf-fae-feedly" :face '(:foreground "#2AB24C")))))

    (defun lucius/elfeed-search-print-entry--better-default (entry)
      "Print ENTRY to the buffer."
      (let* ((date (elfeed-search-format-date (elfeed-entry-date entry)))
             (date-width (car (cdr elfeed-search-date-format)))
             (title (concat (or (elfeed-meta entry :title)
                                (elfeed-entry-title entry) "")
                            ;; NOTE: insert " " for overlay to swallow
                            " "))
             (title-faces (elfeed-search--faces (elfeed-entry-tags entry)))
             (feed (elfeed-entry-feed entry))
             (feed-title (when feed (or (elfeed-meta feed :title) (elfeed-feed-title feed))))
             (tags (mapcar #'symbol-name (elfeed-entry-tags entry)))
             (tags-str (mapconcat (lambda (s) (propertize s 'face 'elfeed-search-tag-face)) tags ","))
             (title-width (- (frame-width)
                             ;; (window-width (get-buffer-window (elfeed-search-buffer) t))
                             date-width elfeed-search-trailing-width))
             (title-column (elfeed-format-column
                            title (elfeed-clamp
                                   elfeed-search-title-min-width
                                   title-width
                                   elfeed-search-title-max-width) :left))

             ;; Title/Feed ALIGNMENT
             (align-to-feed-pixel (+ date-width
                                     (max elfeed-search-title-min-width
                                          (min title-width elfeed-search-title-max-width)))))
        (insert (propertize date 'face 'elfeed-search-date-face) " ")
        (insert (propertize title-column 'face title-faces 'kbd-help title))
        (put-text-property (1- (point)) (point) 'display `(space :align-to ,align-to-feed-pixel))
        ;; (when feed-title (insert " " (propertize feed-title 'face 'elfeed-search-feed-face) " "))
        (when feed-title
          (insert " " (concat (nerd-icon-for-tags tags) " ")
                  (propertize feed-title 'face 'elfeed-search-feed-face) " "))
        (when tags (insert "(" tags-str ")"))))

    (setq elfeed-search-print-entry-function #'lucius/elfeed-search-print-entry--better-default))

  ;; Use xwidget if possible
  (with-no-warnings
    (defun my-elfeed-show-visit (&optional use-generic-p)
      "Visit the current entry in your browser using `browse-url'.
If there is a prefix argument, visit the current entry in the
browser defined by `browse-url-generic-program'."
      (interactive "P")
      (let ((link (elfeed-entry-link elfeed-show-entry)))
        (when link
          (message "Sent to browser: %s" link)
          (if use-generic-p
              (browse-url-generic link)
            ;; (centaur-browse-url link)
            (browse-url-browser-function link)))))
    (advice-add #'elfeed-show-visit :override #'my-elfeed-show-visit)

    (defun my-elfeed-search-browse-url (&optional use-generic-p)
      "Visit the current entry in your browser using `browse-url'.
If there is a prefix argument, visit the current entry in the
browser defined by `browse-url-generic-program'."
      (interactive "P")
      (let ((entries (elfeed-search-selected)))
        (cl-loop for entry in entries
                 do (elfeed-untag entry 'unread)
                 when (elfeed-entry-link entry)
                 do (if use-generic-p
                        (browse-url-generic it)
                      ;; (centaur-browse-url it)
                      (browse-url-browser-function it)))
        (mapc #'elfeed-search-update-entry entries)
        (unless (or elfeed-search-remain-on-entry (use-region-p))
          (forward-line))))
    (advice-add #'elfeed-search-browse-url :override #'my-elfeed-search-browse-url))

  (defun my/elfeed-show-entry-advice-fn (&rest args)
    "make sure the *elfeed-entry* buffer will display at front"
    (unless (my/buffer-displayed-in-frame-p "*elfeed-entry*")
      (switch-to-buffer-other-window "*elfeed-entry*")))
  (advice-add #'elfeed-show-entry :after #'my/elfeed-show-entry-advice-fn)
  )

(my/straight-if-use 'elfeed-goodies)
(use-package elfeed-goodies
  :after elfeed
  :commands (elfeed-goodies/split-show-next
             elfeed-goodies/split-show-previous)
  :config
  (elfeed-goodies/setup))

;; Another Atom/RSS reader
(use-package newsticker
  :ensure nil
  :bind ("C-x W" . newsticker-show-news)
  :hook (newsticker-treeview-item-mode . centaur-read-mode)
  :init (setq newsticker-url-list
              '(("Planet Emacslife" "https://planet.emacslife.com/atom.xml")
                ("Mastering Emacs" "http://www.masteringemacs.org/feed/")
                ("Oremacs" "https://oremacs.com/atom.xml")
                ("EmacsCast" "https://pinecast.com/feed/emacscast")
                ("Emacs TIL" "https://emacstil.com/feed.xml")
                ;; ("Emacs Reddit" "https://www.reddit.com/r/emacs.rss")
                )))

(when (featurep 'xwidget-internal)
  (my/straight-if-use '(elfeed-webkit :type git :host github :repo "fritzgrabo/elfeed-webkit")))
(use-package elfeed-webkit
  :if (featurep 'xwidget-internal)
  :after elfeed
  :demand ;; !
  :init
  (setq elfeed-webkit-auto-enable-tags '(webkit comics))
  ;; :hook (elfeed-show-mode . my/elfeed-webkit-dark-mode)
  :commands (my/elfeed-webkit-dark-mode)
  :config
  (define-minor-mode my/elfeed-webkit-dark-mode
    "Minor Mode for xwidget dark mode"
    :init-value nil
    :group elfeed-webkit
    (progn
      (if my/elfeed-webkit-dark-mode
          (add-hook 'elfeed-show-mode-hook #'my/xwidget--dark-mode-with-delay)
        (remove-hook 'elfeed-show-mode-hook #'my/xwidget--dark-mode-with-delay))
      (when elfeed-show-entry
        (elfeed-show-refresh)))
    )

  (elfeed-webkit-auto-toggle-by-tag)

  (defun my/elfeed-webkit-toggle ()
    "Toggle rendering of elfeed entries with webkit on/off."
    (interactive)

    (if (elfeed-webkit--enabled-p)
        (progn
          (centaur-read-mode 1)
          (add-hook 'elfeed-show-mode-hook #'centaur-read-mode)
          ;; (remove-hook 'elfeed-show-mode-hook #'my/xwidget--dark-mode-with-delay)
          (elfeed-webkit-disable)
          (fundamental-mode)
          (elfeed-show-mode))
      (centaur-read-mode -1)
      (remove-hook 'elfeed-show-mode-hook #'centaur-read-mode)
      ;; (add-hook 'elfeed-show-mode-hook #'my/xwidget--dark-mode-with-delay)

      (ignore-errors
        (elfeed-webkit--enable)
        (when elfeed-show-entry
          (elfeed-show-refresh)))))

  :bind (:map elfeed-show-mode-map

              ("%" . my/elfeed-webkit-toggle)))

(defun my/elfeed-browse-next ()
  "use browser to view next entry in the *elfeed-search* buffer"
  (interactive)
  (unless (get-buffer "*elfeed-search*")
    (elfeed))
  (with-current-buffer (elfeed-search-buffer)
    (forward-line)
    (call-interactively #'elfeed-search-browse-url)))

(defun my/elfeed-browse-previous ()
  "use browser to view next entry in the *elfeed-search* buffer"
  (interactive)
  (unless (get-buffer "*elfeed-search*")
    (elfeed))
  (with-current-buffer (elfeed-search-buffer)
    (previous-line)
    (call-interactively #'elfeed-search-browse-url)))

(define-key global-map (kbd "C-c l w") '("elfeed keymap" . nil))
;; (define-key global-map (kbd "C-c l w") nil)
(define-key global-map (kbd "C-c l w w") #'elfeed)
(define-key global-map (kbd "C-c l w h") #'elfeed-hydra/body)
(define-key global-map (kbd "C-c l w n") #'my/elfeed-browse-next)
(define-key global-map (kbd "C-c l w p") #'my/elfeed-browse-previous)
(define-key global-map (kbd "C-c l w j") #'elfeed-goodies/split-show-next)
(define-key global-map (kbd "C-c l w k") #'elfeed-googies/split-show-prev)


(global-set-key (kbd "<f6>") #'elfeed-hydra/body)
(provide 'init-elfeed)
