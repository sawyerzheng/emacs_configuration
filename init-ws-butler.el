(my/straight-if-use '(ws-butler :type git :host github :repo "lewang/ws-butler")) 
(use-package ws-butler
  :hook ((prog-mode org-mode markdown-mode gfm-mode) . ws-butler-mode))

(provide 'init-ws-butler)
