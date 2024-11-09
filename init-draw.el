(use-package edraw
  :straight (:type git :host github :repo "misohena/el-easydraw" :files ("*"))
  :config
  (with-eval-after-load 'org
    (require 'edraw-org)
    (edraw-org-setup-default))
  (with-eval-after-load "ox"
    (require 'edraw-org)
    (edraw-org-setup-exporter)))

(use-package chatu
  :straight (:type git :host github :repo "kimim/chatu")
  :commands (chatu-add
             chatu-open)
  :custom ((chatu-input-dir "./draws")
           (chatu-output-dir "./draws_out")))

(use-package org-drawio
  :straight (:type git :host github :repo "kimim/org-drawio")
  :commands (org-drawio-add
             org-drawio-open)
  :custom ((org-drawio-input-dir "./draws")
           (org-drawio-output-dir "./images")
           (org-drawio-output-page "0")
           ;; set to t, if you want to crop the image.
           (org-drawio-crop nil)))
(provide 'init-draw)
