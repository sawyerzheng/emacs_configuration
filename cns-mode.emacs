;; -*- coding: utf-8; -*-
;; source: https://github.com/kanglmf/emacs-chinese-word-segmentation

;; linux
(if (eq system-type 'gnu/linux)
    ;; (if (equal system-name "spider")
    ;;	(setq my-cns-prefix "/home/sawyer/programes/emacs-chinese-word-segmentation")
    ;;   (setq my-cns-prefix "/home/sawyer/backup.d/emacs-chinese-word-segmentation/emacs-chinese-word-segmentation")
    (progn
      (setq my-cns-prefix "/home/sawyer/programs/emacs-chinese-word-segmentation")
      (setq cns-prog (concat my-cns-prefix "/chinese-word-segmentation")))
  )
;; macOS
(if (eq system-type 'darwin)
    (progn
      (setq my-cns-prefix "/Users/sawyer/programs/emacs-chinese-word-segmentation")
      (setq cns-prog (concat my-cns-prefix "/chinese-word-segmentation"))))

;; (concat my-cns-prefix "")


;; windows
(if (equal system-type 'windows-nt)
    (progn
      (setq my-cns-prefix "d:/programs/emacs-chinese-word-segmentation")
      (setq cns-prog (concat my-cns-prefix "/chinese-word-segmentation.exe"))
      ))

;; cygwin
(if (equal system-type 'cygwin)
    (progn
      (setq my-cns-prefix "/d/programs/emacs-chinese-word-segmentation")
      (setq cns-prog (concat my-cns-prefix "/chinese-word-segmentation.exe"))
      ))

(setq cns-dict-directory (concat my-cns-prefix "/dict"))
(add-to-list 'load-path my-cns-prefix)
(setq cns-recent-segmentation-limit 20) ; default is 10
(setq cns-debug nil) ; disable debug output, default is t
(require 'cns nil t)
(when (featurep 'cns)
  (add-hook 'find-file-hook 'cns-auto-enable))


;; enable globally
;; (global-cns-mode)
