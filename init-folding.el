(provide 'init-folding)



(defcustom +fold-ellipsis " [...] "
  "The ellipsis to show for ellided regions (folds).

`org-ellipsis', `truncate-string-ellipsis', and `ts-fold-replacement' are set to
this."
  :type 'string
  :group '+fold)

(defface +fold-hideshow-folded-face
  `((t (:inherit font-lock-comment-face :weight light)))
  "Face to hightlight `hideshow' overlays."
  :group 'doom-themes)


(require 'doom-lib)
(require 'doom-fold-hideshow)
(require 'doom-fold-fold)
(use-package doom-fold-fold
  :bind (("C-c z z" . +fold/toggle)
	 ("C-c z c" . +fold/close)
	 ("C-c z o" . +fold/open)
	 ("C-c z O" . +fold/open-all)
	 ("C-c z C" . +fold/close-all)
	 ("C-c z r" . +fold/open-rec)
	 ("C-c z n" . +fold/next)
	 ("C-c z p" . +fold/previous)
	 ("C-<return>" . +fold/toggle)
	 ("C-S-<return>" . +fold/close-all)
	 ("C-M-<return>" . +fold/open-all)
	 ))

(use-package hideshow                   ; built-in
  :if (not (member 'init-treesit features))
  :demand t
  :commands (hs-toggle-hiding
             hs-hide-block
             hs-hide-level
             hs-show-all
             hs-hide-all)
  :config

  ;;               ("C-<return>" . hs-toggle-hiding)
  ;;               ("C-S-<return>" . hs-show-all)
  ;;               ;; ("C-M-<return>" . hs-hide-all)
  ;;               ("C-M-<return>" . hs-hide-leafs)

  (define-key prog-mode-map (kbd "C-<return>") #'+fold/toggle)
  (define-key prog-mode-map (kbd "C-S-<return>") #'+fold/close-all)
  (define-key prog-mode-map (kbd "C-M-<return>") #'+fold/open-all)

  (global-set-key (kbd "C-c z z") #'+fold/toggle)
  (global-set-key (kbd "C-c z c") #'+fold/close)
  (global-set-key (kbd "C-c z o") #'+fold/open)
  (global-set-key (kbd "C-c z O") #'+fold/open-all)
  (global-set-key (kbd "C-c z C") #'+fold/close-all)
  (global-set-key (kbd "C-c z r") #'+fold/open-rec)
  ;; [remap evil-toggle-fold]   #'+fold/toggle
  ;; [remap evil-close-fold]    #'+fold/close
  ;; [remap evil-open-fold]     #'+fold/open
  ;; [remap evil-open-fold-rec] #'+fold/open-rec
  ;; [remap evil-close-folds]   #'+fold/close-all
  ;; [remap evil-open-folds]    #'+fold/open-all)

  (setq hs-hide-comments-when-hiding-all nil
        ;; Nicer code-folding overlays (with fringe indicators)
        hs-set-up-overlay #'+fold-hideshow-set-up-overlay-fn)

  (defadvice! +fold--hideshow-ensure-mode-a (&rest _)
    "Ensure `hs-minor-mode' is enabled when we need it, no sooner or later."
    :before '(hs-toggle-hiding hs-hide-block hs-hide-level hs-show-all hs-hide-all)
    (+fold--ensure-hideshow-mode))


  ;; extra folding support for more languages
  (unless (assq 't hs-special-modes-alist)
    (setq hs-special-modes-alist
          (append
           '((vimrc-mode "{{{" "}}}" "\"")
             (yaml-mode "\\s-*\\_<\\(?:[^:]+\\)\\_>"
                        ""
                        "#"
                        +fold-hideshow-forward-block-by-indent-fn nil)
             (haml-mode "[#.%]" "\n" "/" +fold-hideshow-haml-forward-sexp-fn nil)
             (ruby-mode "class\\|d\\(?:ef\\|o\\)\\|module\\|[[{]"
                        "end\\|[]}]"
                        "#\\|=begin"
                        ruby-forward-sexp)
             (matlab-mode "if\\|switch\\|case\\|otherwise\\|while\\|for\\|try\\|catch"
                          "end"
                          nil (lambda (_arg) (matlab-forward-sexp)))
             (nxml-mode "<!--\\|<[^/>]*[^/]>"
                        "-->\\|</[^/>]*[^/]>"
                        "<!--" sgml-skip-tag-forward nil)
             (latex-mode
              ;; LaTeX-find-matching-end needs to be inside the env
              ("\\\\begin{[a-zA-Z*]+}\\(\\)" 1)
              "\\\\end{[a-zA-Z*]+}"
              "%"
              (lambda (_arg)
                ;; Don't fold whole document, that's useless
                (unless (save-excursion
                          (search-backward "\\begin{document}"
                                           (line-beginning-position) t))
                  (LaTeX-find-matching-end)))
              nil))
           hs-special-modes-alist
           '((t))))))

(my/straight-if-use '(ts-fold :type git :host github :repo "emacs-tree-sitter/ts-fold"))
(with-eval-after-load 'treesit
  (use-package ts-fold
    :after (init-treesit)
    ;; :after (tree-sitter init-treesit)
    :demand t
    :config
    (setq ts-fold-replacement +fold-ellipsis)
    (global-ts-fold-mode +1))
  )



;; (use-package yafolding
;;   :straight t
;;   :hook (python-mode . yafolding-mode))

;; (use-package origami
;;   :straight (:type git :host github :repo "elp-revive/origami.el")
;;   :bind (:map origami-mode-map
;;               ("C-<return>" . origami-recursively-toggle-node)
;;               ("C-S-<return>" . origami-close-node-recursively)
;;               ("C-M-<return>" . origami-toggle-all-nodes))
;;   :hook ((prog-mode) . origami-mode)
;;   )

;; (use-package hideshow
;;   :bind (:map hs-minor-mode-map
;;               ("C-<return>" . hs-toggle-hiding)
;;               ("C-S-<return>" . hs-show-all)
;;               ;; ("C-M-<return>" . hs-hide-all)
;;               ("C-M-<return>" . hs-hide-leafs)
;;               )
;;   :hook ((python-base-mode) . hs-minor-mode)
;;   :commands (hs-hide-leafs)
;;   :config
;;   (defun hs-hide-leafs ()
;;     "Hide all blocks in the buffer that do not contain subordinate
;;     blocks.  The hook `hs-hide-hook' is run; see `run-hooks'."
;;     (interactive)
;;     (hs-life-goes-on
;;      (save-excursion
;;        (message "Hiding blocks ...")
;;        (save-excursion
;;          (goto-char (point-min))
;;          (hs-hide-leafs-recursive (point-min) (point-max)))
;;        (message "Hiding blocks ... done"))
;;      (run-hooks 'hs-hide-hook)))

;;   (defun hs-hide-leafs-recursive (minp maxp)
;;     "Hide blocks below point that do not contain further blocks in
;;     region (MINP MAXP)."
;;     (when (hs-find-block-beginning)
;;       (setq minp (1+ (point)))
;;       (funcall hs-forward-sexp-func 1)
;;       (setq maxp (1- (point))))
;;     (unless hs-allow-nesting
;;       (hs-discard-overlays minp maxp))
;;     (goto-char minp)
;;     (let ((leaf t))
;;       (while (progn
;;                (forward-comment (buffer-size))
;;                (and (< (point) maxp)
;;                     (re-search-forward hs-block-start-regexp maxp t)))
;;         (setq pos (match-beginning hs-block-start-mdata-select))
;;         (if (hs-hide-leafs-recursive minp maxp)
;;             (save-excursion
;;               (goto-char pos)
;;               (hs-hide-block-at-point t)))
;;         (setq leaf nil))
;;       (goto-char maxp)
;;       leaf)))
