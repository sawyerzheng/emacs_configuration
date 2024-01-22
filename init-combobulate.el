;; ref: https://www.masteringemacs.org/article/how-to-get-started-tree-sitter
(use-package treesit
  :init
  ;; (defun mp-setup-install-grammars ()
  ;;   "Install Tree-sitter grammars if they are absent."
  ;;   (interactive)
  ;;   (dolist (grammar
  ;;            '((css "https://github.com/tree-sitter/tree-sitter-css")
  ;;              (javascript . ("https://github.com/tree-sitter/tree-sitter-javascript" "master" "src"))
  ;;              (python "https://github.com/tree-sitter/tree-sitter-python")
  ;;              (tsx . ("https://github.com/tree-sitter/tree-sitter-typescript" "master" "tsx/src"))
  ;;              (yaml "https://github.com/ikatyang/tree-sitter-yaml")
  ;;              (java "https://github.com/tree-sitter/tree-sitter-java")
  ;;              (go "https://github.com/tree-sitter/tree-sitter-go")
  ;;              (go-mod "https://github.com/camdencheek/tree-sitter-go-mod")
  ;;              (kotlin "https://github.com/fwcd/tree-sitter-kotlin")
  ;;              (lua "https://github.com/Azganoth/tree-sitter-lua")
  ;;              (rust "https://github.com/tree-sitter/tree-sitter-rust")
  ;;              (haskell "https://github.com/tree-sitter/tree-sitter-haskell")
  ;;              (bash "https://github.com/tree-sitter/tree-sitter-bash")
  ;;              (c "https://github.com/tree-sitter/tree-sitter-c")
  ;;              (c++ "https://github.com/tree-sitter/tree-sitter-cpp")
  ;;              (cmake "https://github.com/uyha/tree-sitter-cmake")
  ;;              (elisp "https://github.com/Wilfred/tree-sitter-elisp")
  ;;              (json "https://github.com/tree-sitter/tree-sitter-json")
  ;;              (csharp "https://github.com/tree-sitter/tree-sitter-c-sharp")
  ;;              (dockerfile "https://github.com/camdencheek/tree-sitter-dockerfile")
  ;;              (typescript "https://github.com/tree-sitter/tree-sitter-typescript")
  ;;              (yaml "https://github.com/ikatyang/tree-sitter-yaml")
  ;;              (toml "https://github.com/ikatyang/tree-sitter-toml")
  ;;              (ruby "https://github.com/tree-sitter/tree-sitter-ruby")
  ;;              ))
  ;;     (add-to-list 'treesit-language-source-alist grammar)
  ;;     ;; Only install `grammar' if we don't already have it
  ;;     ;; installed. However, if you want to *update* a grammar then
  ;;     ;; this obviously prevents that from happening.
  ;;     (unless (treesit-language-available-p (car grammar))
  ;;       (treesit-install-language-grammar (car grammar)))))

  ;; Optional, but recommended. Tree-sitter enabled major modes are
  ;; distinct from their ordinary counterparts.
  ;;
  ;; You can remap major modes with `major-mode-remap-alist'. Note
  ;; that this does *not* extend to hooks! Make sure you migrate them
  ;; also
  ;; (dolist (mapping '((python-mode . python-ts-mode)
  ;;                    (css-mode . css-ts-mode)
  ;;                    (typescript-mode . tsx-ts-mode)
  ;;                    (js-mode . js-ts-mode)
  ;;                    (css-mode . css-ts-mode)
  ;;                    (yaml-mode . yaml-ts-mode)
  ;;                    (java-mode . java-ts-mode)
  ;;                    (go-mode . go-ts-mode)
  ;;                    (go-mod-mode . go-mod-ts-mode)
  ;;                    ;; (lua-mode . lua-ts-mode)
  ;;                    (rust-mode . rust-ts-mode)
  ;;                    (c-mode . c-ts-mode)
  ;;                    (c++-mode . c++-ts-mode)
  ;;                    (cmake-mode . cmake-ts-mode)
  ;;                    ;; (json-mode . json-ts-mode)
  ;;                    (csharp-mode . cshar-ts-mode)
  ;;                    ;; (dockerfile-mode . dockerfile-ts-mode)
  ;;                    (typescript-mode . typescript-ts-mode)
  ;;                    (yaml-mode . yaml-ts-mode)
  ;;                    (toml-mode . toml-ts-mode)
  ;;                    (ruby-mode . ruby-ts-mode)
  ;;                    ))
  ;;   (add-to-list 'major-mode-remap-alist mapping))
  :config
  ;; (mp-setup-install-grammars)
  )

(setq treesit-extra-load-path (list (expand-file-name "straight/build/tree-sitter-langs/bin" user-emacs-directory)))

(use-package combobulate
  :straight (:type git :host github :repo "mickeynp/combobulate")
  :requires (treesit))


;; (setq treesit-language-source-alist
;;       '((bash "https://github.com/tree-sitter/tree-sitter-bash")
;;         (cmake "https://github.com/uyha/tree-sitter-cmake")
;;         (css "https://github.com/tree-sitter/tree-sitter-css")
;;         (elisp "https://github.com/Wilfred/tree-sitter-elisp")
;;         (go "https://github.com/tree-sitter/tree-sitter-go")
;;         (html "https://github.com/tree-sitter/tree-sitter-html")
;;         (javascript "https://github.com/tree-sitter/tree-sitter-javascript" "master" "src")
;;         (json "https://github.com/tree-sitter/tree-sitter-json")
;;         (make "https://github.com/alemuller/tree-sitter-make")
;;         (markdown "https://github.com/ikatyang/tree-sitter-markdown")
;;         (python "https://github.com/tree-sitter/tree-sitter-python")
;;         (toml "https://github.com/tree-sitter/tree-sitter-toml")
;;         (tsx "https://github.com/tree-sitter/tree-sitter-typescript" "master" "tsx/src")
;;         (typescript "https://github.com/tree-sitter/tree-sitter-typescript" "master" "typescript/src")
;;         (yaml "https://github.com/ikatyang/tree-sitter-yaml")))
;; (mapc #'treesit-install-language-grammar (mapcar #'car treesit-language-source-alist))






;; (setq treesit-load-name-override-list '((js "libtree-sitter-js" "tree_sitter_javascript")))



(provide 'init-combobulate)
