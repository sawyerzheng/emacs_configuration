(use-package hackernews
  :straight t
  :commands (hackernews
             hackernews-reload
             hackernews-next-item
             hackernews-first-item
             hackernews-ask-stories
             hackernews-job-stories
             hackernews-new-stories
             hackernews-switch-feed
             hackernews-top-stories
             hackernews-best-stories
             hackernews-next-comment
             hackernews-show-stories
             hackernews-previous-item
             hackernews-previous-comment
             hackernews-load-more-stories
             hackernews-load-visited-links
             hackernews-button-browse-internal
             hackernews-button-mark-as-visited
             hackernews-button-mark-as-unvisited))

;; another hacker news client, without need web browser
(use-package hnreader
  :straight t
  :commands (hnreader-ask
             hnreader-back
             hnreader-best
             hnreader-jobs
             hnreader-more
             hnreader-news
             hnreader-past
             hnreader-show
             hnreader-newest
             hnreader-comment
             hnreader-read-page
             hnreader-read-page-back
             hnreader-org-insert-hn-link))


(provide 'init-news)
