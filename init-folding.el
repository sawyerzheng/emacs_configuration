(provide 'init-folding)

;; (use-package yafolding
;;   :straight t
;;   :hook (python-mode . yafolding-mode))

(use-package origami
  :straight (:type git :host github :repo "elp-revive/origami.el")
  :bind (:map origami-mode-map
              ("C-<return>" . origami-recursively-toggle-node)
              ("C-S-<return>" . origami-close-node-recursively)
              ("C-M-<return>" . origami-toggle-all-nodes))
  :hook ((prog-mode) . origami-mode)
  )

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
