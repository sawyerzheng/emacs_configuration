;; -*- coding: utf-8; -*-
(my/straight-if-use 'impatient-mode)
(use-package impatient-mode
  :after (markdown-mode)
  :bind (:map markdown-mode-command-map
              ("i" . impatient-mode))
  :config
  ;;(setq httpd-port 18080)
  (defun my/impatient-open ()
    (interactive)
    (browse-url (format "http://localhost:%s/imp/live/%s" httpd-port (file-name-nondirectory (buffer-file-name)))))


  (add-hook 'impatient-mode-hook 'httpd-start 0)
  (add-hook 'impatient-mode-hook #'my/impatient-open 100)
  ;;(add-hook 'markdown-mode-hook 'impatient-mode)

  ;; markdown filter
  (defun markdown-html (buffer)
    (princ (with-current-buffer buffer
             (format "<!DOCTYPE html><html><title>Impatient Markdown</title><xmp theme=\"united\" style=\"display:none;\"> %s  </xmp><script src=\"http://strapdownjs.com/v/0.2/strapdown.js\"></script></html>" (buffer-substring-no-properties (point-min) (point-max))))
           (current-buffer)))

  ;; (add-hook 'markdown-mode-hook #'impatient-mode)
  ;; (add-hook 'markdown-mode-hook #'(lambda ()
  ;;                                   (make-local-variable 'imp-user-filter)
  ;;                                   (setq-default imp-user-filter 'markdown-html)
  ;;                                   (cl-incf imp-last-state)
  ;;                                   (imp--notify-clients)))

  (defvar my/impatient-markdown-theme "github-markdown-dark.min")
  ;; another markdown filter
  (defun imp-md2html (buffer)
    (princ (with-current-buffer buffer
             (format "<!DOCTYPE html><html><head>
<script src=\"https://cdnjs.cloudflare.com/ajax/libs/marked/5.1.0/marked.min.js\"></script>
<link rel=\"stylesheet\" href=\"https://cdnjs.cloudflare.com/ajax/libs/github-markdown-css/5.2.0/github-markdown-light.min.css\">


  <script>
  MathJax = {
    tex: {inlineMath: [['$', '$'], ['\\(', '\\)']]}
  };
  </script>
  <script id=\"MathJax-script\" async src=\"https://cdn.jsdelivr.net/npm/mathjax@3/es5/tex-chtml.js\"></script>

<!--
<link rel=\"stylesheet\" href=\"https://cdnjs.cloudflare.com/ajax/libs/KaTeX/0.16.8/katex.min.css\" integrity=\"sha512-7nTa5CnxbzfQgjQrNmHXB7bxGTUVO/DcYX6rpgt06MkzM0rVXP3EYCv/Ojxg5H0dKbY7llbbYaqgfZjnGOAWGA==\" crossorigin=\"anonymous\" referrerpolicy=\"no-referrer\" />
<script src=\"https://cdnjs.cloudflare.com/ajax/libs/KaTeX/0.16.8/katex.min.js\" integrity=\"sha512-aoZChv+8imY/U1O7KIHXvO87EOzCuKO0GhFtpD6G2Cyjo/xPeTgdf3/bchB10iB+AojMTDkMHDPLKNxPJVqDcw==\" crossorigin=\"anonymous\" referrerpolicy=\"no-referrer\"></script>
<script src=\"https://cdnjs.cloudflare.com/ajax/libs/KaTeX/0.16.8/contrib/auto-render.min.js\" integrity=\"sha512-iWiuBS5nt6r60fCz26Nd0Zqe0nbk1ZTIQbl3Kv7kYsX+yKMUFHzjaH2+AnM6vp2Xs+gNmaBAVWJjSmuPw76Efg==\" crossorigin=\"anonymous\" referrerpolicy=\"no-referrer\"></script>

<script>
    document.addEventListener(\"DOMContentLoaded\", function() {
        renderMathInElement(document.body, {
          // customised options
          // • auto-render specific keys, e.g.:
          delimiters: [
              {left: '$$', right: '$$', display: true},
              {left: '$', right: '$', display: true},
              {left: '\\(', right: '\\)', display: false},
              {left: '\\[', right: '\\]', display: true},

              {left: \"\\begin{equation}\", right: \"\\end{equation}\", display: true},
              {left: \"\\begin{align}\", right: \"\\end{align}\", display: true},
              {left: \"\\begin{alignat}\", right: \"\\end{alignat}\", display: true},
              {left: \"\\begin{gather}\", right: \"\\end{gather}\", display: true},
              {left: \"\\begin{CD}\", right: \"\\end{CD}\", display: true},
          ],
          // • rendering keys, e.g.:
          throwOnError : false
        });
    });
</script>
--!>
</head><body>
<div id=\"marked\" class=\"markdown-body\"></div>
<div id=\"buffer\" style=\"display:none;\">%s</div>
<script>document.getElementById('marked').innerHTML = marked.parse(document.getElementById('buffer').textContent);</script>
</body></html>"
                     ;; my/impatient-markdown-theme
                     (buffer-substring-no-properties (point-min) (point-max))))
           (current-buffer)))

  (add-to-list 'imp-default-user-filters '(markdown-mode . imp-md2html))
  (add-to-list 'imp-default-user-filters '(gfm-mode . imp-md2html))
  )

(provide 'init-impatient)
