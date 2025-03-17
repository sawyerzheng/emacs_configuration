;; -*- coding: utf-8-unix; -*-
(defvar my/use-org-modern-p t
  "if use `org-modern' package")


(defvar my/org-mode-map (make-sparse-keymap)
  "my bindings org-mode")

(with-eval-after-load 'org
  ;; (key-chord-define org-mode-map "kl" my/org-mode-map)
  (define-key org-mode-map (kbd "C-c C-i") my/org-mode-map))

(my/straight-if-use '(org :type built-in))
(my/straight-if-use 'org-rich-yank)
(my/straight-if-use 'toc-org)

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

(my/straight-if-use '(org :type built-in))
(my/straight-if-use '(org-mode :type built-in))
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

     ("bj" scimax-jupyter-org-hydra/body "jupyter org hydra")

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

(my/straight-if-use 'ob-go)
(use-package ob-go
  :init (cl-pushnew '(go . t) my/org-babel-language-alist)
  :defer t)

(my/straight-if-use 'ob-async)
(use-package ob-async
  :defer t
  :config
  (setq ob-async-no-async-languages-alist '("jupyter-python" "jupyter-julia")))

(when (boundp 'native-comp-jit-compilation-deny-list)
  (add-to-list 'native-comp-jit-compilation-deny-list ".*jupyter.*"))



(my/straight-if-use '(jupyter :no-native-compile t))
(use-package jupyter
  :defer t
  :config

  (add-to-list 'org-babel-load-languages '(emacs-lisp . t) t)
  (add-to-list 'org-babel-load-languages '(julia . t) t)
  (add-to-list 'org-babel-load-languages '(python . t) t)
  (add-to-list 'org-babel-load-languages '(jupyter . t) t)
  :mode-hydra
  (org-mode
   (:title "Org Commands")
   ("Babel"
    (("j" scimax-jupyter-org-hydra/body "Jupyter org hydra"))))

  :config
  (require 'jupyter-org-client)
  (define-key jupyter-org-interaction-mode-map (kbd "M-i") nil)
  (dolist (lang-info my/org-babel-language-alist)
    ;; (add-to-list 'org-babel-load-languages '(jupyter . t) t)
    (add-to-list 'org-babel-load-languages lang-info t)
    )

  (with-eval-after-load 'ob-jupyter
    (defun my/org-return (&optional indent arg interactive)

      (interactive "i\nP\np")
      (let* ((context (if org-return-follows-link (org-element-context)
                        (org-element-at-point)))
             (element-type (org-element-type context)))
        (if (eq element-type 'src-block)
            (call-interactively #'org-return-and-maybe-indent)
          (org-return indent arg interactive))))

    (define-key org-mode-map (kbd "RET") #'my/org-return))
  (with-eval-after-load 'org
    (with-eval-after-load 'scimax-ob
      (remove-hook 'org-mode-hook #'scimax-ob-src-key-bindings)))



  (require 'scimax-jupyter)
  (add-hook 'org-mode-hook #'scimax-jupyter-ansi)
  (setq my/scimax-ob-src-key-bindings
        '(
          ;; ("<return>" . #'newline-and-indent)
          ("C-<return>" #'org-ctrl-c-ctrl-c #'org-insert-heading-respect-content)
          ("S-<return>"  #'scimax-ob-execute-and-next-block #'org-table-copy-down)
          ("M-<return>"  (lambda ()
		           (interactive)
		           (scimax-ob-execute-and-next-block t))
           nil)
          ("M-S-<return>" #'scimax-ob-execute-to-point #'org-insert-todo-heading)
          ("C-M-<return>" #'org-babel-execute-buffer nil)
          ;; ("s-." . #'scimax-ob/body nil)
          )
        )

  (defmacro my/scimax-ob-define-src-key (language key def default-def)
    "For LANGUAGE (symbol) src blocks, define key sequence KEY as DEF.
KEY should be a string sequence that will be used in a `kbd' sequence.
This is like `define-key', except the definition only applies in
src blocks for a specific LANGUAGE.

If language is nil apply to all src-blocks.

Adapted from
http://endlessparentheses.com/define-context-aware-keys-in-emacs.html"
    (declare (indent 3)
	     (debug (form form form &rest sexp)))
    ;; ;; store the key in scimax-src-keys
    ;; (unless (cdr (assoc language scimax-ob-src-keys))
    ;;   (cl-pushnew (list language '()) scimax-ob-src-keys))

    ;; (cl-pushnew (cons key def) (cdr (assoc language scimax-ob-src-keys)))

    `(define-key org-mode-map ,(kbd key)
                 '(menu-item
                   ,(format "maybe-%s" (or (car (cdr-safe def)) def))
                   nil
                   :filter (lambda (&optional _)
		             ,(if language
		                  `(when (and (org-in-src-block-p)
				              (string= ,(symbol-name language)
					               (car (org-babel-get-src-block-info t))))
			             ,def)
		                `(cond ((org-in-src-block-p)
		                        ,def)
                                       (t
                                        ,default-def)))))))

  (defun my/scimax-ob-src-key-bindings ()
    "context key binding, but still use original command when no in a org src code block"
    ;; These should work in every src-block IMO.
    (cl-loop for (key  cmd default-cmd) in my/scimax-ob-src-key-bindings
	     do
	     (eval `(my/scimax-ob-define-src-key nil ,key ,cmd ,default-cmd))))

  (add-hook 'org-mode-hook #'my/scimax-ob-src-key-bindings)

  (define-key org-mode-map (kbd "M-' M-'") #'scimax-jupyter-org-hydra/body)
  (define-key org-mode-map (kbd "M-\"") #'scimax-jupyter-org-hydra/body)

  ;; (defalias 'org-babel-execute:python 'org-babel-execute:jupyter-python)

  ;; treesit patch, ref: https://github.com/emacs-jupyter/jupyter/issues/478
  ;; (org-babel-jupyter-override-src-block "python")
  ;; To ensure python src blocks are opened in python-ts-mode
  ;; (setf (alist-get "python" org-src-lang-modes nil nil #'equal) 'python-ts)
  ;; (setf (alist-get "python" org-src-lang-modes nil nil #'equal) 'python)

  ;; my patch
  (defun jupyter-repl-associate-buffer (client)
    "Associate the `current-buffer' with a REPL CLIENT.
If the `major-mode' of the `current-buffer' is the
`jupyter-repl-lang-mode' of CLIENT, call the function
`jupyter-repl-interaction-mode' to enable the corresponding mode.

CLIENT should be the symbol `jupyter-repl-client' or the symbol
of a subclass.  If CLIENT is a buffer or the name of a buffer, use
the `jupyter-current-client' local to the buffer."
    (interactive
     (list
      (when-let* ((buffer (jupyter-repl-completing-read-repl-buffer major-mode)))
        (buffer-local-value 'jupyter-current-client buffer))))
    (if (not client)
        (when (y-or-n-p "No REPL for `major-mode' exists.  Start one? ")
          (call-interactively #'jupyter-run-repl))
      (setq client (if (or (bufferp client) (stringp client))
                       (with-current-buffer client
                         jupyter-current-client)
                     client))
      (unless (object-of-class-p client 'jupyter-repl-client)
        (error "Not a REPL client (%s)" client))
      (let ((client-major-mode (jupyter-kernel-language-mode client)))
        (cond ((and (eq client-major-mode 'python-ts-mode)
                    (eq major-mode 'python-mode)
                    )
               nil)
              (t
               (unless (eq (jupyter-kernel-language-mode client) major-mode)
                 (error "Cannot associate buffer to REPL.  Wrong `major-mode'"))))
        )

      (setq-local jupyter-current-client client)
      (unless jupyter-repl-interaction-mode
        (jupyter-repl-interaction-mode))))

  )

;; (with-eval-after-load 'org
;;   (require 'jupyter)
;;   ;; (require 'ob-jupyter)
;;   ;; (require 'scimax-jupyter)
;;   )

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
(my/straight-if-use 'org-tree-slide)
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

(use-package org-indent
  :hook (org-mode . org-indent-mode))

;; org-download
(my/straight-if-use 'org-download)
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
(my/straight-if-use 'org-cliplink)
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
(my/straight-if-use 'org-rich-yank)
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
(my/straight-if-use 'org-fancy-priorities)
(use-package org-fancy-priorities
  :after org
  :hook ((org-mode . org-fancy-priorities-mode))
  :config
  ;; (setq org-fancy-priorities-list '("⚡" "⬆" "⬇" "☕")
  )

(my/straight-if-use '(ox :type built-in))
(my/straight-if-use 'ox-pandoc)
(use-package ox
  :commands (org-export-dispatch)
  :config
  (use-package ox-pandoc
    :demand t))

(my/straight-if-use 'org-preview-html)
(use-package org-preview-html
  :commands (org-preview-html-mode)
  :mode-hydra
  (org-mode
   ("Misc"
    (("m p" org-preview-html-mode "html preview")))))

(my/straight-if-use 'org-modern)
(use-package org-modern
  :commands
  (org-modern-mode)
  :hook ((org-mode . org-modern-mode)
         (org-agenda-finalize . org-modern-agenda))
  :config
  (setq org-modern-hide-stars ".")
  (setq org-modern-table nil)
  (setq org-modern-block-fringe nil)
  (setq org-modern-horizontal-rule nil))

(my/straight-if-use 'org-transclusion)
(use-package org-transclusion
  :commands (org-transclusion-mode
             org-transclusion-add))

(my/straight-if-use '(org-pandoc-import :host github
					:repo "tecosaur/org-pandoc-import"
					:files ("*.el" "filters" "preprocessors")))
(use-package org-pandoc-import
  :commands (org-pandoc-import-markdown-as-org))



;; 在 cursor 移动到 link, latex 等元素上时，显示可编辑内容，否则显示渲染后的内容
(my/straight-if-use 'org-appear)
(use-package org-appear
  :hook (org-mode . org-appear-mode)
  :config
  (setq org-appear-autolinks t
        org-appear-autoentities t
        org-appear-autosubmarkers t
        org-appear-autoemphasis t
        org-appear-inside-latex t)
  )

(my/straight-if-use '(org-modern-indent :type git :host github :repo "jdtsmith/org-modern-indent"))
(use-package org-modern-indent
  ;; :hook (org-indent-mode . org-modern-indent-mode)
  :defer t
  )

(my/straight-if-use 'olivetti)
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


(my/straight-if-use '(org-pretty-table :type git :host github :repo "Fuco1/org-pretty-table"))
(use-package org-pretty-table
  :commands (org-pretty-table-mode))

;;; latex 公式预览
;;;; org-fragtog 使用 latex 命令
;; 直接在 org-mode 上显示 latex 公式，上下边等, 并且会自动启动 latex 转换，当光标放到 latex 上时
(my/straight-if-use 'org-fragtog)
(use-package org-fragtog
  :commands (org-fragtog-mode)
  ;; :hook (org-mode . org-fragtog-mode)
  )


;;;; math-preview 使用 mathjax
;; ref: https://gitlab.com/matsievskiysv/math-preview
;; 1. 生效：手动选择公式区域， `math-preview-region' 预览公式渲染效果
;; 2. 取消预览：移动cursor 到公式位置，<Enter>
;; 3. 使用 mathjax 作为熏染工具 math-preview js 命令
(my/straight-if-use 'math-preview)
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
(my/straight-if-use 'org-latex-impatient)
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
(my/straight-if-use 'latex-math-preview)
(use-package latex-math-preview
  :defer t)

(my/straight-if-use '(org-ol-tree :type git :host github :repo "Townk/org-ol-tree"))
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


(my/straight-if-use '(ox-ipynb :type git :host github :repo "jkitchin/ox-ipynb"))
(use-package ox-ipynb
  :after ox)

(my/straight-if-use '(outli :type git :host github :repo "jdtsmith/outli"))
(use-package outli
  :after (org)
  :commands (outli-mode)
  :hook ((python-base-mode java-mode java-ts-mode rust-mode rust-ts-mode shell-script-mode dockerfile-mode dockerfile-ts-mode prog-mode yaml-mode yaml-ts-mode) . outli-mode)
  :init
  (require 'org))


(require 'init-org-journal)

(my/straight-if-use '(consult-notes :type git :host github :repo "mclear-tools/consult-notes"))
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

(provide 'init-org)
