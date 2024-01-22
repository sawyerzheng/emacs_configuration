(use-package sql
  :defer t
  :config
  (sql-set-product 'postgres)

  (setq sql-postgres-login-params
        '((user :default "postgres")
          (database :default "postgres")
          (server :default "localhost")
          (port :default 5432)))

  (setq sql-connection-alist
        '((pdf-parser-pg (sql-product 'postgres)
                         (sql-port 15432)
                         (sql-user "matgene")
                         (sql-db "pdf-parser"))
          (mydb-pg (sql-product 'postgres)
                   (sql-port 5432)
                   (sql-user "postgres")
                   (sql-db "mydb"))
          (semic-formula-params (sql-product 'sqlite)
                                (sql-database "/mnt/e/programs/databases/formula_params.sqlite"))))
  (defun my-sql-login-hook ()
    "Custom SQL log-in behaviours. See `sql-login-hook'."
    ;; n.b. If you are looking for a response and need to parse the
    ;; response, use `sql-redirect-value' instead of `comint-send-string'.
    (when (eq sql-product 'postgres)
      (let ((proc (get-buffer-process (current-buffer))))
        ;; Output each query before executing it. (n.b. this also avoids
        ;; the psql prompt breaking the alignment of query results.)
        (comint-send-string proc "\\set ECHO queries\n"))))

  (defun my/sql-login-execute-commands (product message-list)
    (when (eq sql-product product)
      (let ((proc (get-buffer-process (current-buffer))))
        (dolist (msg message-list)
          (comint-send-string proc msg)))))

  :hook (sql-interactive-mode . (lambda ()
                                  (toggle-truncate-lines t)
                                  (my/sql-login-execute-commands 'sqlite (list
                                                                          ".head on\n"
                                                                          ".mode column\n"))
                                  (my/sql-login-execute-commands 'postgres (list
                                                                            "\\set ECHO queries\n")))))

(use-package sqlup-mode
  :straight t
  :commands (sqlup-mode
             sqlup-capitalize-keywords-in-region
             sqlup-capitalize-keywords-in-buffer)
  :hook (sql-mode
         sql-interactive-mode)
  :config
  ;;(add-to-list 'sqlup-blacklist "name")

  )

(use-package sqlformat
  :straight t
  :hook (sql-mode . sqlformat-on-save-mode)
  :commands (sqlformat)
  :config
  (setq sqlformat-command 'pgformatter)
  (setq sqlformat-args '("-s2" "-g"))

  ;; commands to install
  ;; `pipx install sqlparse' and `pipx install pgformatter'
  )

;; (use-package sql-indent
;;   :straight t
;;   :hook (sql-mode . sqlind-minor-mode))

(use-package sql
  :config
  (setq sql-postgres-login-params (append sql-postgres-login-params '(port :default 5432))))

(use-package ejc-sql
  :straight (:type git :host github :repo "kostafey/ejc-sql")
  :config
  (setq clomacs-httpd-default-port 18092) ; Use a port other than 8080.
  (setq ejc-completion-system 'standard)

  (ejc-create-connection
   "postgres-local"
   :classpath (car (directory-files-recursively "~/.m2" "postgres.*\\.jar$"))
   :dbtype "postgres"
   :subprotocol "postgresql"
   :subname "//localhost:5432/mydb"
   :user "postgres"
   :password "jskj2019")

  :hook (ejc-sql-mode . (lambda ()
                          (auto-complete-mode 1)
                          (ejc-ac-setup)))
  :commands (ejc-connect)
  )

(use-package edbi
  :straight t
  :commands (edbi:open-db-viewer))
(provide 'init-sql)
