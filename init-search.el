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


(defvar my/search-keymap (make-sparse-keymap)
  "keymap for search")

(let ((map my/search-keymap))
  (require 'init-consult)
  (require 'init-dictionary)
  (define-key map (kbd ";") #'blink-search)

  (define-key map (kbd "s") #'+default/search-buffer)
  (define-key map (kbd "f") '("find file path" . consult-find))
  (define-key map (kbd "p") '("find file content" . consult-ripgrep))
  (define-key map (kbd "i") #'(lambda ()
                                (interactive)
                                (cond
                                 ((eq major-mode 'org-mode)
                                  (consult-org-heading))
                                 ((or (derived-mode-p 'outline-mode)
                                      (member major-mode '(markdown-mode gfm-mode)))
                                  (consult-outline))
                                 ((derived-mode-p 'compilation-mode)
                                  (consult-compile-error))
                                 (t
                                  (consult-imenu)))))
  (define-key map (kbd "I") #'consult-imenu-multi)

  ;; * docsets or devdocs
  (define-key map (kbd "o") #'+lookup/online)
  (define-key map (kbd "d") #'devdocs-dwim)
  ;; (define-key map (kbd "d") #'my/counsel-dash-at-point)
  (define-key map (kbd "D") #'consult-dash)
  (define-key map (kbd "z") #'zeal-at-point)

  ;; * dictionary
  ;; (define-key map (kbd "y") #'my-youdao-dictionary-search-at-point)
  (define-key map (kbd "y") #'fanyi-dwim2)
  (define-key map (kbd "b") #'popweb-dict-bing-pointer)
  (define-key map (kbd "v") #'popweb-dict-bing-input)
  (define-key map (kbd "u") #'my/dictionary-overlay-mark-word-unknown)
  (define-key map (kbd "U") #'my/dictionary-overlay-mark-word-known)
  (define-key map (kbd "r") #'my/dictionary-overlay-toggle)


  ;; * char, word jump
  ;; (define-key map (kbd "j") #'ace-pinyin-jump-word)
  (define-key map (kbd "k") #'avy-goto-word-1)
  (define-key map (kbd "j") #'avy-goto-char)
  (define-key map (kbd "l") #'avy-goto-char-in-line)
  (define-key map (kbd "2") #'avy-goto-char-2)

  ;; * line jump
  (define-key map (kbd "n") #'(lambda ()
                                (interactive)
                                (cond
                                 ((memq major-mode '(compilation-mode Info-mode eww-mode))
                                  (ace-link))
                                 (t (avy-goto-line)))))
  (define-key map (kbd "q") #'+default/search-buffer)

  ;; embark
  (define-key map (kbd ".") #'embark-act)

  ;; C-g
  (define-key map (kbd "g") #'keyboard-quit)
  map)


(provide 'init-search)
