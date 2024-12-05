;; -*- coding: utf-8; -*-
(my/straight-if-use '(org-journal :source (melpa gpu-elpa-mirror)))
(use-package org-journal
  :init
  (with-eval-after-load 'org-agenda
    (dolist (item '(("jj" "new entry"
                     org-journal-new-entry)
                    ("js" "search"
                     org-journal-search)
                    ("jo" "open current file"
                     org-journal-open-current-journal-file)))
      (add-to-list 'org-agenda-custom-commands
                   item)))
  :config
  (setq org-journal-dir "~/org/journal/life/")
  (setq org-journal-enable-encryption t)
  (setq org-journal-file-type 'daily)
  (setq org-journal-enable-agenda-integration t))


(provide 'init-org-journal)
