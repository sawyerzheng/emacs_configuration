;;;  -*- lexical-binding: t; -*-
(require 'org-download)

;;;###autoload
(defun markdown-download-clipboard (&optional basename)
  "Capture the image from the clipboard and insert the resulting file."
  (interactive)
  (let ((org-download-screenshot-method
         (cl-case system-type
           (gnu/linux
            (if (string= "wayland" (getenv "XDG_SESSION_TYPE"))
                (if (executable-find "wl-paste")
                    "wl-paste -t image/png > %s"
                  (user-error
                   "Please install the \"wl-paste\" program included in wl-clipboard"))
              (if (executable-find "xclip")
                  "xclip -selection clipboard -t image/png -o > %s"
                (user-error
                 "Please install the \"xclip\" program"))))
           ((windows-nt cygwin)
            (if (executable-find "convert")
                "convert clipboard: %s"
              (user-error
               "Please install the \"convert\" program included in ImageMagick")))
           ((darwin berkeley-unix)
            (if (executable-find "pngpaste")
                "pngpaste %s"
              (user-error
               "Please install the \"pngpaste\" program from Homebrew."))))))
    (markdown-download-screenshot basename)))


(defun markdown-download-screenshot (&optional basename)
  "Capture screenshot and insert the resulting file.
The screenshot tool is determined by `org-download-screenshot-method'."
  (interactive)
  (let* ((screenshot-dir (file-name-directory org-download-screenshot-file))
         (org-download-screenshot-file
          (if basename
              (concat screenshot-dir basename) org-download-screenshot-file)))
    (make-directory screenshot-dir t)
    (if (functionp org-download-screenshot-method)
        (funcall org-download-screenshot-method
                 org-download-screenshot-file)
      (shell-command-to-string
       (format org-download-screenshot-method
               org-download-screenshot-file)))
    (when (file-exists-p org-download-screenshot-file)
      (markdown-download-image org-download-screenshot-file)
      (delete-file org-download-screenshot-file))))

(defun markdown-download-markdown-mode-p ()
  "Return `t' if major-mode or derived-mode-p equals 'org-mode, otherwise `nil'."
  (or (eq major-mode 'markdown-mode) (when (derived-mode-p 'markdown-mode) t)))


(defun markdown-download--dir ()
  "Return the directory path for image storage.

The path is composed from `org-download--dir-1' and `org-download--dir-2'.
The directory is created if it didn't exist before."
  (if (markdown-download-markdown-mode-p)
      (let* ((dir markdown-download-image-dir)
             )
        (unless (file-exists-p dir)
          (make-directory dir t))
        dir)
    default-directory))
(setq markdown-download-image-dir "./img/")

(defun markdown-download--fullname (link &optional ext)
  "Return the file name where LINK will be saved to.

It's affected by `org-download--dir'.
EXT can hold the file extension, in case LINK doesn't provide it."
  (let ((filename
         (replace-regexp-in-string
          "%20" " "
          (file-name-nondirectory
           (car (url-path-and-query
                 (url-generic-parse-url link))))))
        (dir (markdown-download--dir)))
    (when (string-match ".*?\\.\\(?:png\\|jpg\\)\\(.*\\)$" filename)
      (setq filename (replace-match "" nil nil filename 1)))
    (when ext
      (setq filename (concat filename "." ext)))
    (abbreviate-file-name
     (expand-file-name
      (funcall org-download-file-format-function filename)
      dir))))

(defun markdown-download-image (link)
  "Save image at address LINK to `org-download--dir'."
  (interactive "sUrl: ")
  (let* ((link-and-ext (org-download--parse-link link))
         (org-download--dir #'markdown-download--dir)
         (filename
          (cond ((fboundp org-download-method)
                 (funcall org-download-method link))
                (t
                 (apply #'markdown-download--fullname link-and-ext))))
         )

    (setq org-download-path-last-file filename)
    (org-download--image link filename)
    (when (markdown-download-markdown-mode-p)
      (markdown-download-insert-link link filename))
    (when (and (eq org-download-delete-image-after-download t)
               (not (url-handler-file-remote-p (current-kill 0))))
      (delete-file link delete-by-moving-to-trash))))

(defun markdown-download-insert-link (link filename)
  (let* ((beg (point))
         (line-beg (line-beginning-position))
         (indent (- beg line-beg))
         (in-item-p (org-in-item-p))
         (escaped-filename (file-truename (org-link-escape filename)))
         str)
    ;; (if (looking-back "^[ \t]+" line-beg)
    ;;     (delete-region (match-beginning 0) (match-end 0))
    ;;   (newline))



    (insert (format "![%s](%s)\n" (file-name-nondirectory filename)
                    (file-relative-name
                     escaped-filename
                     (file-truename (file-name-directory (buffer-file-name))))))

    ;; (insert (format "![](%s)"
    ;;                 (org-link-escape
    ;;                  (funcall org-download-abbreviate-filename-function filename))))

    ;; (setq str (buffer-substring-no-properties line-beg (point)))
    ;; (when in-item-p
    ;;   (indent-region line-beg (point) indent))
    str)
  )

(defun org-download--image (link filename)
  "Save LINK to FILENAME asynchronously and show inline images in current buffer."
  (when (string= "file" (url-type (url-generic-parse-url link)))
    (setq link (url-unhex-string (url-filename (url-generic-parse-url link)))))
  (cond ((and (not (file-remote-p link))
              (file-exists-p link))
         (copy-file link (expand-file-name filename)))
        (org-download--file-content
         (copy-file org-download--file-content (expand-file-name filename))
         (setq org-download--file-content nil))
        ((eq org-download-backend t)
         (org-download--image/url-retrieve link filename))
        (t
         (org-download--image/command org-download-backend link filename))))


(provide 'markdown-download)
