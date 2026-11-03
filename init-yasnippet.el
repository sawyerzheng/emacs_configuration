;; load snippet tables  -*- coding: utf-8; -*-

;; 记录本文件求值时 yasnippet 是否已经加载（见 :config 的 fallback）。
(defvar my/yasnippet-preloaded-p nil)
(setq my/yasnippet-preloaded-p (featurep 'yasnippet))

(use-package yasnippet
  ;; NOTE: Doom's `:editor snippets' module is authoritative for yasnippet
  ;; setup (it enables `yas-global-mode' and registers `+org-yas-expand-maybe-h'
  ;; on `org-tab-first-hook', so TAB expands & jumps fields in org-mode too).
  ;; This file only (a) adds the private snippet dir and (b) *guarantees*
  ;; yas-minor-mode is on for org-mode buffers even if global mode is off.
  :init
  ;; 必须在 yasnippet 首次加载之前注册。Doom 的 snippets 模块会在 yasnippet
  ;; 加载时启用 `yas-global-mode'，触发 `yas-reload-all'（JIT 调度）；
  ;; 只有此刻已在 `yas-snippet-dirs' 中的目录才会被纳入。
  (defvar yas-snippet-dirs nil)
  (add-to-list 'yas-snippet-dirs
               (expand-file-name "~/.conf.d/custom.d/snippets"))
  (defun my/enable-yas-local-fn ()
    ;; ensure yasnippet is loaded before enabling the minor mode
    (require 'yasnippet)
    (yas-minor-mode 1))
  ;; Doom 侧由 `yas-global-mode' 统一启用 `yas-minor-mode'，再挂 prog/org
  ;; hook 只是重复执行；自有 distro 没有 global mode，保留 hook 作为兜底。
  (unless my/doom-p
    (add-hook 'prog-mode-hook #'my/enable-yas-local-fn)
    (add-hook 'org-mode-hook #'my/enable-yas-local-fn))
  :commands (my/enable-yas-local-fn
	     yas-minor-mode
	     yas-global-mode)
  :config
  ;; Doom 的 `doom-snippets' 已提供大量模板；在 Doom 侧再加载
  ;; `yasnippet-snippets' 会额外触发一次完整目录扫描（实测约 0.63s）。
  ;; 自有 distro 没有 doom-snippets，继续保留该库。
  (unless my/doom-p
    (require 'yasnippet-snippets))
  ;; 正常启动路径：:init 已先注册目录，Doom 的 reload 会包含它，不需要额外
  ;; reload。只有 yasnippet 在本文件求值前就已加载（reload / eval-buffer）
  ;; 时，首次 reload 才可能漏掉该目录，此时补一次 JIT reload。
  (when my/yasnippet-preloaded-p
    (yas-reload-all))
  )

(use-package auto-yasnippet
  :commands (aya-create
             aya-expand
             aya-expand-from-history
             aya-delete-from-history
             aya-clear-history
             aya-next-in-history
             aya-previous-in-history
             aya-persist-snippet)

  )


(provide 'init-yasnippet)
