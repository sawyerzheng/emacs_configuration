(provide 'init-tabnine)

(use-package tabnine-capf
  :after cape
  :commands (tabnine-capf-install-binary
             tabnine-capf-restart-server
             tabnine-capf-install-binary)
  :straight (:host github :repo "50ways2sayhard/tabnine-capf" :files ("*.el" "*.sh"))
  :hook (kill-emacs . tabnine-capf-kill-process)
  :config
  (add-to-list 'completion-at-point-functions #'tabnine-completion-at-point))
