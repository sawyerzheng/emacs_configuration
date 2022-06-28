;; -*- coding: utf-8; -*-

(use-package markdown-mode
  :straight t
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

  ;; A shorter alias for org src blocks than "markdown"
  (with-eval-after-load 'org-src
    (add-to-list 'org-src-lang-modes '("md" . markdown)))

  :config
  ;; Highly rust blocks correctly
  (if (featurep 'rust)
      (add-to-list 'markdown-code-lang-modes '("rust" . rustic-mode)))

  (setq markdown-max-image-size '(900 . 800))


  ;; * extra packages -------------------------------------------------------

  (use-package markdown-toc
    :hook ((markdown-mode gfm-mode) . markdown-toc-mode)
    :after markdown
    :straight t)

  ;; https://stackoverflow.com/questions/36183071/how-can-i-preview-markdown-in-emacs-in-real-time/36189456?noredirect=1#comment104784050_36189456
  (require 'init-grip)
  ;; (load-file "~/.conf.d/livedown.emacs")
  ;; (load-file "~/.conf.d/vmd.emacs")
  (require 'init-impatient)
  (require 'init-markdown-preview)

  ;; * markdown buffer `dnd' image handling -------------------------------------------
  (use-package org-download
    :demand t)

  (load-file "~/home/.evil.d/modules/lang/markdown-extra/+my-markdown-download.el")
  (setq my-markdown-download-image-dir "./img/")

  ;; (require 'markdown-preview-mode)
  (use-package markdown-dnd-images
    :demand t
    :straight (markdown-dnd-images :type git :host github :repo "mooreryan/markdown-dnd-images")
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
  (bind-key "i c" #'my-markdown-download-clipboard 'markdown-mode-command-map)
  (bind-key "i s" #'my-markdown-download-screenshot 'markdown-mode-command-map))


(provide 'init-markdown)
