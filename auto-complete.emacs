;; -*- coding: utf-8-dos; -*-
(use-package auto-complete
  :ensure t)

;;auto-complete
;;------------------------------------------  
;;插件添加  
;;-----------------------------------------

(require 'auto-complete)
(ac-config-default)
;;自动补全
(require 'auto-complete-config)  
;; (add-to-list 'ac-dictionary-directories   
         ;; "~/.emacs.d/plugins/auto-complete/dict/")  

;; 开启全局设定(包含哪些模式在ac-modes里查看)
(global-auto-complete-mode t)
(ac-config-default)  


(use-package popup
  :ensure t)
(require 'popup)

;;添加一些定义  
;; (add-to-list 'load-path "~/.emacs.d/plugins/yasnippet")  
(use-package yasnippet
  :ensure t)
(require 'yasnippet)  
(yas/global-mode 1)  
;;------------------------------------------  
;;插件添加结束  
;;------------------------------------------
