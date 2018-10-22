;; packages================================================
(package-initialize)

(when (>= emacs-major-version 24)
  (require 'package)
  (add-to-list
   'package-archives
   ;; '("melpa" . "http://stable.melpa.org/packages/") ; many packages won't show if using stable
   '("melpa" . "http://melpa.milkbox.net/packages/")
   t))
;;=================== end of packages ======================

;;================ default initializations =================
(load-file "~/.conf.d/eww.emacs")
(load-file "~/.conf.d/dictionary.emacs")
(load-file "~/.conf.d/org.emacs")
(load-file "~/.conf.d/eim.emacs")
(load-file "~/.conf.d/auto-complete.emacs")
(load-file "~/.conf.d/html.emacs")

;;================= global key binding ================
;;  * full screen
(global-set-key (kbd "M-<f11>") 'toggle-frame-fullscreen)
(global-set-key (kbd "C-s-f") 'toggle-frame-fullscreen)
;;  * maximizing
(global-set-key (kbd "M-<f10>") 'toggle-frame-maximized)

;;================= input methods ======================
(setq default-input-method 'eim-py)

;;================ code line number mode ================
;;(global-linum-mode 1) ; always show line numbers 
(setq linum-format "%2d| ")  ;set format


;;================  for SUDO actions ==============
(require 'tramp)
;; emxaples
;; /sudo::/etc/bashrc

