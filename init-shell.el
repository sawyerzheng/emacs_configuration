;; -*- coding: utf-8; -*-
(use-package bash-completion
  :commands (bash-completion-dynamic-complete)
  :config
  (add-hook 'shell-dynamic-complete-functions
	    'bash-completion-dynamic-complete))

(use-package fish-mode
  :straight t
  :commands (fish-mode)
  :mode (("\\.fish\\'" . fish-mode)
         ("/fish_funced\\..*\\'" . fish-mode)))

;; (use-package fish-completion
;;   :after shell
;;   :hook (shell-mode . global-fish-completion-mode)
;;   :custom
;;   (fish-completion-fallback-on-bash-p t))


(use-package vterm
  :straight t
  :if (not my/windows-p)
  :commands (vterm vterm-module-compile)
  :config
  :custom (vterm-always-compile-module t)
  )

(use-package pcmpl-args
  :straight t)

(use-package eat
  :straight '(:type git :host codeberg :repo "akib/emacs-eat" :files ("*.el" ("term" "term/*.el") "*.texi"
                                                                      "*.ti" ("terminfo/e" "terminfo/e/*")
                                                                      ("terminfo/65" "terminfo/65/*")
                                                                      ("integration" "integration/*")
                                                                      (:exclude ".dir-locals.el" "*-tests.el")))
  :commands (eat eat-other-window)
  :config
  ;; * hack for doom theme
  ;; ** doom-vibrant
  ;; change base0 first element to #555f70
  )

(provide 'init-shell)
