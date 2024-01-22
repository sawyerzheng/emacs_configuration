(provide 'init-cns)

(use-package cns
  :straight '(cns :type git :host github :repo "kanglmf/emacs-chinese-word-segmentation"

                  :pre-build (("git" "submodule" "update" "--init" "--recursive") ("make"))
                  :files ("*" "cnws"))
  :commands (cns-auto-enable)
  :hook (my/startup-hook . (lambda ()
                             (if (file-exists-p cns-prog)
                                 (global-cns-mode))))
  :config
  (setq cns-cygwin-shell-path "e:/soft/msys64/usr/bin/bash.exe")
  (setq cns-load-path
        (file-name-directory (locate-library "cns")))
  (setq cns-recent-segmentation-limit 20)
  (setq cns-prog (expand-file-name "cnws" cns-load-path))
  (setq cns-dict-directory (expand-file-name "cppjieba/dict" cns-load-path))
  (defun my/cns-remap-function ()
    (interactive)
    (if cns-mode
        (progn
          (local-set-key [remap forward-word] 'cns-forward-word)
          (local-set-key [remap backward-word] 'cns-backward-word)
          (local-set-key [remap forward-kill-word] 'cns-forward-kill-word)
          (local-set-key [remap backward-kill-word] 'cns-backward-kill-word))
      (progn
        (local-set-key [remap forward-word] nil)
        (local-set-key [remap backward-word] nil)
        (local-set-key [remap forward-kill-word] nil)
        (local-set-key [remap backward-kill-word] nil))))
  (add-hook 'cns-mode-hook #'my/cns-remap-function))

;; ------------------------- hard coded ------------------------------
;; (setq cns-load-path
;;       (expand-file-name "emacs-chinese-word-segmentation" my/program-dir))

;;
;; (use-package cns
;;   :if (lambda () (file-exists-p (expand-file-name "cnws" cns-load-path)))
;;   :load-path cns-load-path
;;   :commands (cns-auto-enable)
;;   :config
;;   (setq cns-recent-segmentation-limit 20)
;;   (setq cns-prog (expand-file-name "cnws" cns-load-path))
;;   (setq cns-dict-directory (expand-file-name "cppjieba/dict" cns-load-path))
;;   (defun my/cns-remap-function ()
;;     (interactive)
;;     (if cns-mode
;;         (progn
;;           (local-set-key [remap forward-word] 'cns-forward-word)
;;           (local-set-key [remap backward-word] 'cns-backward-word)
;;           (local-set-key [remap forward-kill-word] 'cns-forward-kill-word)
;;           (local-set-key [remap backward-kill-word] 'cns-backward-kill-word)
;;           backward-kill-word
;;           )
;;       (progn
;;         (local-set-key [remap forward-word] nil)
;;         (local-set-key [remap backward-word] nil))))
;;   (add-hook 'cns-mode-hook #'my/cns-remap-function))
