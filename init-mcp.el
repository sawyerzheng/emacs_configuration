;;; init-mcp.el --- Description -*- lexical-binding: t; -*-
;;
;; Copyright (C) 2025
;;
;; Author:  <sawyer@jishutest>
;; Maintainer:  <sawyer@jishutest>
;; Created: July 25, 2025
;; Modified: July 25, 2025
;; Version: 0.0.1
;; Keywords: abbrev bib c calendar comm convenience data docs emulations extensions faces files frames games hardware help hypermedia i18n internal languages lisp local maint mail matching mouse multimedia news outlines processes terminals tex text tools unix vc wp
;; Homepage: https://github.com/sawyerzheng/init-mcp
;; Package-Requires: ((emacs "24.3"))
;;
;; This file is not part of GNU Emacs.
;;
;;; Commentary:
;;
;;  Description
;;
;;; Code:

(use-package mcp
  :init
  (setq mcp-hub-servers
        `(
          ;; ("everything" . (:command "npx" :args ("-y" "@modelcontextprotocol/server-everything")))
          ("filesystem" . (:command "npx" :args ("-y" "@modelcontextprotocol/server-filesystem" "/home/sawyer/npu-3-sawyer/source/")))
          ("fetch" . (:command "uvx" :args ("mcp-server-fetch")))
          ;; ("qdrant" . (:url "http://localhost:38113/sse"))
          ;; ("graphlit" . (
          ;;                :command "npx"
          ;;                :args ("-y" "graphlit-mcp-server")
          ;;                :env (
          ;;                      :GRAPHLIT_ORGANIZATION_ID "your-organization-id"
          ;;                      :GRAPHLIT_ENVIRONMENT_ID "your-environment-id"
          ;;                      :GRAPHLIT_JWT_SECRET "your-jwt-secret")))

          ("code_runner" . (:command "docker" :args ("run" "--rm" "-i" "docker.1ms.run/formulahendry/mcp-server-code-runner")))
          ("duckduckgo_search" . (:command "uvx" :args ("duckduckgo-mcp-server")))
          ("datetime" . (:command "uvx" :args ("mcp-datetime")))

          ))
  :config (require 'mcp-hub)
  :hook (after-init . mcp-hub-start-all-server))

(with-eval-after-load 'gptel
  (require  'gptel-integrations)
  )

(provide 'init-mcp)
;;; init-mcp.el ends here
