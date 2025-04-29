;; -*- coding: utf-8; -*-


(unless my/windows-p
  (my/straight-if-use `(liberime
                          :pre-build ,(pcase system-type
                                        (`gnu/linux '("make"))
                                        (`widnows-nt '(message "liberime can not be made on windows"))
                                        ;; (_ '("make"))
                                        ))))



(my/straight-if-use 'liberime)
(use-package liberime
  :commands (liberime-build liberime-sync liberime-load liberime-deploy)
  :after pyim
  :config
  (setq liberime-user-data-dir (expand-file-name "rime" no-littering-var-directory))
  :init
  (setq liberime-user-data-dir (expand-file-name "rime" no-littering-var-directory))

  (if (eq system-type 'windows-nt)
      ;; nil ;; 手动复制官方 Release zip 文件到 emacs 安装目录： https://github.com/merrickluo/liberime/releases
      ;; (setq liberime-module-file "d:/soft/emacs/emacs-28.1/bin/liberime-core.dll")
      (setq liberime-module-file "E:/soft/msys64/ucrt64/bin/liberime-core.dll")
    (setq liberime-module-file "d:/soft/emacs/emacs-29.1_1/emacs-29.1_1/bin/liberime-core.dll")

    ;; (setq liberime-module-file "D:/soft/emacs/emacs-28.1-NATIVE_FULL_AOT/bin/liberime-core.dll")
    ;; (progn (add-to-list 'load-path
    ;;                     ;; "e:/soft/msys64/mingw64/share/emacs/site-lisp/"
    ;;                     "d:/programs/liberime"
    ;;                     )
    ;;        (setq liberime-module-file "d:/programs/src/liberime-core.dll")
    ;;        ;; (setq liberime-module-file "d:/soft/msys64/mingw64/share/emacs/site-lisp/liberime-core.dll")
    ;;        )
    ;; (add-to-list 'load-path "d:/programs/liberime")
    (setq liberime-module-file (expand-file-name "src/liberime-core.so" (locate-library "liberime")))
    ;; (progn (add-to-list 'load-path "~/programs/liberime")
    ;; (setq liberime-module-file "/home/sawyer/programs/liberime/src/liberime-core.so")
    )
  :config
  (setq liberime-auto-build t)
  (let ((liberime-auto-build t))
    (require 'liberime nil t))

  (require 'pyim-liberime)



  ;; * 方案选择 --------------------------------------
  ;; ;; 全拼
  ;; (liberime-select-schema "luna_pinyin_simp")
  ;; (setq pyim-default-scheme 'rime-quanpin)
  ;; ;; 双拼
  ;; (liberime-select-schema "double_pinyin_plus")
  ;; (setq pyim-default-scheme 'ziranma-shuangpin)

  ;; 小鹤双拼
  (liberime-select-schema "double_pinyin_flypy")

  (pyim-scheme-add
   '(rime-shuangpin-flypy
     :document "rime 小鹤双拼输入法。"
     :class rime
     :code-prefix "rime/"
     :code-prefix-history ("&")
     :first-chars "abcdefghijklmnopqrstuvwxyzV" ;; add V for rime-ice scheme of flypy
     :rest-chars "abcdefghijklmnopqrstuvwxyz;"
     :prefer-triggers nil))

  (setq pyim-default-scheme 'rime-shuangpin-flypy)

  (liberime-sync))



;; -------------- old config ------------------------
;; (if (eq system-type 'windows-nt )
;;     (add-to-list 'load-path "d:/soft/msys64/mingw64/share/emacs/site-lisp/")
;;     ;; (add-to-list 'load-path "d:/programs/liberime")
;;   (add-to-list 'load-path "~/programs/liberime"))



;; ;; 这一步很重要，不然： 1) 不能启用词典 2) 记不住新词
;; (let ((liberime-auto-build t))
;;   (require 'liberime nil t))

;; (require 'pyim-liberime)


;; (with-eval-after-load "liberime"
;;   (liberime-select-schema "luna_pinyin_simp")
;;   (setq pyim-default-scheme 'rime-quanpin))


;; (add-hook 'my/startup-hook #'liberime-sync)

(with-eval-after-load 'pyim
  (require 'liberime))

(provide 'init-liberime)

