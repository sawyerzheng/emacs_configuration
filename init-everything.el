(use-package everything
  :if my/windows-p
  :straight (:type built-in)
  :commands (everything everything-find-file everything-toggle-case)
  :config
  (setq everything-cmd "D:/Program Files/Everything/es.exe"))

(provide 'init-everything)
