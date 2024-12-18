;; -*- coding: utf-8; -*-
(my/straight-if-use '(org-journal :source (melpa gpu-elpa-mirror)))
(with-eval-after-load 'org-agenda
  (require 'org-journal)
  ;; add prefix description for prefix "j"
  (add-to-list 'org-agenda-custom-commands '("j" . "org journal"))
  (dolist (item '(("jj" "new entry"
                   org-journal-new-entry)
                  ("js" "search"
                   org-journal-search)
                  ("jo" "open current file"
                   (lambda (&rest args) (interactive) (org-journal-open-current-journal-file)))))
    (add-to-list 'org-agenda-custom-commands
                 item)))

(use-package org-journal
  :commands (org-journal-new-entry
	     org-journal-search
	     org-journal-open-current-journal-file)
  :config
  (setq org-journal-dir "~/org/journal/life/")
  (setq org-journal-enable-encryption nil)
  (setq org-journal-file-type 'daily)
  (setq org-journal-enable-agenda-integration t)
  (setq org-journal-file-format "%Y%m%d.org")
  :bind (("C-c n j j" . org-journal-new-entry)
	 ("C-c n j s" . org-journal-search-entry)
	 ("C-c n j o" . org-journal-open-current-journal-file)
	 ("C-c n j a" . org-journal-new-scheduled-entry)
	  ))

(with-eval-after-load 'calendar
  (progn
    (define-key calendar-mode-map (kbd "J") '("org journal prefix" . nil))
    (define-key calendar-mode-map (kbd "J m") 'org-journal-mark-entries)
    (define-key calendar-mode-map (kbd "J r") 'org-journal-read-entry)
    (define-key calendar-mode-map (kbd "J d") 'org-journal-display-entry)
    (define-key calendar-mode-map "]" 'org-journal-next-entry)
    (define-key calendar-mode-map "[" 'org-journal-previous-entry)
    (define-key calendar-mode-map (kbd "J n") 'org-journal-new-date-entry)
    (define-key calendar-mode-map (kbd "J s f") 'org-journal-search-forever)
    (define-key calendar-mode-map (kbd "J s F") 'org-journal-search-future)
    (define-key calendar-mode-map (kbd "J s w") 'org-journal-search-calendar-week)
    (define-key calendar-mode-map (kbd "J s m") 'org-journal-search-calendar-month)
    (define-key calendar-mode-map (kbd "J s y") 'org-journal-search-calendar-year)))



(provide 'init-org-journal)
