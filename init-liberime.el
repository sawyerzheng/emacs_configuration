;; -*- coding: utf-8; -*-

;;; +liberime snap build fix (TDD) ---- BEGIN ------------------------------
;;; 修复: snap 版 Emacs 下 liberime 自动构建的 glibc 头文件混用.
;;; 仅 snap 环境启用; 非 snap 零影响.

(defvar +liberime-snap-fix-mode t
  "非 nil 时在 snap 环境下启用 liberime 构建修复.")

(defun +liberime-snap-include-dir ()
  "Emacs 运行于 snap 时返回其 include 目录, 否则返回 nil."
  (let* ((files (and (fboundp 'locate-library) (locate-library "files")))
         (prefix (and files (replace-regexp-in-string "/share/emacs/.*" "" files))))
    (and prefix
         (string-match-p "/snap/" prefix)
         (concat (file-name-as-directory prefix) "include/"))))

(defun +liberime-module-file-path ()
  "返回 liberime-core 模块的路径.

snap: `doom-local-dir' 下的稳定路径 (非 snap 环境不受影响).
非 snap: 库目录下已存在的 .so 路径; 不存在则返回 nil (与原配置行为一致,
即交由 liberime 的自动构建兜底)."
  (if (+liberime-snap-include-dir)
      (expand-file-name "liberime-core.so"
                        (or (bound-and-true-p doom-local-dir)
                            "~/.emacs.d.doom/.local/"))
    (let* ((lib (and (fboundp 'locate-library) (locate-library "liberime")))
           (candidate (and lib
                           (expand-file-name "src/liberime-core.so"
                                             (file-name-directory lib)))))
      (and candidate (file-exists-p candidate) candidate))))

(defun +liberime-ensure-module (&optional force)
  "snap 环境下确保 liberime-core.so 可用.

模块缺失(或 FORCE 非 nil)时, 用 liberime 仓库自带的 emacs-module/<ver>
头文件构建 (默认 Makefile, 不引用 snap 头目录), 拷贝到稳定路径, 并设置
`liberime-module-file'. 非 snap 环境为 no-op, 返回 nil."
  (when (+liberime-snap-include-dir)
    (let* ((lib (and (fboundp 'locate-library) (locate-library "liberime")))
           (libdir (or (and lib (file-name-directory lib))
                       (expand-file-name
                        "straight/repos/liberime/"
                        (or (bound-and-true-p doom-local-dir)
                            "~/.emacs.d.doom/.local/"))))
           (module (+liberime-module-file-path)))
      (when (and libdir module)
        (when (or force
                  (not (file-exists-p module))
                  ;; 新鲜度: checkout 的 C 源码比稳定 .so 新 → 自动重建
                  ;; (升级 liberime 后避免陈旧二进制静默服务新 elisp)
                  (let ((src (expand-file-name "src/liberime-core.c" libdir)))
                    (and (file-exists-p src)
                         (file-newer-than-file-p src module))))
          (message "+liberime: snap Emacs detected, building liberime-core ...")
          (let ((status (call-process "make" nil "*liberime build*" nil
                                      "-C" (directory-file-name libdir)
                                      (format "EMACS_MAJOR_VERSION=%d"
                                              emacs-major-version))))
            (unless (= 0 status)
              (error "+liberime: build failed (exit %d), see *liberime build*"
                     status)))
          (let ((built (expand-file-name "src/liberime-core.so" libdir)))
            (when (file-exists-p built)
              (make-directory (file-name-directory module) t)
              (copy-file built module t))))
        (when (file-exists-p module)
          (setq liberime-module-file module)
          t)))))

(defun +liberime-build-around (orig-fn &rest args)
  "snap 下用修复后的构建流程接管 `liberime-build'; 非 snap 原样透传."
  (if (+liberime-snap-include-dir)
      (progn (+liberime-ensure-module t)
             (when (fboundp 'liberime-load)
               (liberime-load)))
    (apply orig-fn args)))

;; 顶层接线: snap 环境下尽早构建/设置模块 (在 liberime 首次 require 之前);
;; 并接管 liberime-build 以覆盖手动重建与 auto-build 场景.
(when (and +liberime-snap-fix-mode (+liberime-snap-include-dir))
  (+liberime-ensure-module))

(with-eval-after-load 'liberime
  (unless (advice-member-p #'+liberime-build-around 'liberime-build)
    (advice-add 'liberime-build :around #'+liberime-build-around)))

;;; +liberime snap build fix ---- END ----------------------------------------


;; 自有发行版: 用 no-littering 目录存放 rime 用户数据;
;; doom 下跳过 (由社区模块 chinese +rime 用 doom-cache-dir "rime" 设置).
(unless (bound-and-true-p my/doom-p)
  (setq liberime-user-data-dir
        (expand-file-name "rime" no-littering-var-directory)))

(unless (or my/windows-p (bound-and-true-p my/doom-p))
  (my/straight-if-use `(liberime
                        :pre-build ,(pcase system-type
                                      (`gnu/linux '("make"))
                                      (`widnows-nt '(message "liberime can not be made on windows"))
                                      ;; (_ '("make"))
                                      ))))



(use-package liberime
  :commands (liberime-build liberime-sync liberime-load liberime-deploy)
  :after pyim
  :config
  :init
  (if (eq system-type 'windows-nt)
      ;; nil ;; 手动复制官方 Release zip 文件到 emacs 安装目录： https://github.com/merrickluo/liberime/releases
      (cond ((equal emacs-major-version 30)

	     ;; (setq liberime-module-file "d:/home/.emacs.d.raw/straight/repos/liberime/src/liberime-core.dll")
	     (setq liberime-module-file "d:/soft/emacs/emacs-30.1/bin/liberime-core.dll")

	     )
	    (t
	     (setq liberime-module-file "d:/soft/emacs/emacs-28.1/bin/liberime-core.dll")))

    ;; (setq liberime-module-file "E:/soft/msys64/ucrt64/bin/liberime-core.dll")
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
    (setq liberime-module-file (+liberime-module-file-path))
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

