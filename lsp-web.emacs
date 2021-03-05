;; -*- coding: utf-8; -*-
;; * ref: https://emacs-lsp.github.io/lsp-mode/page/lsp-typescript/
;;
;; * install server:npm i -g typescript-language-server; npm i -g typescript
;;
;; * start server: C-u M-x lsp <Enter> ts-ls <Enter>

(load-file "~/.conf.d/lsp.emacs")

(add-hook 'web-mode-hook 'lsp)
(add-hook 'js2-mode-hook 'lsp)
