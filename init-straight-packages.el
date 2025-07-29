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

;;; vertico
(my/straight-if-use 'vertico)
(my/straight-if-use 'orderless)

;;; consult
(my/straight-if-use 'consult)
(my/straight-if-use 'consult-flycheck)
(my/straight-if-use 'consult-yasnippet)
(my/straight-if-use 'consult-dir)
(my/straight-if-use '(consult-tramp :type git :host github :repo "Ladicle/consult-tramp"))

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

;;; mermaid
(my/straight-if-use 'mermaid-mode)
(my/straight-if-use 'ob-mermaid)
