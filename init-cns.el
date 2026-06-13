(provide 'init-cns)

(use-package cns
  :commands (cns-auto-enable)
  ;; :hook (my/startup-hook . (lambda ()
  ;;                            (if (file-exists-p cns-prog)
  ;;                                (global-cns-mode))))
  ;;
  :hook (after-change-major-mode . cns-auto-enable)
  :after (files)
  ;; :hook (find-file . cns-auto-enable)
  :config
  ;; (setq cns-cygwin-shell-path "e:/soft/msys64/usr/bin/bash.exe")
  ;; (setq cns-load-path
  ;;       (file-name-directory (locate-library "cns")))
  ;; (setq cns-recent-segmentation-limit 20)
  ;; (setq cns-prog (expand-file-name "cnws" cns-load-path))
  ;; (setq cns-dict-directory (expand-file-name "cppjieba/dict" cns-load-path))
  (setq cns-process-type 'shell)
  (setq cns-load-path
        (file-name-directory (locate-library "cns")))
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
  (add-hook 'cns-mode-hook #'my/cns-remap-function)

  (let ((pkg-dir cns-load-path)
        (cnws-bin (expand-file-name "cnws" cns-load-path)))
    (unless (file-executable-p cnws-bin)
      (message "cns: cnws not found, building...")
      (let ((default-directory pkg-dir))
        (let ((ret1 (shell-command "git submodule update --init --recursive")))
          (if (zerop ret1)
              (let ((ret2 (shell-command "make")))
                (if (zerop ret2)
                    (message "cns: build succeeded -> %s" cnws-bin)
                  (error "cns: make failed (exit %d)" ret2)))
            (error "cns: git submodule update failed (exit %d)" ret1))))))


  ;; evil
  (with-eval-after-load 'evil
    (defun my/cns-or-evil-forward-word (count)
      (interactive "p")
      (if (bound-and-true-p cns-mode)
          (dotimes (_ count) (cns-forward-word))
        (evil-forward-word-begin count)))

    (defun my/cns-or-evil-backward-word (count)
      (interactive "p")
      (if (bound-and-true-p cns-mode)
          (dotimes (_ count) (cns-backward-word))
        (evil-backward-word-begin count)))

    (evil-define-key '(normal motion visual) 'global
      "w" #'my/cns-or-evil-forward-word
      "b" #'my/cns-or-evil-backward-word
      ;; e has no dedicated cns equivalent, falls back
      "e" (lambda (count)
            (interactive "p")
            (if (bound-and-true-p cns-mode)
                (dotimes (_ count) (cns-forward-word))
              (evil-forward-word-end count)))))
  )

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
