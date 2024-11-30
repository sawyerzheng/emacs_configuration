;; -*- coding: utf-8; -*-
(with-eval-after-load 'simple-httpd
  (when (daemonp)
    (setq httpd-port (+ 20000 (random 10000)))))

(my/straight-if-use 'markdown-mode)
(my/straight-if-use 'markdown-toc)
(my/straight-if-use 'edit-indirect)
(use-package markdown-mode
  :mode (("/README\\(?:\\.md\\)?\\'" . gfm-mode)
         ("\\.md\\'" . gfm-mode))
  :init
  (setq markdown-enable-math t ; syntax highlighting for latex fragments
        markdown-enable-wiki-links t
        markdown-italic-underscore t
        markdown-asymmetric-header t
        markdown-gfm-additional-languages '("sh")
        markdown-make-gfm-checkboxes-buttons t

        ;; HACK Due to jrblevin/markdown-mode#578, invoking `imenu' throws a
        ;;      'wrong-type-argument consp nil' error if you use native-comp.
        markdown-nested-imenu-heading-index (not (ignore-errors (native-comp-available-p)))

        ;; A sensible and simple default preamble for markdown exports that
        ;; takes after the github asthetic (plus highlightjs syntax coloring).
        markdown-content-type "application/xhtml+xml"
        markdown-css-paths
        '("https://cdn.jsdelivr.net/npm/github-markdown-css/github-markdown.min.css"
          "https://cdn.jsdelivr.net/gh/highlightjs/cdn-release/build/styles/github.min.css")
        markdown-xhtml-header-content
        (concat "<meta name='viewport' content='width=device-width, initial-scale=1, shrink-to-fit=no'>"
                "<style> body { box-sizing: border-box; max-width: 740px; width: 100%; margin: 40px auto; padding: 0 10px; } </style>"
                "<script id='MathJax-script' async src='https://cdn.jsdelivr.net/npm/mathjax@3/es5/tex-mml-chtml.js'></script>"
                "<script src='https://cdn.jsdelivr.net/gh/highlightjs/cdn-release/build/highlight.min.js'></script>"
                "<script>document.addEventListener('DOMContentLoaded', () => { document.body.classList.add('markdown-body'); document.querySelectorAll('pre[lang] > code').forEach((code) => { code.classList.add(code.parentElement.lang); }); document.querySelectorAll('pre > code').forEach((code) => { hljs.highlightBlock(code); }); });</script>"))


  :config
  ;; (setq markdown-command "multimarkdown")
  (setq markdown-header-scaling nil)

  ;; Highly rust blocks correctly
  (if (featurep 'rust)
      (add-to-list 'markdown-code-lang-modes '("rust" . rustic-mode)))
  (add-to-list 'markdown-code-lang-modes '("json-with-comments" . jsonc-mode))

  (setq markdown-max-image-size '(900 . 800))

  ;; code block font-lock
  (setq markdown-fontify-code-blocks-natively t)

  ;; markdown list level indent
  (setq markdown-list-indent-width 2)

  ;; * extra packages -------------------------------------------------------

  (use-package markdown-toc
    :hook ((markdown-mode gfm-mode) . markdown-toc-mode)
    :hook (markdown-toc-mode . (lambda ()
                                 (setq-local imenu-create-index-function
                                             #'markdown-imenu-create-nested-index)))
    :after markdown-mode
    :config
    )

  (use-package edit-indirect
    :after markdown-mode)

  ;; https://stackoverflow.com/questions/36183071/how-can-i-preview-markdown-in-emacs-in-real-time/36189456?noredirect=1#comment104784050_36189456
  (require 'init-grip)
  ;; (load-file "~/.conf.d/livedown.emacs")
  ;; (load-file "~/.conf.d/vmd.emacs")
  (require 'init-impatient)
  (require 'init-markdown-preview)

  ;; * markdown buffer `dnd' image handling -------------------------------------------
  (use-package org-download
    )

  (require '+my-markdown-download)
  (setq markdown-download-image-dir "./img/")

  ;; (require 'markdown-preview-mode)
  (my/straight-if-use '(markdown-dnd-images :type git :host github :repo "mooreryan/markdown-dnd-images"))
  (use-package markdown-dnd-images
    :demand t
    :config
    (setq dnd-save-directory "./img/")
    (setq dnd-save-buffer-name nil))

  (defun dnd-insert-image-tag (abs-fname)
    (message (file-truename abs-fname))
    (file-truename (file-name-directory (buffer-file-name)))
    (insert (format "![%s](%s)" (file-name-nondirectory abs-fname)
                    (file-relative-name (file-truename abs-fname)
                                        (file-truename (file-name-directory (buffer-file-name))))))
    (if dnd-capture-source
        (insert (format "\n\n\x2ASource: %s; Accessed: %s\x2A" url (current-time-string))))
    (if dnd-view-inline
        (markdown-display-inline-images)))

  ;; (defun markdown-img-dir-path ()
  ;;   (if (not buffer-file-name)
  ;;       (error (concat "ERROR: Couldn't find buffer-file-name "
  ;;                      "for current buffer")))
  ;;   dnd-save-directory
  ;;   )



  )

(use-package markdown-download
  ;; :after (markdown-mode org-download)
  :bind (:map markdown-mode-command-map
              ("i c" . markdown-download-clipboard)
              ("i s" . markdown-download-screenshot)))

(my/straight-if-use 'gh-md)
(use-package gh-md
  :commands (gh-md-render-buffer
             gh-md-render-region))

(my/straight-if-use '(markdown-soma :type git :host github :repo "jasonm23/markdown-soma" :files  ("*")
                   ;; :pre-build (("cargo install --path ."))
                   ))
(use-package markdown-soma
  :bind (:map markdown-mode-command-map
              ("p" . markdown-soma-mode)
              ("C-p" . markdown-soma-mode))
  :config
  ;; theme for whole page
  (setq markdown-soma-custom-css
        (markdown-soma--css-pathname-from-builtin-name "github-dark"))
  ;; theme for code blocks from highlightjs: https://highlightjs.org/static/demo/
  (setq markdown-soma-highlightjs-theme "github-dark")
  )

(provide 'init-markdown)
