(provide 'init-straight-packages)

;;; hydra
(my/straight-if-use 'major-mode-hydra)
(my/straight-if-use 'pretty-hydra)

;;; org-mode
(my/straight-if-use '(org :type built-in))
(my/straight-if-use 'org-rich-yank)
(my/straight-if-use 'toc-org)
;;(my/straight-if-use '(org-mode :type built-in))
(my/straight-if-use 'ob-go)
(my/straight-if-use 'ob-async)
(my/straight-if-use 'org-tree-slide)
(my/straight-if-use 'org-download)
(my/straight-if-use 'org-cliplink)
(my/straight-if-use 'org-rich-yank)
(my/straight-if-use 'org-fancy-priorities)
;; (my/straight-if-use '(ox :type built-in))
(my/straight-if-use 'ox-pandoc)
(my/straight-if-use 'org-preview-html)
(my/straight-if-use '(org-modern-indent :type git :host github :repo "jdtsmith/org-modern-indent"))
(my/straight-if-use 'org-modern)
(my/straight-if-use 'org-transclusion)
(my/straight-if-use '(org-pandoc-import :type git :host github
		      :repo "tecosaur/org-pandoc-import"
		      :files ("*.el" "filters" "preprocessors")))
(my/straight-if-use 'org-appear)
(my/straight-if-use 'olivetti)
(my/straight-if-use '(org-pretty-table :type git :host github :repo "Fuco1/org-pretty-table"))
(my/straight-if-use 'org-fragtog)
(my/straight-if-use 'math-preview)
(my/straight-if-use 'org-latex-impatient)
(my/straight-if-use 'latex-math-preview) ;; very quick latex preview images generating
(my/straight-if-use '(org-ol-tree :type git :host github :repo "Townk/org-ol-tree"))
(my/straight-if-use '(ox-ipynb :type git :host github :repo "jkitchin/ox-ipynb"))
(my/straight-if-use '(consult-notes :type git :host github :repo "mclear-tools/consult-notes"))
(my/straight-if-use '(org-sliced-image :type git :host github :repo "jcfk/org-sliced-images")) ;; not work well
;;;; hugo blog
(my/straight-if-use 'ox-hugo)

;;; vertico
(my/straight-if-use 'vertico)
(my/straight-if-use 'orderless)

;;; consult
(my/straight-if-use 'consult)
(my/straight-if-use 'consult-eglot)
(my/straight-if-use 'consult-flycheck)
(my/straight-if-use 'consult-yasnippet)
(my/straight-if-use 'consult-dir)
(my/straight-if-use '(consult-tramp :type git :host github :repo "Ladicle/consult-tramp"))
(my/straight-if-use '(consult-omni :type git :host github :repo "armindarvish/consult-omni" :files ("*.el" "sources/*.el")))

;;; counsel
(my/straight-if-use 'counsel-jq)
(my/straight-if-use 'ivy)
(my/straight-if-use 'swiper)

;;; embark
(my/straight-if-use 'embark)
(my/straight-if-use 'marginalia)
(my/straight-if-use 'embark-consult)

;;; regex
(my/straight-if-use 'visual-regexp)
(my/straight-if-use 'visual-regexp-steroids)

;;; outli
(my/straight-if-use '(outli :type git :host github :repo "jdtsmith/outli"))


;;; ace-window
(my/straight-if-use 'ace-window)

;;; init-jump
(my/straight-if-use 'dumb-jump)
(my/straight-if-use 'ace-pinyin)
(my/straight-if-use 'ace-link)
(my/straight-if-use 'back-button)
(my/straight-if-use 'bm)
(my/straight-if-use 'imenu-list)

;;; init-python
(my/straight-if-use 'pyvenv)
(my/straight-if-use 'pytest)
(my/straight-if-use 'python-pytest)
(my/straight-if-use 'code-cells)
(my/straight-if-use 'conda)
(my/straight-if-use 'live-py-mode)
(my/straight-if-use 'pet)
(my/straight-if-use 'tomlparse)

;;; chinese
;;;; init-pyim
(my/straight-if-use 'pyim)
(my/straight-if-use 'posframe)
(my/straight-if-use 'popup)
(my/straight-if-use 'popon)
(my/straight-if-use 'pyim-basedict)

;;;; word segment
(my/straight-if-use '(deno-bridge :type git :host github :repo "manateelazycat/deno-bridge"))
;; (if my/doom-p
;;     (package! deno-bridge-jieba :recipe (:type git :host github :repo "ginqi7/deno-bridge-jieba" :files ("deno-bridge-jieba.el" "deno-bridge-jieba.ts" "*.el" "*.ts")))
;;   (my/straight-if-use '(deno-bridge-jieba :type git :host github :repo "ginqi7/deno-bridge-jieba" :files (:defaults "*" "*.ts"))))
(my/straight-if-use '(deno-bridge-jieba :type git :host github :repo "ginqi7/deno-bridge-jieba" :files ("*.el" "*.ts" "deno-jieba") :build (:not compile)))
;; (package! deno-bridge-jieba :recipe (:type git :host github :repo "ginqi7/deno-bridge-jieba" :files ("*.el" "*.ts" "deno-jieba")))
(my/straight-if-use 'chinese-word-at-point)

;;;; cnfonts
(my/straight-if-use 'cnfonts)


;;; major hydra
(my/straight-if-use 'major-mode-hydra)


;;; init-emacs-lisp elisp
(my/straight-if-use 'elisp-def)
(my/straight-if-use 'highlight-defined)
(my/straight-if-use 'highlight-quoted)
(my/straight-if-use 'rainbow-delimiters)


;;; jupyter
(my/straight-if-use '(jupyter :no-native-compile t))


;;; yasnippet
(my/straight-if-use 'yasnippet)
(my/straight-if-use 'auto-yasnippet)
(my/straight-if-use 'yasnippet-snippets)

;;; llm related
(my/straight-if-use '(async-await :type git :host github :repo "chuntaro/emacs-async-await" :files ("*")))

;;;; gptel
(my/straight-if-use '(gptel :type git :host github :repo "karthink/gptel"))
(my/straight-if-use '(gptel-quick :type git :host github :repo "karthink/gptel-quick"))
(my/straight-if-use '(gptel-prompts :type git :host github :repo "jwiegley/gptel-prompts"))
(my/straight-if-use 'yaml)
(my/straight-if-use 'templatel)

;;;; elysium
(my/straight-if-use '(elysium :type git :host github :repo "lanceberge/elysium"))

;;;; llm.el related
(my/straight-if-use '(plz :source (melpa gnu-elpa-mirror)))
(my/straight-if-use 'plz-event-source)
(my/straight-if-use 'plz-media-type)

(my/straight-if-use 'llm)
(my/straight-if-use '(magit-gptcommit :type git :host github :repo "douo/magit-gptcommit"))
;; ellama
(my/straight-if-use '(ellama :type git :host github :repo "s-kostyaev/ellama"))

;;;; minuet
(my/straight-if-use '(minuet-ai :type git :host github :repo "milanglacier/minuet-ai.el"))

;;;; aider
(my/straight-if-use '(aidermacs :host github :repo "MatthewZMD/aidermacs" :files ("*.el")))
(my/straight-if-use '(aider :type git :host github :repo "tninja/aider.el" :files ("*.el")))

;;;; emigo
(my/straight-if-use '(emigo :type git :host github :repo "MatthewZMD/emigo" :files ("*")))

;;; thing-edit
(my/straight-if-use '(thing-edit :type git :host github :repo "manateelazycat/thing-edit"))
(my/straight-if-use '(open-newline :type git :host github :repo "manateelazycat/open-newline"))
(my/straight-if-use '(move-text :type git :host github :repo "manateelazycat/move-text"))
(my/straight-if-use '(duplicate-line :type git :host github :repo "manateelazycat/duplicate-line"))
(my/straight-if-use '(find-orphan :type git :host github :repo "manateelazycat/find-orphan"))
(my/straight-if-use '(drag-stuff :type git :host github :repo "rejeep/drag-stuff.el"))
(my/straight-if-use 'chinese-word-at-point)

;;; M-m
(my/straight-if-use 'mwim)


;;; scimax-notebook
(my/straight-if-use 'ggtags)
(my/straight-if-use 'projectile)
(my/straight-if-use 'ibuffer-projectile)
(my/straight-if-use 'ag)
(my/straight-if-use 'org-ql)
(my/straight-if-use 'ivy-xref)


;;; ox-ipynb
(my/straight-if-use '(ox-ipynb :type git :host github :repo "jkitchin/ox-ipynb"))

;;; nano emacs
(my/straight-if-use '(nano-emacs :type git :host github :repo "rougier/nano-emacs"))

;;; llm tools
(my/straight-if-use '(llm-tool-collections :type git :host github :repo "skissue/llm-tool-collection"))

;;; mcp.el
(my/straight-if-use '(mcp :type git :host github :repo "lizqwerscott/mcp.el"))


;;; yasnippet
(my/straight-if-use 'yasnippet)
(my/straight-if-use 'yasnippet-snippets)


;;; scimax
(my/straight-if-use '(scimax :type git :host github :repo "sawyerzheng/scimax" :files (:defaults "*")))


;;; csv, tsv
(my/straight-if-use 'csv-mode)
(my/straight-if-use '(rainbow-csv :type git :host github :repo "emacs-vs/rainbow-csv"))

;;; mermaid
(my/straight-if-use 'mermaid-mode)
(my/straight-if-use 'ob-mermaid)

;;; elisp page line break
(my/straight-if-use 'page-break-lines)


;;; devcontainers
(my/straight-if-use '(devcontainer :type git :host github :repo "johannes-mueller/devcontainer.el"))


;;; major modes
(my/straight-if-use 'yaml-mode)
(my/straight-if-use 'web-mode)
(my/straight-if-use 'js2-mode)
(my/straight-if-use 'lua-mode)
(my/straight-if-use 'json-mode)
(my/straight-if-use 'powershell)
(my/straight-if-use 'yaml-mode)
(my/straight-if-use 'typescript-mode)
(my/straight-if-use '(dockerfile-mode :type git :host github :repo "spotify/dockerfile-mode"))
(my/straight-if-use 'markdown-mode)

;;; logview
(my/straight-if-use 'logview)
(my/straight-if-use 'datetime)
(my/straight-if-use 'extmap)

;;; ui
;;;; breadcrumb
(my/straight-if-use 'breadcrumb)
;;;; flyover
(my/straight-if-use '(flyover :type git :host github :repo "konrad1977/flyover"))
;;;; icons
(my/straight-if-use 'nerd-icons)
(my/straight-if-use 'nerd-icons-completion)
(my/straight-if-use 'nerd-icons-ibuffer)
;;;; yascroll
(my/straight-if-use 'yascroll)

(my/straight-if-use 'anzu)
(my/straight-if-use '(awesome-tray :type git :host github :repo "manateelazycat/awesome-tray"))
(my/straight-if-use '(hydra-posframe :type git :host github :repo "Ladicle/hydra-posframe"))
(my/straight-if-use '(holo-layer :type git :host github :repo "manateelazycat/holo-layer" :files ("*")))
(my/straight-if-use 'nav-flash)
(my/straight-if-use 'solaire-mode)
(my/straight-if-use '(sort-tab :type git :host github :repo "manateelazycat/sort-tab"))

;;;; centaur-tabs
(my/straight-if-use 'centaur-tabs)

;;; debug
(my/straight-if-use 'dape)
(my/straight-if-use 'realgud)

;;; dictionary
(my/straight-if-use 'fanyi)
(my/straight-if-use 'bing-dict)
;; (my/straight-if-use '(youdao-dictionary :type git :host github :repo "xuchunyang/youdao-dictionary.el"))
(my/straight-if-use '(browse-url :type built-in))
(my/straight-if-use '(popweb :type git :host github :repo "manateelazycat/popweb" :files (:defaults "extension/dict" "extension/latex" "extension/org-roam" "extension/url-preview" "*")))
(my/straight-if-use '(websocket-bridge :type git :host github :repo "ginqi7/websocket-bridge"))
(my/straight-if-use '(dictionary-overlay :type git :host github :repo "ginqi7/dictionary-overlay" :files ("*")))
(my/straight-if-use '(baidu-translate :type git :host github :repo "suxiaogang223/baidu-translate"))


;;; lsp-bridge
(unless my/doom-p
  ;; (my/straight-if-use '(lsp-bridge :type git :host github :repo "manateelazycat/lsp-bridge" :files (:defaults "*") :build  (:not compile)))
  (my/straight-if-use '(lsp-bridge :type git :local-repo "~/programs/lsp-bridge" :files (:defaults "*") :build  (:not compile)))
  )
(my/straight-if-use '(acm-terminal :type git :host github :repo "twlz0ne/acm-terminal"))
(my/straight-if-use 'popon)
(my/straight-if-use '(flymake-bridge :type git :host github :repo "liuyinz/flymake-bridge"))

;;; envrc direnv
(my/straight-if-use 'envrc)

;;; elfeed
(my/straight-if-use 'elfeed)
(my/straight-if-use 'elfeed-org)
(my/straight-if-use 'elfeed-goodies)

;;; minuet
(my/straight-if-use 'minuet)

;;; indent-bars
(my/straight-if-use '(indent-bars :type git :host github :repo "jdtsmith/indent-bars"))

;;; claude-code-ide
(my/straight-if-use '(claude-code-ide :type git :host github :repo "manzaltu/claude-code-ide.el"))

;;; persp-mode
(my/straight-if-use 'persp-mode)
(my/straight-if-use 'persp-mode-project-bridge)

;;; web server
;; conflict with simple-httpd, as simple-httpd.el's repo name is also emacs-web-server
;; (my/straight-if-use '(web-server :type git :host github :repo "eschulte/emacs-web-server"))

;;; dired
(my/straight-if-use 'dired-sidebar)
(my/straight-if-use 'ztree)
(my/straight-if-use '(dired-rsync-transient :type git :host github :repo "stsquad/dired-rsync"))

;;; treemacs
(my/straight-if-use '(treemacs :type git :files (:defaults "Changelog.org" "icons" "src/elisp/treemacs*.el" "src/scripts/treemacs*.py" "src/extra/*" "treemacs-pkg.el") :host github :repo "Alexander-Miller/treemacs"))
(my/straight-if-use 'treemacs-evil)
(my/straight-if-use 'treemacs-magit)
(my/straight-if-use 'treemacs-projectile)
(my/straight-if-use 'treemacs-nerd-icons)

;;; everywhere
(my/straight-if-use 'emacs-everywhere)
