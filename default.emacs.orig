;; packages================================================
(package-initialize)

;; load path
(add-to-list 'load-path "~/.conf.d/extra.d/")

(when (>= emacs-major-version 24)
  (require 'package)
  (add-to-list
   'package-archives
   ;; '("melpa" . "http://stable.melpa.org/packages/") ; many packages won't show if using stable
   ;; '("melpa" . "http://melpa.milkbox.net/packages/")
   '("melpa" . "http://elpa.emacs-china.org/melpa/")
   ;;'("gnu"   . "http://elpa.emacs-china.org/gnu/")
   t))
;;=================== end of packages ======================

;;================ default initializations =================
(load-file "~/.conf.d/eww.emacs")
(load-file "~/.conf.d/dictionary.emacs")
(load-file "~/.conf.d/org.emacs")
(load-file "~/.conf.d/eim.emacs")
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
;;(load-file "~/.conf.d/dired+.emacs")
;; "~/.conf.d/extra.d/nc.el" to beautify dired
(autoload 'nc "nc" "Emulate MS-DOG file shell" t)

;;================= global key binding ================
;;  * full screen
(global-set-key (kbd "M-<f11>") 'toggle-frame-fullscreen)
(global-set-key (kbd "C-s-f") 'toggle-frame-fullscreen)
;;  * maximizing
(global-set-key (kbd "M-<f10>") 'toggle-frame-maximized)
(global-set-key (kbd "C-<f10>") 'menu-bar-open)

;;================= input methods ======================
(setq default-input-method 'eim-py)

;;================ code line number mode ================
;;(global-linum-mode 1) ; always show line numbers 
(setq linum-format "%2d| ")  ;set format

;;=============== program-mode =====================
;; add line mode hook for program-mode
(add-hook 'prog-mode-hook '(lambda ()
			     "enable line number mode"
			     (linum-mode t)))
