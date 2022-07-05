;;; scimax-apps.el --- Library to open programs

;;; Commentary:
;;

;;;###autoload
(defun explorer (&optional path)
  "Open Finder or Windows Explorer in the current directory."
  (interactive)
  (message path)
  (let* ((folder (if (null path)
                     (if (buffer-file-name)
                         (setq folder (file-name-directory (buffer-file-name)))
                       default-directory)
                   (if (file-directory-p path)
                       path
                     (if (file-exists-p path)
                         (file-name-directory path)
                       default-directory)))))
    (cond
     ((eq system-type 'gnu/linux)
      (shell-command (format "nautilus \"%s\" " folder))
      )
     ((eq system-type 'darwin)
      (shell-command (format "open -b com.apple.finder%s"
                             (if folder (format " \"%s\""
                                                (file-name-directory
                                                 (expand-file-name folder))) ""))))
     ((eq system-type 'windows-nt)
      (message "windows: %s" folder)
      ;; (shell-command (format "explorer.exe %s"
      ;;                        (replace-regexp-in-string
      ;;                         "/" "\\\\"
      ;;                         folder)))
      (let ((default-directory folder))
        (shell-command "explorer . "))
      ))))

(defalias 'finder 'explorer "Alias for `explorer'.")


(defun bash (&optional path)
  "Open a bash window.
PATH is optional, and defaults to the current directory."
  (interactive (list (if (buffer-file-name)
			 (file-name-directory (buffer-file-name))
		       (expand-file-name default-directory))))
  (cond
   ((string= system-type "gnu/linux")
    (shell-command "gnome-terminal"))
   ((string= system-type "darwin")
    (shell-command
     (format "open -b com.apple.terminal%s"
	     (if path (format " \"%s\"" (expand-file-name path)) ""))))
   ((string= system-type "windows-nt")
    (shell-command "start \"\" \"pwsh.exe\" --login &"))))

(defun excel ()
  "Open Microsoft Excel."
  (interactive)
  (let* ((file (if (eq major-mode 'dired-mode)
                   (dired-get-file-for-visit)
                 "")))
    (cond
     ((string= system-type "gnu/linux")
      (error "Excel is not on Linux."))
     ((string= system-type "darwin")
      (shell-command
       (shell-command (format "open -b com.microsoft.Excel %s" file))))
     ((string= system-type "windows-nt")
      (shell-command (format "start excel %s" (replace-regexp-in-string "/" "\\" file t t)))))))


(defun word ()
  "Open Microsoft Word."
  (interactive)
  (let* ((file (if (eq major-mode 'dired-mode)
                   (dired-get-file-for-visit)
                 "")))

    (cond
     ((string= system-type "gnu/linux")
      (error "Word is not on Linux."))
     ((string= system-type "darwin")
      (shell-command
       (shell-command "open -b com.microsoft.Word")))
     ((string= system-type "windows-nt")
      (shell-command (format "start winword %s" (replace-regexp-in-string "/" "\\" file t t)))))))


(defun powerpoint ()
  "Open Microsoft Powerpoint."
  (interactive)
  (let* ((file (if (eq major-mode 'dired-mode)
                   (dired-get-file-for-visit)
                 "")))

    (cond
     ((string= system-type "gnu/linux")
      (error "Powerpoint is not on Linux."))
     ((string= system-type "darwin")
      (shell-command
       (shell-command "open -b com.microsoft.Powerpoint")))
     ((string= system-type "windows-nt")
      (shell-command (format "start powerpnt %s" (replace-regexp-in-string "/" "\\" file t t)))))))


(defun tweetdeck ()
  (interactive)
  (when (region-active-p)
    (kill-ring-save nil nil t))
  (browse-url "https://tweetdeck.twitter.com"))


(defun google ()
  "Open default browser to google.com."
  (interactive)
  (browse-url "http://google.com"))


(provide 'scimax-apps)

;;; scimax-apps.el ends here
