;;======================= my cedet init file --- zhenglei ===============

;;====================== semantic ==========================
;; semantic MAJOR mode
(semantic-mode t)

;; minor modes
(load-file "~/.conf.d/semantic-minor-modes.emacs")
(load-file "~/.conf.d/qt-semantic.emacs")
;; for semantic completions
(require 'semantic/ia)

(require 'semantic/bovine/gcc)


;;====================== include files =====================
;;include files
;; (setq semanticdb-project-roots (list (expand-file-name "/")))

(defconst cedet-user-include-dirs
  (list ".." "../include" "../inc" "../common" "../public"
        "../.." "../../include" "../../inc" "../../common" "../../public"))
(defconst cedet-win32-include-dirs
  (list "C:/MinGW/include"
        "C:/MinGW/lib/gcc/mingw32/6.3.0/include"
	"C:/MinGW/lib/gcc/mingw32/6.3.0/include/c++"
	"C:/MinGW/lib/gcc/mingw32/6.3.0/include/ssp"
        "C:/Program Files/Microsoft Visual Studio/VC98/MFC/Include"))



(require 'semantic-c nil 'noerror)
(let ((include-dirs cedet-user-include-dirs))
  (when (eq system-type 'windows-nt)
    (setq include-dirs (append include-dirs cedet-win32-include-dirs )))
  (mapc (lambda (dir)
          (semantic-add-system-include dir 'c++-mode)
          (semantic-add-system-include dir 'c-mode))
        include-dirs))

;;==================== semantic mrc , source code jump ===============
(global-semantic-mru-bookmark-mode t)
;;code jump,    代码跳转:F12
(global-set-key [f12] 'semantic-ia-fast-jump)
;;代码跳转返回  即：shift+F12
(global-set-key [S-f12]
                (lambda ()
                  (interactive)
                  (if (ring-empty-p (oref semantic-mru-bookmark-ring ring))
                      (error "Semantic Bookmark ring is currently empty"))
                  (let* ((ring (oref semantic-mru-bookmark-ring ring))
                         (alist (semantic-mrub-ring-to-assoc-list ring))
                         (first (cdr (car alist))))
                    (if (semantic-equivalent-tag-p (oref first tag)
                                                   (semantic-current-tag))
                        (setq first (cdr (car (cdr alist)))))
                    (semantic-mrub-switch-tags first))))




























;;====================== start of        cedet   =========================
;;(load-file "~/.emacs.d/plugins/cedet-master/cedet-devel-load.el")
(require 'cedet)
(global-ede-mode 1)
;;(global-srecode-minor-mode 1)

;;; semantic setup
;;(semantic-load-enable-minimum-features)
;;(semantic-load-enable-code-helpers)
;(semantic-load-enable-gaudy-code-helpers)
;;(semantic-load-enable-excessive-code-helpers)
;;(semantic-load-enable-semantic-debugging-helpers)

;;senator menu
;(senator-minor-mode 1)

;;; gcc setup
(require 'semantic/bovine/gcc)



;;; smart complitions setup
(require 'semantic/ia)


(require 'cc-mode)
;;函数声明与定义跳转 Meta+shift+F12
(define-key c-mode-base-map [M-S-f12] 'semantic-analyze-proto-impl-toggle)
;;代码补全跳出菜单提示，不是弹出buffer : Meta+n
(define-key c-mode-base-map (kbd "M-n") 'semantic-ia-complete-symbol-menu)
;;启用EDE     -> Emacs Development Environment   like IDE
(global-ede-mode 1)


;;emacs有自带的书签功能(c-x r m, c-x r b, c-x r l)，不过对于用了多年VC6的我来说还是更习惯让一个书签能高亮显示出来。cedet里就带了一个可视化的书签，通过下面的语句可以启用它：
;(enable-visual-studio-bookmarks)
;;F2 在当前行设置或取消书签
;;C-F2 查找下一个书签
;;S-F2 查找上一个书签
;;C-S-F2 清空当前文件的所有书签





;;; 快捷键
(defun my-cedet-hook()
  (local-set-key [(control return)] 'semantic-ia-complete-symbol)

  (local-set-key "\C-c?" 'semantic-ia-complete-symbol-menu)
  (local-set-key (kbd "M-n") 'semantic-ia-complete-symbol-menu)

  (local-set-key "\C-c>" 'semantic-complete-analyze-inline)
  (local-set-key (kbd "M-/") 'semantic-complete-analyze-inline)

  (local-set-key "\C-cp" 'semantic-analyze-proto-impl-toggle)
  (local-set-key "\C-cd" 'semantic-ia-fast-jump)
  (local-set-key "\C-cr" 'semantic-symref-symbol)
  (local-set-key "\C-cR" 'semantic-symref)

  ;;; c/c++ setting
  (local-set-key "." 'semantic-complete-self-insert)
  (local-set-key ">" 'semantic-complete-self-insert))
(add-hook 'c-mode-common-hook 'my-cedet-hook)
;;end of    ==========  cedet  ===========

