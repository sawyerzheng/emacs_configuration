

;;auto-complete
;;------------------------------------------  
;;插件添加  
;;-----------------------------------------

;;自动补全  
(add-to-list 'load-path "~/.emacs.d/plugins/auto-complete/")  
(require 'auto-complete-config)  
(add-to-list 'ac-dictionary-directories   
         "~/.emacs.d/plugins/auto-complete/dict/")  
(ac-config-default)  
(require 'popup)

;;添加一些定义  
(add-to-list 'load-path "~/.emacs.d/plugins/yasnippet")  
(require 'yasnippet)  
(yas/global-mode 1)  
;;------------------------------------------  
;;插件添加结束  
;;------------------------------------------
