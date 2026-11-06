(use-package grip-mode
  :commands (grip-mode)
  :after markdown-mode
  :bind (:map markdown-mode-command-map
              ("g" . grip-mode))
  :bind ([remap markdown-preview] . grip-mode)
  :config
  (setq grip-command 'go-grip)
  (setq grip-preview-use-webkit nil)
  (setq grip-github-user "sawyerzheng")
  (setq grip-github-password "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")
  (load-file "~/org/private/grip-setup.el")
  ;; * to support dark theme
  ;; uv tool install git+https://github.com/joeyespo/grip
  (setq my/grip-theme "dark") ;; light or dark
  )

;;; Org attachment preview (Plan B)
;;
;; grip-mode exports <org>.md next to the org file.  Org expands
;; `attachment:' links to absolute paths (/home/sawyer/org/.attach/...),
;; but go-grip serves only the .md's directory, so those images 404.
;; This block rewrites only the absolute attachment prefix to a local
;; static server URL.  Relative image links (img/..., ./img/...) are left
;; untouched and keep working because the .md stays in the org directory.
;;
;; The server is pure Elisp (make-network-process), runs inside Emacs,
;; binds 127.0.0.1 only, and serves only `org-attach-id-dir'.

(require 'url-util)

(defvar my/org-attach-http-port 8642
  "Port of the org attachment preview server.")

(defvar my/org-attach-http-root nil)
(defvar my/org-attach-http-server nil)

(defun my/org-attach-http--mime (file)
  (pcase (downcase (or (file-name-extension file) ""))
    ("png" "image/png")
    ((or "jpg" "jpeg") "image/jpeg")
    ("gif" "image/gif")
    ("svg" "image/svg+xml")
    ("webp" "image/webp")
    ("bmp" "image/bmp")
    ("pdf" "application/pdf")
    (_ "application/octet-stream")))

(defun my/org-attach-http--respond (proc status reason headers body)
  (ignore-errors
    (process-send-string
     proc
     (concat (format "HTTP/1.1 %d %s\r\n" status reason)
             (mapconcat (lambda (h) (concat (car h) ": " (cdr h) "\r\n"))
                        headers "")
             "Connection: close\r\n\r\n"))
    (when body (process-send-string proc body)))
  (ignore-errors (delete-process proc)))

(defun my/org-attach-http--handle (proc request)
  (let* ((line (car (split-string request "\r\n")))
         (parts (split-string line " "))
         (method (nth 0 parts))
         (target (nth 1 parts)))
    (cond
     ((not (member method '("GET" "HEAD")))
      (my/org-attach-http--respond proc 405 "Method Not Allowed" nil nil))
     ((not target)
      (my/org-attach-http--respond proc 400 "Bad Request" nil nil))
     (t
      (let* ((path (car (split-string target "?")))
             (decoded (decode-coding-string (url-unhex-string path) 'utf-8))
             (rel (string-remove-prefix "/" decoded))
             (root (file-name-as-directory
                    (file-truename (expand-file-name my/org-attach-http-root))))
             (file (expand-file-name rel root)))
        (if (or (not (string-prefix-p root (file-truename file)))
                (not (file-regular-p file))
                (not (file-readable-p file)))
            (my/org-attach-http--respond proc 404 "Not Found" nil nil)
          (let* ((size (file-attribute-size (file-attributes file)))
                 (mime (my/org-attach-http--mime file))
                 (headers `(("Content-Type" . ,mime)
                            ("Content-Length" . ,(number-to-string size))
                            ("Cache-Control" . "no-cache"))))
            (if (string= method "HEAD")
                (my/org-attach-http--respond proc 200 "OK" headers nil)
              (let ((body (with-temp-buffer
                            (set-buffer-multibyte nil)
                            (insert-file-contents-literally file)
                            (buffer-string))))
                (my/org-attach-http--respond proc 200 "OK" headers body))))))))))

(defun my/org-attach-http--filter (proc chunk)
  (when (process-live-p proc)
    (let ((buf (process-get proc :buffer)))
      (unless buf
        (setq buf (generate-new-buffer " *org-attach-http*"))
        (process-put proc :buffer buf))
      (with-current-buffer buf
        (set-buffer-multibyte nil)
        (goto-char (point-max))
        (insert chunk)
        (when (search-backward "\r\n\r\n" nil t)
          (let ((request (buffer-substring-no-properties
                          (point-min) (match-end 0))))
            (kill-buffer buf)
            (process-put proc :buffer nil)
            (my/org-attach-http--handle proc request)))))))

(defun my/org-attach-http-start ()
  (interactive)
  (let ((root (file-name-as-directory (expand-file-name org-attach-id-dir))))
    (unless (and (process-live-p my/org-attach-http-server)
                 (equal my/org-attach-http-root root))
      (my/org-attach-http-stop)
      (setq my/org-attach-http-root root)
      (condition-case err
          (setq my/org-attach-http-server
                (make-network-process
                 :name (format "org-attach-http-%d" my/org-attach-http-port)
                 :server t
                 :host "127.0.0.1"
                 :service my/org-attach-http-port
                 :family 'ipv4
                 :filter #'my/org-attach-http--filter
                 :coding 'binary
                 :noquery t))
        (error
         (setq my/org-attach-http-server nil)
         (message "org-attach-http: failed on 127.0.0.1:%d: %s"
                  my/org-attach-http-port (error-message-string err)))))))

(defun my/org-attach-http-stop ()
  (interactive)
  (when (process-live-p my/org-attach-http-server)
    (delete-process my/org-attach-http-server))
  (setq my/org-attach-http-server nil))

(add-hook 'kill-emacs-hook #'my/org-attach-http-stop)

(defun my/grip-org-md-http-attach (output backend _info)
  "Rewrite absolute attachment paths to the local preview server."
  (if (memq backend '(md gfm))
      (replace-regexp-in-string
       (regexp-quote (file-name-as-directory (expand-file-name org-attach-id-dir)))
       (format "http://127.0.0.1:%d/" my/org-attach-http-port)
       output)
    output))

(defun my/grip-org-md-strip-attach-tag (output backend _info)
  "Remove the :ATTACH: tag from Markdown headings and TOC entries."
  (if (memq backend '(md gfm))
      (let ((case-fold-search nil))
        (replace-regexp-in-string "[ \t]*:ATTACH:[ \t]*$" "" output))
    output))

(defun my/grip-org-to-md-advice (fn &rest args)
  (my/org-attach-http-start)
  (let ((org-export-filter-final-output-functions
         (cons #'my/grip-org-md-http-attach
               (cons #'my/grip-org-md-strip-attach-tag
                     org-export-filter-final-output-functions))))
    (apply fn args)))

(with-eval-after-load 'grip-mode
  (unless (advice-member-p #'my/grip-org-to-md-advice 'grip-org-to-md)
    (advice-add 'grip-org-to-md :around #'my/grip-org-to-md-advice)))

(provide 'init-grip)
