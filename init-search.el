(my/straight-if-use '(blink-search :type git :host github :repo "manateelazycat/blink-search" :files ("*")))
(use-package blink-search
  :init
  ;; (setq blink-search-browser-function browse-url-browser-function)
  :config
  (setq blink-search-python-command my/epc-python-command)
  (setq blink-search-quick-keys '("h" "l" "u" "y" "," "." ";" "/" "'" "r" "v" "g" "t" "c" "7" "8" "9" "0" "H" "L" "U" "I" "Y" "s" "a" "e" "q" "1" "2" "3" "4" "[" "]"))

  (progn
    ;; source
    (when (file-exists-p "d:/source/")
      (add-to-list 'blink-search-common-directory '("SOURCE" "d:/source/")))
    (when (file-exists-p "/mnt/d/source/")
      (add-to-list 'blink-search-common-directory '("SOURCE" "/mnt/d/source/")))
    ;; books
    (when (file-exists-p "~/nextcloud/books/")
      (add-to-list 'blink-search-common-directory '("books" "~/nextcloud/books/")))
    ;; project-miscs
    (when (file-exists-p "/mnt/d/project-miscs/")
      (add-to-list 'blink-search-common-directory '("project-miscs" "/mnt/d/project-miscs/")))
    (when (file-exists-p "d:/project-miscs/")
      (add-to-list 'blink-search-common-directory '("project-miscs" "d:/project-miscs/"))))

  :bind (:map blink-search-mode-map
              ("M-j" . nil)
              ("M-i" . blink-search-candidate-group-select-prev)
              ("M-k" . blink-search-candidate-group-select-next)
              )
  :commands (blink-search))

(my/straight-if-use 'avy)
(require 'avy-autoloads)
(use-package avy
  :commands ())
;;;###autoload
(defun my/avy-goto-word-start-2 (char1 char2 &optional arg beg end)
  "jump to word begin with two char"
  (interactive (list (let ((c1 (read-char "char 1: " t)))
                       (if (memq c1 '(? ?\b))
                           (keyboard-quit)
                         c1))
                     (let ((c2 (read-char "char 2: " t)))
                       (cond ((eq c2 ?)
                              (keyboard-quit))
                             ((memq c2 avy-del-last-char-by)
                              (keyboard-escape-quit)
                              (call-interactively 'avy-goto-char-2))
                             (t
                              c2)))
                     current-prefix-arg
                     nil nil))
  (when (eq char1 ?)
    (setq char1 ?\n))
  (when (eq char2 ?)
    (setq char2 ?\n))
  (let* ((str (format "%s%s" (string char1) (string char2)))
         (regex (cond ((string= str ".")
                       "\\.")
                      ((and avy-word-punc-regexp
                            (string-match avy-word-punc-regexp str))
                       (regexp-quote str))
                      (t
                       (concat
                        (if arg "\\_<" "\\b")
                        str)))))
    (avy-jump regex
              :window-flip arg
              :beg beg
              :end end)))

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
                                 ((or (derived-mode-p 'outline-mode 'markdown-mode))
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
  (define-key map (kbd "h") #'my/avy-goto-word-start-2)
  (define-key map (kbd "l") #'avy-goto-line)
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

  ;; web
  (define-key map (kbd "w") #'webjump)

  map)



(use-package webjump
  :ensure nil
  :commands (webjump)
  :init (setq webjump-sites
              '(;; Emacs
                ("Emacs Home Page" .
                 "www.gnu.org/software/emacs/emacs.html")
                ("Xah Emacs Site" . "ergoemacs.org/index.html")
                ("(or emacs irrelevant)" . "oremacs.com")
                ("Mastering Emacs" .
                 "https://www.masteringemacs.org/")

                ;; Search engines.
                ("DuckDuckGo" .
                 [simple-query "duckduckgo.com"
                               "duckduckgo.com/?q=" ""])
                ("Google" .
                 [simple-query "www.google.com"
                               "www.google.com/search?q=" ""])
                ("Bing" .
                 [simple-query "www.bing.com"
                               "www.bing.com/search?q=" ""])

                ("Baidu" .
                 [simple-query "www.baidu.com"
                               "www.baidu.com/s?wd=" ""])
                ("Wikipedia" .
                 [simple-query "wikipedia.org" "wikipedia.org/wiki/" ""]))))

(provide 'init-search)
