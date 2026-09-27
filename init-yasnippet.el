;; load snippet tables  -*- coding: utf-8; -*-

(use-package yasnippet
  ;; NOTE: Doom's `:editor snippets' module is authoritative for yasnippet
  ;; setup (it enables `yas-global-mode' and registers `+org-yas-expand-maybe-h'
  ;; on `org-tab-first-hook', so TAB expands & jumps fields in org-mode too).
  ;; This file only (a) adds the private snippet dir and (b) *guarantees*
  ;; yas-minor-mode is on for org-mode buffers even if global mode is off.
  :init
  (defun my/enable-yas-local-fn ()
    ;; ensure yasnippet is loaded before enabling the minor mode
    (require 'yasnippet)
    (yas-minor-mode 1))
  :hook ((prog-mode org-mode) . my/enable-yas-local-fn)
  :commands (my/enable-yas-local-fn
	     yas-minor-mode
	     yas-global-mode)
  :config
  (require 'yasnippet-snippets)
  ;; private snippets (kept, but avoid re-running a full reload that could
  ;; clobber Doom's table):
  (add-to-list 'yas-snippet-dirs "~/.conf.d/custom.d/snippets")
  ;; only reload if yasnippet hasn't already been initialized by Doom
  (unless (bound-and-true-p yas--tables)
    (yas-reload-all))
  )

(use-package auto-yasnippet
  :commands (aya-create
             aya-expand
             aya-expand-from-history
             aya-delete-from-history
             aya-clear-history
             aya-next-in-history
             aya-previous-in-history
             aya-persist-snippet)

  )


(provide 'init-yasnippet)
