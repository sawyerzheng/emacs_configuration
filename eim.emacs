
;;eim Chinese input method
(add-to-list 'load-path "~/.emacs.d/site-lisp/eim")
(autoload 'eim-use-package "eim" "Another emacs input method")
;; Tooltip 暂时还不好用
(setq eim-use-tooltip nil)

(setq default-input-method 'eim-py)

;;================= input method key binding ===========
(global-set-key "\C-cl" 'toggle-input-method)
(global-set-key "\C-c\C-l" 'toggle-input-method)
(global-set-key "\C-c\\" 'toggle-input-method)

(register-input-method
 "eim-wb" "euc-cn" 'eim-use-package
 "五笔" "汉字五笔输入法" "wb.txt")
(register-input-method
 "eim-py" "euc-cn" 'eim-use-package
 "拼音" "汉字拼音输入法" "py.txt")

;; 用 ; 暂时输入英文
(require 'eim-extra)
(global-set-key ";" 'eim-insert-ascii)

;;<<<<<======== test --- 2018.10.09 10.05
;;(set-input-method 'eim-py)

(defun my-chinese-setup ()
  "Set up my private Chinese environment."
  (if (equal current-language-environment "Chinese-GB")
      (setq default-input-method "eim-py")))
(defun my-chinese-setup-1 ()
  "Set up my private Chinese environment."
  (if (equal current-language-environment "UTF-8")
      (setq default-input-method "eim-py")))

(add-hook 'set-language-environment-hook 'my-chinese-setup)
(add-hook 'set-language-environment-hook 'my-chinese-setup-1)

