;;-*- coding: utf-8; -*-
;; packages================================================  

;; for melpa, gnu package urls
(load-file "~/.conf.d/packages.emacs")


(package-initialize)

;; load path
(add-to-list 'load-path "~/.conf.d/extra.d/")

;;=================== end of packages ======================

;;================ default initializations =================

;;------------- completing ui packages. ----------
;; (load-file "~/.conf.d/ido.emacs")
;; (load-file "~/.conf.d/ivy.emacs")
;;------------------------------------------------

;;----------- doc and help packages. -------------
(load-file "~/.conf.d/zeal.emacs")
(load-file "~/.conf.d/devdocs.emacs")
(load-file "~/.conf.d/dictionary.emacs")
;;------------------------------------------------

(load-file "~/.conf.d/java.emacs")

(load-file "~/.conf.d/eww.emacs")
;;(load-file "~/.conf.d/myelisp.emacs")
;; (load-file "~/.conf.d/themes.emacs")
(load-file "~/.conf.d/org.emacs")
;;(load-file "~/.conf.d/eim.emacs")
(load-file "~/.conf.d/auto-complete.emacs")
(load-file "~/.conf.d/html.emacs")
(load-file "~/.conf.d/emacsclient.emacs")
(load-file "~/.conf.d/python3.emacs")
(load-file "~/.conf.d/run_code.emacs")
(load-file "~/.conf.d/yasnippet.emacs")
(load-file "~/.conf.d/tramp.emacs")
(load-file "~/.conf.d/edit-server.emacs")
(load-file "~/.conf.d/dired.emacs")
(load-file "~/.conf.d/dired-x.emacs")
(load-file "~/.conf.d/openfile.emacs")
;;(load-file "~/.conf.d/ein.emacs")
(load-file "~/.conf.d/pyim.emacs")
(load-file "~/.conf.d/dired+.emacs")
(load-file "~/.conf.d/elpy.emacs")
(load-file "~/.conf.d/web-mode.emacs")
(load-file "~/.conf.d/tsv.emacs")
(load-file "~/.conf.d/ace-window.emacs")
(load-file "~/.conf.d/projectile.emacs")
(load-file "~/.conf.d/ansi-color.emacs")
;; "~/.conf.d/extra.d/nc.el" to beautify dired

(load-file "~/.conf.d/docker.emacs")
(autoload 'nc "nc" "Emulate MS-DOG file shell" t)

;;================= global key binding ================
;;  * full screen
(global-set-key (kbd "M-<f11>") 'toggle-frame-fullscreen)
(global-set-key (kbd "C-s-f") 'toggle-frame-fullscreen)
;;  * maximizing
(global-set-key (kbd "M-<f10>") 'toggle-frame-maximized)
(global-set-key (kbd "C-<f10>") 'menu-bar-open)
(global-set-key (kbd "<f12>") 'xah-open-in-external-app)

;;================= global code style ===============
(setq c-default-style '((java-mode . "java") (awk-mode . "awk") (other . "gnu")))


;;================= input methods ======================
(setq default-input-method 'pyim)

;;================ code line number mode ================
;;(global-linum-mode 1) ; always show line numbers 
(setq linum-format "%2d| ")  ;set format

;;=============== program-mode =====================
;; add line mode hook for program-mode
(add-hook 'prog-mode-hook '(lambda ()
			     "enable line number mode"
;;			     (local-set-key (kbd "C-S-o") 'open-newline-forword)
			     (linum-mode 1)
			     (subword-mode 1)
			     (whitespace-cleanup-mode 1)))

;;============== splash screen =================
(setq inhibit-startup-screen t)

;;====================== search ===============
(global-set-key (kbd "C-S-s") 'isearch-forward-symbol-at-point)
;; C-s C-w
;; search more under cursor.
