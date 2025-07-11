;; -*- coding: utf-8; -*-
(when (featurep 'straight)
  (straight-use-package 'doom-modeline))

(use-package doom-modeline
  ;; :straight t
  :init
  (setq doom-modeline-support-imenu t)
  :config
  ;; to fix illegal codes
  (setq inhibit-compacting-font-caches t)

  ;; set fonts
  (setq doom-modeline-height 0.3)
  ;; (set-face-attribute 'mode-line nil :family "Monaco" :height 100)
  ;; (set-face-attribute 'mode-line-inactive nil :family "Monaco" :height 100)

  ;; fix too long symlink directories.
  ;; built-in `project' on 26+
  (setq doom-modeline-project-detection 'project)
  ;; or `find-in-project' if it's installed
  ;; (setq doom-modeline-project-detection 'ffip)


  ;; How tall the mode-line should be. It's only respected in GUI.
  ;; If the actual char height is larger, it respects the actual height.
  (setq doom-modeline-height 1)

  ;; How wide the mode-line bar should be. It's only respected in GUI.
  (setq doom-modeline-bar-width 1)

  ;; The limit of the window width.
  ;; If `window-width' is smaller than the limit, some information won't be displayed.
  (setq doom-modeline-window-width-limit fill-column)

  ;; How to detect the project root.
  ;; The default priority of detection is `ffip' > `projectile' > `project'.
  ;; nil means to use `default-directory'.
  ;; The project management packages have some issues on detecting project root.
  ;; e.g. `projectile' doesn't handle symlink folders well, while `project' is unable
  ;; to hanle sub-projects.
  ;; You can specify one if you encounter the issue.
  (setq doom-modeline-project-detection 'project)

  ;; Determines the style used by `doom-modeline-buffer-file-name'.
  ;;
  ;; Given ~/Projects/FOSS/emacs/lisp/comint.el
  ;;   auto => emacs/lisp/comint.el (in a project) or comint.el
  ;;   truncate-upto-project => ~/P/F/emacs/lisp/comint.el
  ;;   truncate-from-project => ~/Projects/FOSS/emacs/l/comint.el
  ;;   truncate-with-project => emacs/l/comint.el
  ;;   truncate-except-project => ~/P/F/emacs/l/comint.el
  ;;   truncate-upto-root => ~/P/F/e/lisp/comint.el
  ;;   truncate-all => ~/P/F/e/l/comint.el
  ;;   relative-from-project => emacs/lisp/comint.el
  ;;   relative-to-project => lisp/comint.el
  ;;   file-name => comint.el
  ;;   buffer-name => comint.el<2> (uniquify buffer name)
  ;;
  ;; If you are experiencing the laggy issue, especially while editing remote files
  ;; with tramp, please try `file-name' style.
  ;; Please refer to https://github.com/bbatsov/projectile/issues/657.
  ;; (setq doom-modeline-buffer-file-name-style 'auto)
  (setq doom-modeline-buffer-file-name-style
        'truncate-with-project
        ;; 'relative-from-project
        )

  ;; Whether display icons in the mode-line. Respects `all-the-icons-color-icons'.
  ;; While using the server mode in GUI, should set the value explicitly.
  ;; (setq doom-modeline-icon (or (daemonp) (display-graphic-p)))
  (setq doom-modeline-icon t)

  ;; Whether display the icon for `major-mode'. Respects `doom-modeline-icon'.
  (setq doom-modeline-major-mode-icon t)

  ;; Whether display the colorful icon for `major-mode'.
  ;; Respects `doom-modeline-major-mode-icon'.
  (setq doom-modeline-major-mode-color-icon t)

  ;; Whether display the icon for the buffer state. It respects `doom-modeline-icon'.
  (setq doom-modeline-buffer-state-icon t)

  ;; Whether display the modification icon for the buffer.
  ;; Respects `doom-modeline-icon' and `doom-modeline-buffer-state-icon'.
  (setq doom-modeline-buffer-modification-icon t)

  ;; Whether to use unicode as a fallback (instead of ASCII) when not using icons.
  (setq doom-modeline-unicode-fallback nil)

  ;; Whether display the minor modes in the mode-line.
  (setq doom-modeline-minor-modes nil)

  ;; If non-nil, a word count will be added to the selection-info modeline segment.
  (setq doom-modeline-enable-word-count nil)

  ;; Major modes in which to display word count continuously.
  ;; Also applies to any derived modes. Respects `doom-modeline-enable-word-count'.
  ;; If it brings the sluggish issue, disable `doom-modeline-enable-word-count' or
  ;; remove the modes from `doom-modeline-continuous-word-count-modes'.
  (setq doom-modeline-continuous-word-count-modes '(markdown-mode gfm-mode org-mode))

  ;; Whether display the buffer encoding.
  (setq doom-modeline-buffer-encoding t)

  ;; Whether display the indentation information.
  (setq doom-modeline-indent-info nil)

  ;; If non-nil, only display one number for checker information if applicable.
  (setq doom-modeline-checker-simple-format t)

  ;; The maximum number displayed for notifications.
  (setq doom-modeline-number-limit 99)

  ;; The maximum displayed length of the branch name of version control.
  (setq doom-modeline-vcs-max-length 12)

  ;; Whether display the perspective name. Non-nil to display in the mode-line.
  (setq doom-modeline-persp-name nil)
  (setq doom-modeline-persp-icon t)

  ;; If non nil the default perspective name is displayed in the mode-line.
  (setq doom-modeline-display-default-persp-name t)

  ;; Whether display the `lsp' state. Non-nil to display in the mode-line.
  (setq doom-modeline-lsp t)

  ;; Whether display the GitHub notifications. It requires `ghub' package.
  (setq doom-modeline-github nil)

  ;; The interval of checking GitHub.
  (setq doom-modeline-github-interval (* 30 60))

  ;; Whether display the modal state icon.
  ;; Including `evil', `overwrite', `god', `ryo' and `xah-fly-keys', etc.
  (setq doom-modeline-modal-icon t)

  ;; Whether display the mu4e notifications. It requires `mu4e-alert' package.
  (setq doom-modeline-mu4e nil)

  ;; Whether display the gnus notifications.
  (setq doom-modeline-gnus t)

  ;; Wheter gnus should automatically be updated and how often (set to nil to disable)
  (setq doom-modeline-gnus-timer 2)

  ;; Whether display the IRC notifications. It requires `circe' or `erc' package.
  (setq doom-modeline-irc t)

  ;; Function to stylize the irc buffer names.
  (setq doom-modeline-irc-stylize 'identity)

  ;; Whether display the environment version.
  (setq doom-modeline-env-version t)
  ;; Or for individual languages
  (setq doom-modeline-env-enable-python nil)
  (setq doom-modeline-env-enable-ruby t)
  (setq doom-modeline-env-enable-perl t)
  (setq doom-modeline-env-enable-go t)
  (setq doom-modeline-env-enable-elixir t)
  (setq doom-modeline-env-enable-rust t)

  ;; Change the executables to use for the language version string
  (setq doom-modeline-env-python-executable "python3") ; or `python-shell-interpreter'
  ;; (setq doom-modeline-env-ruby-executable "ruby")
  ;; (setq doom-modeline-env-perl-executable "perl")
  (setq doom-modeline-env-go-executable "go")
  ;; (setq doom-modeline-env-elixir-executable "iex")
  ;; (setq doom-modeline-env-rust-executable "rustc")

  ;; What to dispaly as the version while a new one is being loaded
  (setq doom-modeline-env-load-string "...")

  ;; Hooks that run before/after the modeline version string is updated
  (setq doom-modeline-before-update-env-hook nil)
  (setq doom-modeline-after-update-env-hook nil)

  (defun doom-modeline-project-root ()
    "Get the path to the root of your project.
Return `default-directory' if no project was found."
    (let* ((project-root (or (doom-modeline--project-root) default-directory))
           (project-root-true (file-truename project-root)))
      (if (string< (file-relative-name (buffer-file-name) project-root)
                   (file-relative-name (buffer-file-name) project-root-true))
          project-root
        project-root-true)))


  (defun doom-modeline--buffer-file-name (file-path
                                          _true-file-path
                                          &optional
                                          truncate-project-root-parent
                                          truncate-project-relative-path
                                          hide-project-root-parent)
    "Propertize buffer name given by FILE-PATH.

If TRUNCATE-PROJECT-ROOT-PARENT is non-nil will be saved by truncating project
root parent down fish-shell style.

Example:
  ~/Projects/FOSS/emacs/lisp/comint.el => ~/P/F/emacs/lisp/comint.el

If TRUNCATE-PROJECT-RELATIVE-PATH is non-nil will be saved by truncating project
relative path down fish-shell style.

Example:
  ~/Projects/FOSS/emacs/lisp/comint.el => ~/Projects/FOSS/emacs/l/comint.el

If HIDE-PROJECT-ROOT-PARENT is non-nil will hide project root parent.

Example:
  ~/Projects/FOSS/emacs/lisp/comint.el => emacs/lisp/comint.el"
    (let (
          (file-path (file-truename (buffer-file-name)))
          ;; (_true-file-path (file-truename (buffer-file-name)))
          ;; (truncate-project-root-parent 'shrink)
          ;; (truncate-project-relative-path 'shink)
          ;; (hide-project-root-parent 'hide)

          (project-root (file-local-name (doom-modeline-project-root))))
      (concat
       ;; Project root parent
       (unless hide-project-root-parent
         (when-let (root-path-parent
                    (file-name-directory (directory-file-name project-root)))
           (propertize
            (if (and truncate-project-root-parent
                     (not (string-empty-p root-path-parent))
                     (not (string= root-path-parent "/")))
                (shrink-path--dirs-internal root-path-parent t)
              (abbreviate-file-name root-path-parent))
            'face 'doom-modeline-project-parent-dir)))
       ;; Project directory
       (propertize
        (concat (file-name-nondirectory (directory-file-name project-root)) "/")
        'face 'doom-modeline-project-dir)
       ;; relative path
       (propertize
        (when-let (relative-path (file-relative-name
                                  (or (file-name-directory file-path) "./")
                                  project-root))
          (if (string= relative-path "./")
              ""
            (if truncate-project-relative-path
                (substring (shrink-path--dirs-internal relative-path t) 1)
              relative-path)))
        'face 'doom-modeline-buffer-path)
       ;; File name
       (propertize (file-name-nondirectory file-path)
                   'face 'doom-modeline-buffer-file))))





  

  )

(with-eval-after-load 'minibuffer (doom-modeline-mode))


;; * my patches
(add-hook 'my/startup-hook
          #'(lambda ()
              (with-eval-after-load 'doom-modeline
                ;; * my patches
                (defun doom-modeline-project-root ()
                  "Get the path to the root of your project.
Return `default-directory' if no project was found."
                  (let* ((project-root (or (doom-modeline--project-root) default-directory))
                         (project-root-true (file-truename project-root)))
                    (if (string< (file-relative-name (buffer-file-name) project-root)
                                 (file-relative-name (buffer-file-name) project-root-true))
                        project-root
                      project-root-true))))))



(provide 'init-doom-modeline)
