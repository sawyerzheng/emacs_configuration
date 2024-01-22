;; -*- coding: utf-8; -*-
(if (>= (string-to-number emacs-version) 27)
    (setq package-enable-at-startup nil))


;; for pin before start `straight'
(setq straight-profiles
      '((nil . "default.el")
        ;; Packages which are pinned to a specific commit.
        (pinned . "pinned.el")))
;; * bootstrap just when straight not installed

;; for emacs 29
(defvar native-comp-deferred-compilation-deny-list nil)

(defvar bootstrap-version)
(let ((bootstrap-file
       (expand-file-name "straight/repos/straight.el/bootstrap.el" user-emacs-directory))
      (bootstrap-version 6))
  (unless (file-exists-p bootstrap-file)
    (with-current-buffer
        (url-retrieve-synchronously
         "https://raw.githubusercontent.com/radian-software/straight.el/develop/install.el"
         'silent 'inhibit-cookies)
      (goto-char (point-max))
      (eval-print-last-sexp)))
  (load bootstrap-file nil 'nomessage))

;; (defvar bootstrap-version)
;; (let ((bootstrap-file
;;        (expand-file-name "straight/repos/straight.el/bootstrap.el" user-emacs-directory))
;;       (bootstrap-version 5))
;;   (unless (file-exists-p bootstrap-file)
;;     (with-current-buffer
;;         (url-retrieve-synchronously
;;          "https://raw.githubusercontent.com/radian-software/straight.el/develop/install.el"
;;          'silent 'inhibit-cookies)
;;       (goto-char (point-max))
;;       (eval-print-last-sexp)))
;;   (load bootstrap-file nil 'nomessage))

;; options
(when (string-match-p (regexp-quote "NATIVE_COMP") system-configuration-features) ;;(functionp 'native-compile)
  (progn
    (add-to-list 'native-comp-eln-load-path (concat user-emacs-directory ".cache/eln/"))
    (setq package-native-compile t)
    (setq straight-disable-native-compile nil)))

;; (setq straight-vc-git-default-clone-depth 1)

;; for pin after start straight
(autoload #'straight-x-pull-all "straight-x")
(autoload #'straight-x-freeze-versions "straight-x")
(autoload #'straight-x-freeze-pinned-versions "straight-x")
(autoload #'straight-x-thaw-pinned-versions "straight-x")
;;--------------------------------- end of straight itself ---------------

;; * when to check(straight-use-package)
;; (setq straight-check-for-modifications '(check-on-save))
;; (setq straight-check-for-modifications nil)
;; ------------------------------------------------------------------------
(defun my-straight-pin (cons-cell)
  (add-to-list 'straight-x-pinned-packages cons-cell))

;; * declare pinned packages
(defun my-straight-make-sure-freeze-packages ()
  "freeze pinned and thaw pinned again, to make sure using pinned packages"
  (interactive)


  (let ((straight-current-profile 'pinned))

    ;; Pin org-mode version.
    (my-straight-pin '("conda" . "78e1aad076f6cefc6aa7cc77d08e174b13050994"))
    ;; (my-straight-pin
    ;;  '("lsp-bridge" .
    ;;    ;; "137ba780623f88c2911694c0a26e357631e2dab6"
    ;;    ;; "c3dea2a16b8aec4e22fc9e3ffc62ee40d3c905e6"
    ;;    ;; "5dc54efc85ce4188664b539c40ff0f22188efe65"

    ;;    "ddfe463cf6ed2dc5c8528b18529a55ea0174b71f" ;; window10 usable
    ;;    ;; "19a20c95878ec0ba98581af20052b363fa3f9868"
    ;;   "b526ed024f1dac9283256785f5082b2cc66cca66";; tested: 20240122
    ;;    )
    ;;  )
    (my-straight-pin '("xah-fly-keys" . "5347be6e3165c74d9edc2a84010c2099f0620388"))
    (my-straight-pin '("pyim" .
                       ;; "6b4cea1b541f5efd18067d4cafa1ca4b059a0c63"
                       "35315cf9fd554bb652961e5a8a8ebbafc3566d2e"
                       ))
    (my-straight-pin '("lispy" . "df1b7e614fb0f73646755343e8892ddda310f427"))
    (my-straight-pin '("compat" . "d18d6c90da6b1b32004af55976e23c181704a23f"))
    )

  (straight-x-freeze-pinned-versions)
  (straight-x-thaw-pinned-versions))

;; (global-set-key (kbd "C-h r f") #'my-straight-make-sure-freeze-packages)


(provide 'init-straight)
