(use-package scimax-app
  :commands (explorer bash))

;; (with-eval-after-load 'xah-fly-keys
;;   (defun xah-open-file-at-cursor (arg)
;;     "Open the file path under cursor.
;; If there is selection, use it for path.
;; If the path starts with “http://”, open the URL in browser.
;; Input path can be {relative, full path, URL}.
;; Path may have a trailing “:‹n›” that indicates line number, or “:‹n›:‹m›” with line and column number. If so, jump to that line number.
;; If path does not have a file extension, automatically try with “.el” for elisp files.

;; See also `xah-open-file-at-cursor-pre-hook'.

;; This command is similar to `find-file-at-point' but without prompting for confirmation.

;; URL `http://xahlee.info/emacs/emacs/emacs_open_file_path_fast.html'
;; Version: 2020-10-17 2021-10-16"
;;     (interactive)
;;     (let* (($input
;;             (if (region-active-p)
;;                 (buffer-substring-no-properties (region-beginning) (region-end))
;;               (let (($p0 (point)) $p1 $p2
;;                     ($pathStops "^  \t\n\"`'‘’“”|[]{}「」<>〔〕〈〉《》【】〖〗«»‹›❮❯❬❭〘〙·。\\"))
;;                 (skip-chars-backward $pathStops)
;;                 (setq $p1 (point))
;;                 (goto-char $p0)
;;                 (skip-chars-forward $pathStops)
;;                 (setq $p2 (point))
;;                 (goto-char $p0)
;;                 (buffer-substring-no-properties $p1 $p2))))
;;            $input2 $path)
;;       (setq $input2
;;             (if (> (length xah-open-file-at-cursor-pre-hook) 0)
;;                 (let (($x (run-hook-with-args-until-success 'xah-open-file-at-cursor-pre-hook $input)))
;;                   (if $x $x $input))
;;               $input))
;;       (setq $path (replace-regexp-in-string "^/C:/" "/" (replace-regexp-in-string "^file://" "" (replace-regexp-in-string ":\\'" "" $input2))))
;;       (if (string-match-p "\\`https?://" $path)
;;           (progn
;;             (if my/wsl-p
;;                 (shell-command-to-string (format "powershell.exe -noprofile -noninteractive -windowstyle hidden -nologo \"start %s\"" $path))
;;               (browse-url $path)))

;;         (progn                          ; not starting “http://”
;;           (if (string-match "#" $path)
;;               (let (($fpath (substring $path 0 (match-beginning 0)))
;;                     ($fractPart (substring $path (1+ (match-beginning 0)))))
;;                 (if (file-exists-p $fpath)
;;                     (progn
;;                       (find-file $fpath)
;;                       (goto-char (point-min))
;;                       (search-forward $fractPart))
;;                   (when (y-or-n-p (format "file does not exist: [%s]. Create?" $fpath))
;;                     (find-file $fpath))))
;;             (if (string-match "^\\`\\(.+?\\):\\([0-9]+\\)\\(:[0-9]+\\)?\\'" $path)
;;                 (let (($fpath (match-string-no-properties 1 $path))
;;                       ($lineNum (string-to-number (match-string-no-properties 2 $path))))
;;                   (if (file-exists-p $fpath)
;;                       (progn
;;                         (find-file $fpath)
;;                         (goto-char (point-min))
;;                         (forward-line (1- $lineNum)))
;;                     (when (y-or-n-p (format "file does not exist: [%s]. Create?" $fpath))
;;                       (find-file $fpath))))
;;               (if (file-exists-p $path)
;;                   (progn                ; open f.ts instead of f.js
;;                     (let (($ext (file-name-extension $path))
;;                           ($fnamecore (file-name-sans-extension $path)))
;;                       (if (and (string-equal $ext "js")
;;                                (file-exists-p (concat $fnamecore ".ts")))
;;                           (find-file (concat $fnamecore ".ts"))
;;                         (find-file $path))))
;;                 (if (file-exists-p (concat $path ".el"))
;;                     (find-file (concat $path ".el"))
;;                   (when (y-or-n-p (format "file does not exist: [%s]. Create?" $path))
;;                     (find-file $path))))))))))



;;   )

;;;###autoload
(defun my/xah-open-in-vscode ()
  "Open current file or dir in vscode.

  URL `http://xahlee.info/emacs/emacs/emacs_dired_open_file_in_ext_apps.html'
  Version: 2020-02-13 2021-01-18 2022-08-04"
  (interactive)
  (let (($path (if (thing-at-point 'filename)
                   (thing-at-point 'filename)
                 (if (buffer-file-name)
                     (buffer-file-name)
                   (expand-file-name default-directory)))))
    (message "path is %s" $path)
    (cond
     (my/wsl-p
      (if (buffer-file-name)
          (shell-command-to-string (format "powershell.exe -noprofile  -noninteractive -windowstyle hidden \" code $(wslpath -w %s)\"" (buffer-file-name)))
        (shell-command-to-string "powershell.exe -noprofile  -noninteractive -windowstyle hidden \" code . \""))
      )
     ((string-equal system-type "darwin")
      (shell-command (format "open -a Visual\\ Studio\\ Code.app %s" (shell-quote-argument $path))))
     ((string-equal system-type "windows-nt")
      (shell-command (format "code.cmd %s" (shell-quote-argument $path))))
     ;; (my/wsl-p
     ;;  (shell-command-to-string (format "code %s" (shell-quote-argument $path))))
     ((string-equal system-type "gnu/linux")
      (shell-command (format "code %s" (shell-quote-argument $path)))))))


(provide 'init-file-tools)
