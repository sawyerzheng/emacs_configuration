;; -*- coding: utf-8-unix; -*-
;; this file is specialized on anaconda-mode



;; to enable anaconda-mode
(add-hook 'python-mode-hook 'anaconda-mode)

;; for functin doc display in echo area
(add-hook 'python-mode-hook 'anaconda-eldoc-mode)


;; for virtual env
;; M-x pythonic-activate RET /path/to/virtualenv RET
