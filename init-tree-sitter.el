(use-package tree-sitter
  :straight t
  :hook ((python-mode . tree-sitter-mode))
  :config
  (add-to-list 'tree-sitter-load-path (expand-file-name "tree-sitter-bin" my/program-dir))
  (add-to-list 'tree-sitter-major-mode-language-alist '(emacs-lisp-mode . elisp))

  (use-package tree-sitter-debug
    :straight nil
    :defer t)
  (use-package tree-sitter-query
    :straight nil
    :defer t))

(use-package tree-sitter-hl
  :straight nil
  :hook ((python-mode java-mode) . tree-sitter-hl-mode))

;; install parsers : `tree-sitter-langs-install-grammars'
(use-package tree-sitter-langs
  :straight t
  :commands (tree-sitter-langs-install-grammars))

(provide 'init-tree-sitter)
