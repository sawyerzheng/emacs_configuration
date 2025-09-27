(setq my/git-everywhere nil)
(my/straight-if-use 'magit)
(use-package magit
  :bind ("C-x g" . magit-status)
  :commands (magit-file-delete magit-init)
  :config
  (setq magit-diff-refine-hunk 'all) ;; (nil t 'all) 显示单词级别的差异
  )

(my/straight-if-use 'transient)
(use-package transient
  :after magit
  )

;; (when (or my/git-everywhere (daemonp) t)
;;   (use-package forge
;;     :after (magit-remote magit)
;;     :straight t
;;     :bind (:map forge-topic-list-mode-map
;;                 ("q" . kill-current-buffer)))
;;   (use-package code-review
;;     :after magit
;;     :straight t)
;;   )

(my/straight-if-use 'magit-gitflow)
(use-package magit-gitflow
  :after magit
  :hook (magit-mode . turn-on-magit-gitflow))

(my/straight-if-use 'magit-todos)
(use-package magit-todos
  :after magit
  :config
  (setq magit-todos-keyword-suffix "\\(?:([^)]+)\\)?:?") ; make colon optional
  (define-key magit-todos-section-map "j" nil))
;;; git-gutter 显示 diff
;; 因为 git-gutter 的性能问题，与flycheck 冲突，放弃使用
;; ;; git gutter(git diff highlight)
;; (my/straight-if-use 'git-gutter)
;; (my/straight-if-use 'git-gutter-fringe)
;; (use-package git-gutter
;;   :hook (find-file . git-gutter-mode)
;;   :config
;;   ;; add beautiful support in GUI.
;;   (when (or (daemonp) (display-graphic-p))
;;     (use-package git-gutter-fringe
;;       :config
;;       (if my/4k-p
;;           (progn
;;             (setq-default left-fringe-width 20)
;;             (setq-default right-fringe-width 20))
;;         (progn
;;           (setq-default left-fringe-width 10)
;;           (setq-default right-fringe-width 10)))
;;       (setq git-gutter-fr:side 'left-fringe))))
;; (if (daemonp)
;;     (add-hook 'server-after-make-frame-hook #'(lambda ()
;;                                                 (unless (boundp 'git-gutter-mode)
;;                                                   (require 'git-gutter))))
;;   (add-hook 'my/startup-hook #'(lambda () (require 'git-gutter))))


(my/straight-if-use 'diff-hl)
(use-package diff-hl
  :init
  (if (fboundp 'fringe-mode) (fringe-mode '8))
  (setq-default fringes-outside-margins t)
  (setq diff-hl-bmp-max-width 2)
  ;; (setq diff-hl-bmp-max-width 5)
  (defun +vc-gutter-enable-maybe-h ()
    "Conditionally enable `diff-hl-dired-mode' in dired buffers.
Respects `diff-hl-disable-on-remote'."
    ;; Neither `diff-hl-dired-mode' or `diff-hl-dired-mode-unless-remote'
    ;; respect `diff-hl-disable-on-remote', so...
    (unless (and (bound-and-true-p diff-hl-disable-on-remote)
                 (file-remote-p default-directory))
      (diff-hl-dired-mode +1)))
  (add-hook 'dired-mode-hook #'+vc-gutter-enable-maybe-h)
  :hook ((my/startup . global-diff-hl-mode)
	 (diff-hl-mode . diff-hl-flydiff-mode)
	 ;; (diff-hl-mode . diff-hl-margin-mode)
	 ;; (dired-mode . diff-hl-dired-mode)
	 (magit-post-refresh . diff-hl-magit-post-refresh)
	 )
  :config
  (setq diff-hl-autohide-margin t)
  (setq diff-hl-global-modes '(not image-mode pdf-view-mode))
  ;; PERF: A slightly faster algorithm for diffing.
  (setq vc-git-diff-switches '("--histogram"))
  ;; PERF: Slightly more conservative delay before updating the diff
  (setq diff-hl-flydiff-delay 0.5)  ; default: 0.3
  ;; PERF: don't block Emacs when updating vc gutter
  (setq diff-hl-update-async t)

  ;; (let* ((height (frame-char-height))
  ;; 	 (width 2)
  ;; 	 (ones (1- (expt 2 width)))
  ;; 	 (bits (make-vector height ones)))
  ;;   (define-fringe-bitmap 'my-diff-hl-bitmap bits height width))
  ;; (setq diff-hl-fringe-bmp-function (lambda (type pos) 'my-diff-hl-bitmap))

  ;; (let* ((width 2)
  ;; 	 (bitmap (vector (1- (expt 2 width)))))
  ;;   (define-fringe-bitmap 'my:diff-hl-bitmap bitmap 1 width '(top t)))
  ;; (setq diff-hl-fringe-bmp-function (lambda (type pos) 'my:diff-hl-bitmap))

  ;;; from doom emacs, modules/ui/vc-gutter
  ;; (let* ((scale (if (and (boundp 'text-scale-mode-amount)
  ;;                        (numberp text-scale-mode-amount))
  ;;                   (expt text-scale-mode-step text-scale-mode-amount)
  ;;                 1))
  ;;        (spacing (or (and (display-graphic-p) (default-value 'line-spacing)) 0))
  ;;        (h (+ (ceiling (* (frame-char-height) scale))
  ;;              (if (floatp spacing)
  ;;                  (truncate (* (frame-char-height) spacing))
  ;;                spacing)))
  ;;        (w (min (frame-parameter nil (intern (format "%s-fringe" diff-hl-side)))
  ;;                diff-hl-bmp-max-width))
  ;;        (_ (if (zerop w) (setq w diff-hl-bmp-max-width)
  ;; 	      )))

  ;;   (define-fringe-bitmap 'diff-hl-bmp-middle
  ;;     (make-vector
  ;;      h (string-to-number (let ((half-w (1- (/ w 2))))
  ;;                            (concat (make-string half-w ?1)
  ;;                                    (make-string (- w half-w) ?0)))
  ;;                          2))
  ;;     nil nil 'center))



  ;; (defun +vc-gutter-type-at-pos-fn (type _pos)
  ;;   (if (eq type 'delete)
  ;;       'diff-hl-bmp-delete
  ;;     'diff-hl-bmp-middle))
  ;; (setq diff-hl-fringe-bmp-function #'+vc-gutter-type-at-pos-fn)
  ;; (setq diff-hl-draw-borders nil)

  ;; ;; HACK: diff-hl won't be visible in TTY frames, but there's no simple way to
  ;; ;;   use the fringe in GUI Emacs *and* use the margin in the terminal *AND*
  ;; ;;   support daemon users, so we need more than a static `display-graphic-p'
  ;; ;;   check at startup.
  ;; (if (not (daemonp))
  ;;     (unless (display-graphic-p)
  ;;       (add-hook 'global-diff-hl-mode-hook #'diff-hl-margin-mode))
  ;;   (when my/terminal-p
  ;;     (put 'diff-hl-mode 'last t)
  ;;       (defun +vc-gutter-use-margins-in-tty-h ()
  ;;         (when (bound-and-true-p global-diff-hl-mode)
  ;;           (let ((graphic? (display-graphic-p)))
  ;;             (unless (eq (get 'diff-hl-mode 'last) graphic?)
  ;;               (diff-hl-margin-mode (if graphic? -1 +1))
  ;;               (put 'diff-hl-mode 'last graphic?)))))
  ;; 	(add-hook 'window-selection-change-functions #'+vc-gutter-use-margins-in-tty-h)))



;; STYLE: Redefine fringe bitmaps to be sleeker by making them solid bars (with
;;   no border) that only take up half the horizontal space in the fringe. This
;;   approach lets us avoid robbing fringe space from other packages/modes that
;;   may need benefit from it (like magit, flycheck, or flyspell).
  (if (fboundp 'fringe-mode) (fringe-mode '8))
  (setq-default fringes-outside-margins t)

  (defun +vc-gutter-define-thin-bitmaps-a (&rest _)
    (let* ((scale (if (and (boundp 'text-scale-mode-amount)
                           (numberp text-scale-mode-amount))
                      (expt text-scale-mode-step text-scale-mode-amount)
                    1))
           (spacing (or (and (display-graphic-p) (default-value 'line-spacing)) 0))
           (h (+ (ceiling (* (frame-char-height) scale))
                 (if (floatp spacing)
                     (truncate (* (frame-char-height) spacing))
                   spacing)))

           (w (min (frame-parameter nil (intern (format "%s-fringe" diff-hl-side)))
                   diff-hl-bmp-max-width))
           (_ (if (zerop w) (setq w diff-hl-bmp-max-width))))
      (define-fringe-bitmap 'diff-hl-bmp-middle
        (make-vector
         h (string-to-number (let ((half-w (1- (/ w 2))))
                               (concat (make-string half-w ?1)
                                       (make-string (- w half-w) ?0)))
                             2))
        nil nil 'center)))
  (advice-add #'diff-hl-define-bitmaps :after #'+vc-gutter-define-thin-bitmaps-a)


  (defun +vc-gutter-type-at-pos-fn (type _pos)
    (if (eq type 'delete)
        'diff-hl-bmp-delete
      'diff-hl-bmp-middle))
  (setq diff-hl-fringe-bmp-function #'+vc-gutter-type-at-pos-fn)
  (setq diff-hl-draw-borders nil)

  (defun +vc-gutter-make-diff-hl-faces-transparent-h ()
    (mapc (doom-rpartial #'set-face-background nil)
          '(diff-hl-insert
            diff-hl-delete
            diff-hl-change)))
  ;; (add-hook 'diff-hl-mode-hook #'+vc-gutter-make-diff-hl-faces-transparent-h)

  ;;; 和 flycheck 同时使用，indicator 冲突解决
  (with-eval-after-load 'flycheck
    (setq flycheck-indication-mode 'right-fringe)
    (define-fringe-bitmap 'flycheck-fringe-bitmap-double-arrow
      [16 48 112 240 112 48 16] nil nil 'center))
  )

(my/straight-if-use 'git-timemachine)
(use-package git-timemachine
  :commands (git-timemachine))

;; delta, `magit-diff-refine-hunk' variable as 'all can have similar effect
;; (use-package magit-delta
;;   :straight (:source (melpa))
;;   :hook (magit-mode . magit-delta-mode)
;;   :config
;;   (setq magit-delta-hide-plus-minus-markers t)
;;   (setq magit-delta-default-dark-theme "Monokai Extended")
;;   (setq magit-delta-default-dark-theme "Monokai Extended Darker")
;;   (setq magit-delta-default-dark-theme "Monokai Extended Bright")
;;   (setq magit-delta-default-dark-theme "1337")
;;   (setq magit-delta-default-dark-theme "Github")

;;   (setq magit-delta-delta-args `("--max-line-distance" "0.6"
;;                                  "--true-color" ,(if xterm-color--support-truecolor "always" "never")
;;                                  "--color-only"
;;                                  ;; "--line-numbers"
;;                                  ))

;;   )


(provide 'init-git)
