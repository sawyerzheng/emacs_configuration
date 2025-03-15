(provide 'init-jump)

(my/straight-if-use 'dumb-jump)
(use-package dumb-jump
  :requires xref
  :hook (prog-mode . my/dumb-jump-add-activate-fn)
  :functions (my/dumb-jump-add-activate-fn)
  :commands (dumb-jump-xref-activate)
  :config
  (setq xref-show-definitions-function #'xref-show-definitions-completing-read)
  (defun my/dumb-jump-add-activate-fn ()
    (add-hook 'xref-backend-functions #'dumb-jump-xref-activate)))

(my/straight-if-use 'ace-pinyin)
(use-package ace-pinyin
  :commands (ace-pinyin-dwim ace-pinyin-jump-word)
  :config
  (setq ace-pinyin--jump-word-timeout 1.5)
  (ace-pinyin-global-mode +1))

(my/straight-if-use 'ace-link)
(use-package ace-link
  :commands (ace-link)
  :init
  (defun my/bind-ace-link ()
    (local-set-key (kbd "o") #'ace-link))
  :hook ((eww-mode
          Info-mode
          grep-mode
	  w3m-mode
          Custom-mode) . my/bind-ace-link))

(my/straight-if-use 'back-button)
(use-package back-button
  :commands (back-button-mode
	     back-button-local-forward
	     back-button-local-forward)
  )
(run-with-idle-timer 2 1 (lambda () (back-button-mode +1)))

(my/straight-if-use 'bm)
(use-package bm
  :commands (bm-toggle
             bm-next
             bm-previous)
  :init
  ;; restore on load (even before you require bm)
  (setq bm-restore-repository-on-load t)
  (global-set-key (kbd "<f2>") nil)
  :config
  ;; Allow cross-buffer 'next'
  (setq bm-cycle-all-buffers t)

  ;; where to store persistant files
  (setq bm-repository-file (expand-file-name "bm-repository" no-littering-var-directory))

  ;; save bookmarks
  (setq-default bm-buffer-persistence t)

  ;; Loading the repository from file when on start up.
  (add-hook 'my/startup-hook 'bm-repository-load)

  ;; Saving bookmarks
  (add-hook 'kill-buffer-hook #'bm-buffer-save)

  ;; Saving the repository to file when on exit.
  ;; kill-buffer-hook is not called when Emacs is killed, so we
  ;; must save all bookmarks first.
  (add-hook 'kill-emacs-hook #'(lambda nil
                                 (bm-buffer-save-all)
                                 (bm-repository-save)))

  ;; The `after-save-hook' is not necessary to use to achieve persistence,
  ;; but it makes the bookmark data in repository more in sync with the file
  ;; state.
  (add-hook 'after-save-hook #'bm-buffer-save)

  ;; Restoring bookmarks
  (add-hook 'find-file-hooks #'bm-buffer-restore)
  (add-hook 'after-revert-hook #'bm-buffer-restore)

  ;; The `after-revert-hook' is not necessary to use to achieve persistence,
  ;; but it makes the bookmark data in repository more in sync with the file
  ;; state. This hook might cause trouble when using packages
  ;; that automatically reverts the buffer (like vc after a check-in).
  ;; This can easily be avoided if the package provides a hook that is
  ;; called before the buffer is reverted (like `vc-before-checkin-hook').
  ;; Then new bookmarks can be saved before the buffer is reverted.
  ;; Make sure bookmarks is saved before check-in (and revert-buffer)
  (add-hook 'vc-before-checkin-hook #'bm-buffer-save)
  :bind (("<f2>" . bm-next)
         ("S-<f2>" . bm-previous)
         ("C-<f2>" . bm-toggle)))

(my/straight-if-use 'imenu-list)
(use-package imenu-list
  :commands (imenu-list-smart-toggle
	     imenu-list))
