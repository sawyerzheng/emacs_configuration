;; -*- coding: utf-8-unix; -*-
(use-package org
  :straight t
  :commands org-mode
  :hook ((org-mode org-babel-after-execute) . org-redisplay-inline-images)
  :init
  (defvar org-mode-local-keymap
    (make-sparse-keymap)
    "local keymap for org mode")
  :mode-hydra
  (org-mode
   ("Edit"
    (;; use `b' for quick access
     ("b" my/org-entry-hydra/body "edit"))))
  :pretty-hydra
  (my/org-entry-hydra
   (:title (pretty-hydra-title "org entry move and adjust") :color pink :quit-key "q")
   ("Headline"
    (("d i" org-previous-visible-heading "previous")
     ("d k" org-next-visible-heading "next")
     ("d j" org-up-element "up")
     ("d l" org-down-element "down")
     ("d u" org-backward-heading-same-level "previous same level")
     ("d o" org-forward-heading-same-level "next same level")
     )
    "Adjust"
    (;; change heading or list level
     ("a l" org-metaright "right")
     ("a j" org-metaleft "left")
     ;; change list icon
     ("a u" org-shiftleft "shift left")
     ("a o" org-shiftleft "shift left")
     ;; shiftmetaleft, move entry left
     ("<" org-shiftmetaleft "move item left")
     (">" org-shiftmetaright "move item right")
     ;; move list up/down
     ("a i" org-metaup "up")
     ("a k" org-metadown "down")
     ("a h" org-shiftmetaup "shift up")
     ("a ;" org-shiftmetadown "shift down"))
    "Cut and copy"
    (("x x" org-cut-special "cut")
     ("c c" org-copy-special "copy"))


    "format"
    (
     ("=" (lambda () (interactive) (org-emphasize ?=) ) "=")
     ("~" (lambda () (interactive) (org-emphasize ?~) ) "~")
     ("*" (lambda () (interactive) (org-emphasize ?*) ) "*")
     ("+" (lambda () (interactive) (org-emphasize ?+) ) "+")
     ("/" (lambda () (interactive) (org-emphasize ?/) ) "/")
     ("_" (lambda () (interactive) (org-emphasize ?_) ) "-")
     )
    "Babal-navigate"
    (("bi" org-babel-previous-src-block "previous block")
     ("bk" org-babel-next-src-block "next block")
     ("bh" org-babel-goto-src-block-head "block head")

     ("bj" jupyter-org-hydra/body "jupyter org hydra")

     )
    "babel-operate"
    (("bv" org-babel-expand-src-block "expand block")
     ("bt" org-babel-tangle "tangle")
     ("bs" org-babel-demarcate-block "split(demarcate)")
     ("be" org-ctrl-c-ctrl-c "evaluate")
     ("bi" org-babel-view-src-block-info "info")
     ("bc" org-babel-remove-result-one-or-many "clear result"))
    "Move"
    (("i" previous-line "previous-line")
     ("k" next-line "next-line")
     ("j" backward-char "backward-char")
     ("l" forward-char "forward-char"))
    )

   )
  :pretty-hydra
  ((:title (pretty-hydra-title "Org Template" 'fileicon "org" :face 'all-the-icons-green :height 1.1 :v-adjust 0.0)
           :color blue :quit-key "q")
   ("Literal basic"
    (("la" (hot-expand "<a") "ascii")
     ("lc" (hot-expand "<c") "center")
     ("lC" (hot-expand "<C") "comment")
     ("le" (hot-expand "<e") "example")
     ("lE" (hot-expand "<E") "export")
     ("lh" (hot-expand "<h") "html")
     ("ll" (hot-expand "<l") "latex")
     ("ln" (hot-expand "<n") "note")
     ("lo" (hot-expand "<q") "quote")
     ("lv" (hot-expand "<v") "verse"))
    "Head"
    (("hi" (hot-expand "<i") "index")
     ("ha" (hot-expand "<A") "ASCII")
     ("hi" (hot-expand "<I") "INCLUDE")
     ("hh" (hot-expand "<H") "HTML")
     ("hl" (hot-expand "<L") "LaTeX"))
    "Source"
    (("s" (hot-expand "<s") "src")
     ("el" (hot-expand "<s" "emacs-lisp") "emacs-lisp")
     ("py" (hot-expand "<s" "python :results output") "python")
     ("k" (hot-expand "<s" "python") "python")
     ("pl" (hot-expand "<s" "perl") "perl")
     ("P" (progn
            (insert "#+HEADERS: :results output :exports both :shebang \"#!/usr/bin/env perl\"\n")
            (hot-expand "<s" "perl")) "Perl tangled")
     ("rb" (hot-expand "<s" "ruby") "ruby")
     ("S" (hot-expand "<s" "sh") "sh")
     ("go" (hot-expand "<s" "go :imports '\(\"fmt\"\)") "golang")
     ("jp" (hot-expand "<s" "jupyter-python") "jupyter-python")
     ("pu" (hot-expand "<s" "plantuml :file CHANGE.png") "plantuml")
     ("ip" (hot-expand "<s" "ipython :session :exports both :results raw drawer\n$0") "ipython")
     )


    "Misc"
    (

     ("<" self-insert-command "ins"))))
  :bind (
         ;; ("C-c a" . org-agenda)
         ;; ("C-c b" . org-switchb)
         ;; ("C-c x" . org-capture)
         :map org-mode-map
         ("<" . (lambda ()
                  "Insert org template."
                  (interactive)
                  (if (or (region-active-p) (looking-back "^\s*" 1))
                      (org-hydra/body)
                    (self-insert-command 1)))

          ))
  :config
  ;; For hydra
  (defun hot-expand (str &optional mod)
    "Expand org template.
STR is a structure template string recognised by org like <s. MOD is a
string with additional parameters to add the begin line of the
structure element. HEADER string includes more parameters that are
prepended to the element after the #+HEADER: tag."
    (let (text)
      (when (region-active-p)
        (setq text (buffer-substring (region-beginning) (region-end)))
        (delete-region (region-beginning) (region-end)))
      (insert str)
      (if (fboundp 'org-try-structure-completion)
          (org-try-structure-completion) ; < org 9
        (progn
          ;; New template expansion since org 9
          (require 'org-tempo nil t)
          (org-tempo-complete-tag)))
      (when mod (insert mod) (forward-line))
      (when text (insert text))))

  ;; 点亮列表 '-' 和 '+', '*', '1)'
  (font-lock-add-keywords 'org-mode '(("^[ \t]*[+-] " . 'font-lock-keyword-face)
                                      ("^[ \t]+\\* " . 'font-lock-keyword-face)
                                      ("^[ \t]*[[:digit:]]+) " . 'font-lock-keyword-face)
                                      ("^[ \t]*[[:digit:]]+\\. " . 'font-lock-keyword-face)
                                      ))
  
  (setq org-edit-src-content-indentation 0)
  (setq org-src-preserve-indentation nil)
  (setq org-indent-indentation-per-level 2)

  (add-hook 'org-mode-hook
            (lambda ()
              (setq-local tab-width 4)))

  ;; org tempo templates
  (require 'org-tempo)
  (add-to-list 'org-structure-template-alist '("py" . "src python"))
  (add-to-list 'org-structure-template-alist '("el" . "src elisp"))
  (add-to-list 'org-structure-template-alist '("cpp" . "src cpp"))
  (add-to-list 'org-structure-template-alist '("java" . "src java"))
  (add-to-list 'org-structure-template-alist '("sh" . "src shell"))
  (add-to-list 'org-structure-template-alist '("xml" . "src xml"))
  (add-to-list 'org-structure-template-alist '("jp" . "src jupyter-python"))

  ;; Source Code 文本高亮
  (setq org-src-fontify-natively t)

  ;; image size 图片显示尺寸
  (setq org-image-actual-width
        (cond (my/4k-p 800)

              (t t)))


  ;; rich yank, for copy source code
  (use-package org-rich-yank
    :straight t
    :bind (:map org-mode-map
                ("C-M-y" . org-rich-yank)))

  ;; Table of contents
  (use-package toc-org
    :straight t
    :hook (org-mode . toc-org-mode))

  ;; Add graphical view of agenda
  (use-package org-timeline
    :hook (org-agenda-finalize . org-timeline-insert-timeline))

  ;; (bind-key "SPC b b" org-babel-map 'xah-fly-command-map)

  )

;; babel related

(setq my/org-babel-language-alist '((shell . t)
                                    (java . t)
                                    (C . t) ;; for c, cpp and D languages
                                    (plantuml . t)
                                    (calc . t)
                                    (lua . t)
                                    (sql . t)
                                    (matlab . t)
                                    (octave . t)
                                    (python . t)))


(use-package ob-go
  :straight t
  :init (cl-pushnew '(go . t) my/org-babel-language-alist)
  :defer t)


(use-package ob-async
  :straight t
  :defer t
  :config
  (setq ob-async-no-async-languages-alist '("jupyter-python" "jupyter-julia")))

(use-package jupyter
  :straight t
  :defer t
  :mode-hydra
  (org-mode
   (:title "Org Commands")
   ("Babel"
    (("j" jupyter-org-hydra/body "Jupyter org hydra"))))
  )

(with-eval-after-load 'org
  (cl-pushnew '(jupyter . t) my/org-babel-language-alist)
  (require 'jupyter)

  (org-babel-do-load-languages
   'org-babel-load-languages
   my/org-babel-language-alist))



;; Presentation
(use-package org-tree-slide
  :commands (org-tree-slide-mode)
  :straight t
  :diminish
  :functions (org-display-inline-images
              org-remove-inline-images)
  ;; :bind (:map org-mode-map
  ;;             ("s-<f7>" . org-tree-slide-mode)
  ;;             :map org-tree-slide-mode-map
  ;;             ("<left>" . org-tree-slide-move-previous-tree)
  ;;             ("<right>" . org-tree-slide-move-next-tree)
  ;;             ("S-SPC" . org-tree-slide-move-previous-tree)
  ;;             ("SPC" . org-tree-slide-move-next-tree))
  :hook ((org-tree-slide-play . (lambda ()
                                  (text-scale-increase 4)
                                  (org-display-inline-images)
                                  (read-only-mode 1)))
         (org-tree-slide-stop . (lambda ()
                                  (text-scale-increase 0)
                                  (org-remove-inline-images)
                                  (read-only-mode -1))))
  :init (setq org-tree-slide-header nil
              org-tree-slide-slide-in-effect t
              org-tree-slide-heading-emphasis nil
              org-tree-slide-cursor-init t
              org-tree-slide-modeline-display 'outside
              org-tree-slide-skip-done nil
              org-tree-slide-skip-comments t
              org-tree-slide-skip-outline-level 3))

(use-package org-indent
  :hook (org-mode . org-indent-mode))

;; org-download
(use-package org-download
  :straight t
  :after org
  :hook ((org-mode dired-mode) . org-download-enable)
  :bind (:map org-mode-map
              ;; download image object from clipboard
              ("C-c l i i" . org-download-clipboard)
              ("C-c l i c" . org-download-screenshot)
              ;; input link by hand
              ("C-c l i h" . org-download-image))
  :mode-hydra
  (org-mode
   ("Images"
    (("i i" org-download-clipboard "image paste from clipboard")
     ("i c" org-download-screenshot "image capture with screenshot")
     ("i h" org-download-image "image download from url"))))
  :config
  ;; (add-hook 'dired-mode-hook 'org-download-enable)
  (setq-default org-download-image-org-width 0)
  ;; not use heading name to store image
  (setq-default org-download-heading-lvl nil)
  )

;; url
(use-package org-cliplink
  :straight t
  :commands (org-cliplink org-cliplink-capture)
  :bind ("C-c l l c" . org-cliplink)
  :mode-hydra
  (org-mode
   ("link"
    (("lc" org-cliplink "from clipboard"))))
  :after org)

;; clip
(use-package org-rich-yank
  :straight t
  :after org
  :bind (:map org-mode-map
              ("C-M-y" . org-rich-yank))
  :mode-hydra
  (org-mode
   (:color teal)
   ("Misc"
    (("m y" org-rich-yank)))))

;; beatify
(use-package org-superstar
  :straight t
  :after org
  :hook (org-mode . org-superstar-mode))

(use-package org-fancy-priorities
  :straight t
  :after org
  :hook
  (org-mode . org-fancy-priorities-mode)
  :config
  ;; (setq org-fancy-priorities-list '("⚡" "⬆" "⬇" "☕")
  )

(use-package ox
  :straight (:type built-in)
  :commands (org-export-dispatch)
  :config
  (use-package ox-pandoc
    :straight t
    :demand t))

(use-package org-preview-html
  :straight t
  :commands (org-preview-html-mode)
  :mode-hydra
  (org-mode
   ("Misc"
    (("m p" org-preview-html-mode "html preview")))))

(provide 'init-org)
