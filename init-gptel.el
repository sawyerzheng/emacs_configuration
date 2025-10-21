;;; init-gptel.el --- Description -*- lexical-binding: t; -*-
;;
;; Copyright (C) 2025
;;
;; Author:  <sawyer@jishutest>
;; Maintainer:  <sawyer@jishutest>
;; Created: July 22, 2025
;; Modified: July 22, 2025
;; Version: 0.0.1
;; Keywords: abbrev bib c calendar comm convenience data docs emulations extensions faces files frames games hardware help hypermedia i18n internal languages lisp local maint mail matching mouse multimedia news outlines processes terminals tex text tools unix vc wp
;; Homepage: https://github.com/sawyerzheng/init-gptel
;; Package-Requires: ((emacs "24.3"))
;;
;; This file is not part of GNU Emacs.
;;
;;; Commentary:
;;
;;  Description
;;
;;; Code:
(use-package gptel
  :commands (gptel
	     gptel-mode
	     gptel-send
	     gptel-rewrite
             gptel-tools)
  :hook (
         ;; auto scroll
         (gptel-post-stream . gptel-auto-scroll))
  :config
  (require 'gptel-curl)
  (require 'gptel-rewrite)
  ;; (load-file "~/org/private/openai.el.gpg")
  (setq gptel-default-mode #'org-mode)

  (require 'gptel-openai)
  (require 'gptel-ollama)

  (setq gptel-model 'google/gemini-2.5-flash)

  (setq gptel-log-level 'info)
  )

(use-package gptel-quick
  :after embark
  :commands (gptel-quick)
  :bind (:map embark-general-map
	      ("?" . gptel-quick)
	      )
  :config
  (setq gptel-log-level 'info)
  ;; (with-eval-after-load 'embark
  ;;     (keymap-set embark-general-map "?" #'gptel-quick))
  (require 'gptel-integrations)
  )

(use-package gptel-prompts
  :after (gptel)
  :init
  (setq gptel-prompts-directory (expand-file-name "custom.d/prompts" my/conf-distro-dir))
  :demand t
  :config
  (gptel-prompts-update)
  ;; Ensure prompts are updated if prompt files change
  (gptel-prompts-add-update-watchers))

(use-package gptel-magit
  :commands (gptel-magit-generate-message))

;;; tools
(use-package init-mcp)

(provide 'init-gptel)
;;; init-gptel.el ends here
