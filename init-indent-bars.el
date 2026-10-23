;; -*- coding: utf-8; -*-
;; indent-bars 开启 treesit 支持后，会 buffer-locally 把
;; `font-lock-fontify-region-function' 换成 `indent-bars--fontify'，并用
;; `indent-bars--font-lock-inhibit' 做门禁：只有带 `indent-bars-font-lock-pending'
;; 属性的区域才真正调用 font-lock。该属性只由 jit-lock 的变更路径
;; （`indent-bars-ts--mark-change' / `indent-bars-ts--flush' /
;; `indent-bars-ts--fontify-buffer'）写入。
;;
;; org-src 在隐藏缓冲 " *org-src-fontification:*" 里 erase-buffer + insert 后
;; 直接调 `font-lock-ensure'，既无变更事件也无该属性，门禁判定为「抑制」，
;; 于是 treesit 语法高亮从不执行 —— 表现为 org 代码块只剩余 `org-block' 底色。
;; 这些内部缓冲不显示缩进导引，直接不启用 indent-bars 即可。
(defun my/indent-bars-maybe ()
  "Enable `indent-bars-mode', except in internal (space-named) buffers.
Buffers whose name starts with a space are font-lock's internal buffers
\(e.g. org-src's ` *org-src-fontification:*'), where indent-bars would
hijack `font-lock-fontify-region-function' and suppress real fontification."
  (unless (string-prefix-p " " (buffer-name))
    (indent-bars-mode 1)))

(use-package indent-bars
  ;; :hook ((python-mode yaml-mode) . indent-bars-mode)
  :hook (prog-mode . my/indent-bars-maybe)
  :bind ("C-c u i" . indent-bars-mode)
  :config
  (require 'indent-bars-ts) 		; not needed with straight
  (setq indent-bars-width-frac 0.1)
  ;; (setq
  ;;  indent-bars-color '(highlight :face-bg t :blend 0.2)
  ;;  indent-bars-pattern "."
  ;;  indent-bars-width-frac 0.1
  ;;  indent-bars-pad-frac 0.1
  ;;  indent-bars-zigzag nil
  ;;  indent-bars-color-by-depth nil
  ;;  indent-bars-highlight-current-depth nil
  ;;  indent-bars-display-on-blank-lines nil)

  (setq
   indent-bars-color '(highlight :face-bg t :blend 0.15)
   indent-bars-pattern "."
   indent-bars-width-frac 0.13
   indent-bars-pad-frac 0.1
   indent-bars-zigzag nil
   indent-bars-color-by-depth '(:regexp "outline-\\([0-9]+\\)" :blend 1) ; blend=1: blend with BG only
   indent-bars-highlight-current-depth '(:blend 0.5) ; pump up the BG blend on current
   indent-bars-display-on-blank-lines t)
  :custom
  (indent-bars-treesit-support t)
  (indent-bars-treesit-ignore-blank-lines-types '("module"))
  ;; Add other languages as needed
  (indent-bars-treesit-scope '((python function_definition class_definition for_statement
	                        if_statement with_statement while_statement)))
  ;; wrap may not be needed if no-descend-list is enough
  ;;(indent-bars-treesit-wrap '((python argument_list parameters ; for python, as an example
  ;;				      list list_comprehension
  ;;				      dictionary dictionary_comprehension
  ;;				      parenthesized_expression subscript)))
  :hook ((python-base-mode yaml-mode) . my/indent-bars-maybe)
  :hook (prog-mode . my/indent-bars-maybe)
  )


(provide 'init-indent-bars)
