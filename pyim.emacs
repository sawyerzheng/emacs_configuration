;; -*- coding: utf-8; -*-

(use-package pyim
  :ensure t)
(use-package pyim-basedict
  :ensure t) ; 拼音词库设置，五笔用户 *不需要* 此行设置

(pyim-basedict-enable)   ; 拼音词库，五笔用户 *不需要* 此行设置
(setq default-input-method "pyim")

(use-package pyim
  :ensure nil
  :demand t
  :config
  ;; 激活 basedict 拼音词库，五笔用户请继续阅读 README
  (use-package pyim-basedict
    :ensure nil
    :config (pyim-basedict-enable))

  (setq default-input-method "pyim")

  ;; 我使用全拼
;;  (setq pyim-default-scheme 'quanpin)

  ;; 设置 pyim 探针设置，这是 pyim 高级功能设置，可以实现 *无痛* 中英文切换 :-)
  ;; 我自己使用的中英文动态切换规则是：
  ;; 1. 光标只有在注释里面时，才可以输入中文。
  ;; 2. 光标前是汉字字符时，才能输入中文。
  ;; 3. 使用 M-j 快捷键，强制将光标前的拼音字符串转换为中文。
  (setq-default pyim-english-input-switch-functions
                '(pyim-probe-dynamic-english
                  pyim-probe-isearch-mode
                  pyim-probe-program-mode
                  pyim-probe-org-structure-template))

  (setq-default pyim-punctuation-half-width-functions
                '(pyim-probe-punctuation-line-beginning
                  pyim-probe-punctuation-after-punctuation))

  ;; 开启拼音搜索功能
  (pyim-isearch-mode 1)

  ;; 使用 pupup-el 来绘制选词框, 如果用 emacs26, 建议设置
  ;; 为 'posframe, 速度很快并且菜单不会变形，不过需要用户
  ;; 手动安装 posframe 包。
  (setq pyim-page-tooltip 'popup)

  ;; 选词框显示5个候选词
  (setq pyim-page-length 5)

  :bind
  (("M-j" . pyim-convert-string-at-point) ;与 pyim-probe-dynamic-english 配合
   ("C-;" . pyim-delete-word-from-personal-buffer)))

(add-hook 'c-mode-common-hook
	  '(lambda ()
	     (local-unset-key (kbd "M-j"))
	     (local-set-key (kbd "M-j") 'pyim-convert-string-at-point))
	  )

;; (global-set-key (kbd "M-f") 'pyim-forward-word)
;; (global-set-key (kbd "M-b") 'pyim-backward-word)

(setq pyim-dicts
      '((:name "myown" :file "~/home/backup.d/pinyin_dict/personal_dict.txt")
	(:name "dict_someclassmate" :file "~/home/backup.d/pinyin_dict/pyim-bigdict.pyim")
	(:name "all_in_one" :file "~/home/backup.d/pinyin_dict/profession_all_in_one_dict.txt")))


;; 模糊音
(setq pyim-fuzzy-pinyin-alist
      '(("in" "ing")
	("s" "sh")
	("z" "zh")
	("c" "ch")))

;; 翻页键
(define-key pyim-mode-map "." 'pyim-page-next-page)
(define-key pyim-mode-map "," 'pyim-page-previous-page)

;; 选择第二个快捷键 ";" 
(define-key pyim-mode-map ";"
  (lambda ()
    (interactive)
    (pyim-page-select-word-by-number 2)))

(define-minor-mode my-pyim-forward-mode
  "Minor mode to keymap `M-f' to `pyim-forward-word'"
  :init-value nil
  ;; (interactive (list (or current-prefix-arg 'toggle)))
  ;; (let ((enable
  ;; 	 (if (eq arg 'toggle)
  ;; 	     (not foo-mode) ; this is the mode’s mode variable
  ;; 	   (> (prefix-numeric-value arg) 0))))
  ;;   ))
  ;; :keymap
  ;; `((,(kbd "M-f") . 'pyim-forward-word)
    ;; (,(kbd "M-b") . 'pyim-backward-word))
  )

(defvar my-pyim-forward-mode-map (make-keymap))
(define-key my-pyim-forward-mode-map (kbd "M-f") 'pyim-forward-word)
(define-key my-pyim-forward-mode-map (kbd "M-b") 'pyim-backward-word)
