;; -*- coding: utf-8-unix; -*-
(defvar my/use-org-modern-p t
  "if use `org-modern' package")


(defvar my/org-mode-map (make-sparse-keymap)
  "my bindings org-mode")

(with-eval-after-load 'org
  ;; (key-chord-define org-mode-map "kl" my/org-mode-map)
  (define-key org-mode-map (kbd "C-c C-i") my/org-mode-map))

;;;###autoload
(defun my/org-mode-conf-settings-fn ()
  (interactive)
  (setq-local line-spacing 0.2)
  ;; Increase size of LaTeX fragment previews
  (plist-put org-format-latex-options :scale 1.5)

  (setq-local tab-width 8)

  (setq org-startup-with-inline-images t
        org-image-actual-width '(600)
        org-pretty-entities t
        org-hide-emphasis-markers t

        org-use-sub-superscripts '{}
        org-export-with-sub-superscripts '{}))

(use-package org
  :commands org-mode
  :hook ((org-mode org-babel-after-execute) . org-redisplay-inline-images)
  :hook (org-mode . my/org-mode-conf-settings-fn)
  :config
  (setq org-agenda-start-on-weekday 1)
  (setq calendar-week-start-day 1)
  :init
  (defvar org-mode-local-keymap
    (make-sparse-keymap)
    "local keymap for org mode")
  :config
  (defun insert-zero-width-space-around-chinese-region ()
    "If region is selected and has Chinese characters before or after it,
insert spaces as needed to separate Chinese text from the region."
    (interactive)
    (when (use-region-p)
      (let ((region-begin (region-beginning))
            (region-end (region-end))
            (chinese-char-regexp "[\u4e00-\u9fa5]+"))

	(set-mark region-end)
	(goto-char region-begin)
	;; Check character before region
	(when (> region-begin (point-min))
          (save-excursion
            (goto-char (1- region-begin))
            (when (looking-at chinese-char-regexp)
              (goto-char region-begin)
              (insert "​")
              ;; Update region-end since we inserted a character
              (setq region-end (1+ region-end))

	      (setq region-begin (1+ region-begin))
	      )))

	(push-mark region-begin)
	(goto-char region-end)

	;; Check character after region
	(when (< region-end (point-max))
          (save-excursion
            (goto-char region-end)
            (when (looking-at chinese-char-regexp)
              (insert "​")))))
      )

    )


  (defun my/org-emphasize--adv-fn (&optional CHAR)
    (insert-zero-width-space-around-chinese-region)
    )

  ;; 让 org-mode ** // ~~ 等，格式支持中文，通过插入 zero with space 实现
  (advice-add 'org-emphasize :before #'my/org-emphasize--adv-fn)

  :mode-hydra
  (org-mode
   ("Edit"
    (;; use `b' for quick access
     ("b" my/org-entry-hydra/body "edit"))
    "format"
    (
     ("=" (lambda () (interactive) (org-emphasize ?=) ) "=")
     ("~" (lambda () (interactive) (org-emphasize ?~) ) "~")
     ("*" (lambda () (interactive) (org-emphasize ?*) ) "*")
     ("+" (lambda () (interactive) (org-emphasize ?+) ) "+")
     ("/" (lambda () (interactive) (org-emphasize ?/) ) "/")
     ("_" (lambda () (interactive) (org-emphasize ?_) ) "-")
     )))
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

     ;; ("bj" scimax-jupyter-org-hydra/body "jupyter org hydra")

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
     ("lq" (hot-expand "<q") "quote")
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

     ("<" self-insert-command "ins")
     )))
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

  ;; tweak identation
  (setq org-edit-src-content-indentation 0)
  (setq org-src-preserve-indentation nil)
  (setq org-indent-indentation-per-level 2)

  ;; tweak text display style
  (setq org-hide-emphasis-markers t)

  ;; agenda
  ;; (setq org-agenda-files (list (expand-file-name "~/org/agenda/work") (expand-file-name "~/org/agenda/life")))
  ;; (setq org-agenda-files (file-expand-wildcards "~/org/agenda/**/?*.org"))
  (setq org-agenda-files '("~/org/agenda/work" "~/org/agenda/life"))

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
  (setq org-confirm-babel-evaluate nil)
  (setq org-src-fontify-natively t)

  ;; image size 图片显示尺寸
  (setq org-image-actual-width
        (cond (my/4k-p 800)

              (t t)))


  ;; rich yank, for copy source code
  (use-package org-rich-yank
    :bind (:map org-mode-map
                ("C-M-y" . org-rich-yank)))

  ;; Table of contents
  (use-package toc-org
    :hook (org-mode . toc-org-mode))

  ;; Add graphical view of agenda
  ;; (my/straight-if-use 'org-timeline)
  ;; (use-package org-timeline
  ;;   :hook (org-agenda-finalize . org-timeline-insert-timeline))

  ;; (bind-key "SPC b b" org-babel-map 'xah-fly-command-map)

  ;; markdown support
  (add-to-list 'org-src-lang-modes '("md" . markdown))

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
  :init (cl-pushnew '(go . t) my/org-babel-language-alist)
  :defer t)

(use-package ob-async
  :defer t
  :config
  (setq ob-async-no-async-languages-alist '("jupyter-python" "jupyter-julia")))

(when (boundp 'native-comp-jit-compilation-deny-list)
  (add-to-list 'native-comp-jit-compilation-deny-list ".*jupyter.*"))

(use-package init-jupyter)


(defun my/org-babel-lazy-load-language-advice (orig-fun &rest args)
  (let* ((info (nth 1 args))
	 (lang (nth 0 info))
	 (alist))
    (message "language: %s, args: %s, orig-fun: %s" lang args orig-fun)
    (unless (assoc lang org-babel-load-languages)
      (if (or (eq lang 'jupyter-python) (eq lang 'jupyter-julia))
	  (setq alist '((julia . t)
			(python . t)
			(jupyter . t)))
	(list (cons lang t))))
    (org-babel-do-load-languages
     'org-babel-load-in-session
     alist))
  (apply orig-fun args))

(with-eval-after-load 'ob-core
  (advice-add 'org-babel-execute-src-block :around #'my/org-babel-lazy-load-language-advice))

(defun my/ob-load-lanuage (lang)
  (with-eval-after-load 'org
    (let ((lang (if (symbolp lang) lang (intern lang)))
          (lang-list (list (list lang t))))
      (org-babel-do-load-languages
       'org-babel-load-languages
       lang-list))))


;; Presentation
(use-package org-tree-slide
  :commands (org-tree-slide-mode)
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

;; org-download
(use-package org-download
  :after org
  :hook ((org-mode dired-mode) . org-download-enable)
  :bind (:map org-mode-map
              ;; download image object from clipboard
              ("C-c l i i" . org-download-clipboard)
              ("C-c l i c" . org-download-screenshot)
              ;; rename
              ("C-c l i r" . org-download-rename-at-point)
              ("C-c l i l" . org-download-rename-last-file)
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
  (setq-default org-download-image-dir "./img/")
  (setq-default org-download-image-org-width 0)
  ;; not use heading name to store image
  (setq-default org-download-heading-lvl nil)

  ;; `convert.exe` command file path
  (if my/wsl-p
      (setq my/org-download-convert-command "/mnt/d/soft/scoop/apps/imagemagick/current/convert.exe"))
  (if my/windows-p
      (setq my/org-download-convert-command "d:/soft/scoop/apps/imagemagick/current/convert.exe"))

  )

(defvar my/org-download-convert-command ""
  "convert command file path")

(defun my/org-download-clipboard-advice (orig-fn &rest args)
  (if (file-exists-p my/org-download-convert-command)
      (if (or my/windows-p my/wsl-p)
          (let ((org-download-screenshot-file (if my/wsl-p "./screenshot.png"
                                                org-download-screenshot-file))
                (org-download-screenshot-method
                 (concat my/org-download-convert-command " clipboard: %s")))
            (apply #'org-download-screenshot args)))
    (apply orig-fn basename)))
(defun my/markdown-download-clipboard-advice (orig-fn &rest args)
  (if (file-exists-p my/org-download-convert-command)
      (if (or my/windows-p my/wsl-p)
          (let ((org-download-screenshot-file (if my/wsl-p "./screenshot.png"
                                                org-download-screenshot-file))
                (org-download-screenshot-method
                 (concat my/org-download-convert-command " clipboard: %s")))
            (apply #'my-markdown-download-screenshot args)))
    (apply orig-fn basename)))

(advice-add #'org-download-clipboard :around #'my/org-download-clipboard-advice)
(advice-add #'my-markdown-download-clipboard :around #'my/markdown-download-clipboard-advice)

(defun my/org-download-screenshot ()
  (interactive)
  (shell-command-to-string "cmd.exe /c snipaste.exe snip")
  (shell-command-to-string "cmd.exe /c snipaste.exe snip")
  (shell-command-to-string "cmd.exe /c snipaste.exe snip")
  (sleep-for 0.5)
  (when (derived-mode-p 'org-mode)
    (call-interactively #'org-download-clipboard))
  (when (derived-mode-p 'markdown-mode)
    (call-interactively #'my-markdown-download-clipboard))
  )



;; url
(use-package org-cliplink
  :commands (org-cliplink org-cliplink-capture)
  :bind (:map org-mode-map
              ("C-c l c" . org-cliplink)
              ;; ("C-c C-. C-l C-c" . org-cliplink)
              )
  :bind (:map my/org-mode-map
              ("C-l C-c" . org-cliplink)
              ("l c" . org-cliplink))
  :mode-hydra
  (org-mode
   ("link"
    (("l c" org-cliplink "from clipboard"))))
  :after org)

;; clip
(use-package org-rich-yank
  :after org
  :bind (:map org-mode-map
              ("C-M-y" . org-rich-yank))
  :mode-hydra
  (org-mode
   (:color teal)
   ("Misc"
    (("m y" org-rich-yank)))))

;; beatify
(use-package org-fancy-priorities
  :after org
  :hook ((org-mode . org-fancy-priorities-mode))
  :config
  ;; (setq org-fancy-priorities-list '("⚡" "⬆" "⬇" "☕")
  )

(use-package ox
  :commands (org-export-dispatch)
  :config
  (use-package ox-pandoc
    :demand t))

(use-package org-preview-html
  :commands (org-preview-html-mode)
  :mode-hydra
  (org-mode
   ("Misc"
    (("m p" org-preview-html-mode "html preview")))))


(use-package org-modern-indent
  :hook (org-mode . org-modern-indent-mode)
  :defer t
  )
(use-package org-indent
  :hook (org-mode . org-indent-mode))

(use-package org-modern
  :if my/use-org-modern-p
  :commands
  (org-modern-mode)
  :hook ((org-mode . org-modern-mode)
         (org-agenda-finalize . org-modern-agenda))
  :config
  (setq org-modern-hide-stars ".")
  (setq org-modern-table t)
  (setq org-modern-block-fringe nil)
  (setq org-modern-horizontal-rule t))

(use-package org-transclusion
  :commands (org-transclusion-mode
             org-transclusion-add))

(use-package org-pandoc-import
  :commands (org-pandoc-import-markdown-as-org))



;; 在 cursor 移动到 link, latex 等元素上时，显示可编辑内容，否则显示渲染后的内容
(use-package org-appear
  :hook (org-mode . org-appear-mode)
  :config
  (setq org-appear-autolinks t
        org-appear-autoentities t
        org-appear-autosubmarkers t
        org-appear-autoemphasis t
        org-appear-inside-latex t)
  )

(use-package olivetti
  :init
  (setq olivetti-body-width 0.67)
  :config
  (setq my/olivetti-scale-ratio 1.2)
  (defun distraction-free ()
    "Distraction-free writing environment"
    (interactive)
    (if (equal olivetti-mode nil)
        (progn
          (window-configuration-to-register 1)
          (delete-other-windows)
          (text-scale-increase my/olivetti-scale-ratio)
          (olivetti-mode t))
      (progn
        (jump-to-register 1)
        (olivetti-mode 0)
        (text-scale-decrease my/olivetti-scale-ratio)))
    (defalias 'focus-mode #'distraction-free)
    (defalias 'writing-mode #'distraction-free)
    )

  :commands (olivetti-mode
             distraction-free))

(define-minor-mode centaur-read-mode
  "Minor Mode for better reading experience."
  :init-value nil
  :group centaur
  (if centaur-read-mode
      (progn
        (and (fboundp 'olivetti-mode) (olivetti-mode 1))
        (and (fboundp 'mixed-pitch-mode) (mixed-pitch-mode 1))
        (text-scale-set +1))
    (progn
      (and (fboundp 'olivetti-mode) (olivetti-mode -1))
      (and (fboundp 'mixed-pitch-mode) (mixed-pitch-mode -1))
      (text-scale-set 0))))

(use-package org-pretty-table
  :commands (org-pretty-table-mode))

;;; latex 公式预览
;;;; org-fragtog 使用 latex 命令
;; 直接在 org-mode 上显示 latex 公式，上下边等, 并且会自动启动 latex 转换，当光标放到 latex 上时
(use-package org-fragtog
  :commands (org-fragtog-mode)
  ;; :hook (org-mode . org-fragtog-mode)
  )


;;;; math-preview 使用 mathjax
;; ref: https://gitlab.com/matsievskiysv/math-preview
;; 1. 生效：手动选择公式区域， `math-preview-region' 预览公式渲染效果
;; 2. 取消预览：移动cursor 到公式位置，<Enter>
;; 3. 使用 mathjax 作为熏染工具 math-preview js 命令
(use-package math-preview
  ;; require: npm install -g git+https://gitlab.com/matsievskiysv/math-preview
  :defer t
  :commands (math-preview-all
	     math-preview-at-point
	     math-preview-region
	     math-preview-increment-scale
	     math-preview-decrement-scale
	     math-preview-start-process
	     math-preview-stop-process)
  )


;;;; 优化 org-mode 自带的 `org-latex-preview'
;; 这个只是一个示范项目
;; preview org-mode latex, in current buffer
;; ref: https://github.com/karthink/org-preview?tab=readme-ov-file
;; (my/straight-if-use '(org-preview :type git :host github :repo "karthink/org-preview"))
;; (use-package org-preview
;;   :commands (org-preview-mode)
;;   :config
;;   )

;;;; 使用 tex2svg 命令， 类似 popweb-latex-mode,使用弹出窗口（posframe）显示
;; 依赖： npm install -g mathjax-node-cli
(use-package org-latex-impatient
  :defer t
  :commands (org-latex-impatient-mode)
  ;; :hook (org-mode . org-latex-impatient-mode)
  :init
  (setq org-latex-impatient-tex2svg-bin
        ;; location of tex2svg executable
        ;; "~/node_modules/mathjax-node-cli/bin/tex2svg"
	(executable-find "tex2svg")
	))

;; ref: https://gitlab.com/latex-math-preview/latex-math-preview/-/blob/master/latex-math-preview.el?ref_type=heads
;;
;; 1. 使用 `latex' 命令作为渲染工具
;; 2. 选择区域， `latex-math-preview-expression' 预览
;; 3.
(use-package latex-math-preview
  :defer t)

(use-package org-ol-tree
  :commands (org-ol-tree))

;; hugo-blog
(defun my/hugo-org-update-timestamp ()
  (interactive)
  (when (derived-mode-p 'org-mode)
    (let ((time-stamp-active t)
          (time-stamp-start "#\\+lastmod:[ \t]*")
          (time-stamp-end "$")
          (time-stamp-format "[%04Y-%02m-%02d %a]"))
      (time-stamp))))
(with-eval-after-load 'org
  (add-hook 'after-save-hook #'my/hugo-org-update-timestamp nil))

(use-package ox-ipynb
  :after ox)

(use-package init-outli)

(require 'init-org-journal)

(use-package consult-notes
  :commands (consult-notes
             consult-notes-search-in-all-notes
             ;; if using org-roam
             consult-notes-org-roam-find-node
             consult-notes-org-roam-find-node-relation)
  :bind (("C-c n s" . consult-notes)
	 ("C-c n S" . consult-notes-search-in-all-notes))
  :config
  (setq consult-notes-file-dir-sources '(("note" ?n "~/org/note"))) ;; Set notes dir(s), see below
  (consult-notes-org-headings-mode)
  (when (locate-library "denote")
    (consult-notes-denote-mode))
  ;; search only for text files in denote dir
  (setq consult-notes-denote-files-function (function denote-directory-text-only-files)))

;; ;;; 支持 org-mode 中，`图片按行滚动',而不出一次滚动整个图片大幅度滚动
;; ;; ref: https://github.com/jcfk/org-sliced-images
;; (use-package
;;   :if nil ;; 测试发现，切分后的图片有黑条，停止使用
;;   :after org
;;   (org-sliced-images-mode 1))

(provide 'init-org)
