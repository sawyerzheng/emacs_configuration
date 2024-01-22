(use-package blink-search
  :init
  ;; (setq blink-search-browser-function browse-url-browser-function)
  :straight (:type git :host github :repo "manateelazycat/blink-search" :files ("*"))
  :config
  (setq blink-search-python-command my/epc-python-command)
  (setq blink-search-quick-keys '("h" "l" "u" "y" "," "." ";" "/" "'" "r" "v" "g" "t" "c" "7" "8" "9" "0" "H" "L" "U" "I" "Y" "s" "a" "e" "q" "1" "2" "3" "4" "[" "]"))


  (add-to-list 'blink-search-common-directory
               (if my/windows-p
                   '("SOURCE" "d:/source/")
                 '("SOURCE" "/mnt/d/source/")))

  (if my/linux-p
      (add-to-list 'blink-search-common-directory
                   '("books" "~/nextcloud/books/")))
  (add-to-list 'blink-search-common-directory
               (if my/linux-p
                   '("project-miscs" "/mnt/d/project-miscs/")
                 '("project-miscs" "d:/project-miscs")))

  :bind (:map blink-search-mode-map
              ("M-j" . nil)
              ("M-i" . blink-search-candidate-group-select-prev)
              ("M-k" . blink-search-candidate-group-select-next)
              )
  :commands (blink-search))


(use-package nova
  :straight (:type git :host github :repo "manateelazycat/nova" :files ("*"))
  :config
  (setq nova-python-command my/epc-python-command))



(provide 'init-search)
