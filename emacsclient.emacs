;; -*- coding: utf-8; -*-

;;(server-start)
;; 这一句必不可少，不然报错
;; 找不到server-running-p function
(require 'server)
;; 这一部分也不能少，不然windows 会每次都启动一个server
(unless (server-running-p)
  (server-start))

;; =============== to start emacs server-name 启动 ==================
;; **** "emacs --daemon" ****

;; =============  shutdown emacs server 关闭  =======================
;; define function to shutdown emacs server instance
(defun server-shutdown ()
  "Save buffers, Quit, and Shutdown (kill) server"
  (interactive)
  (save-some-buffers)
  (kill-emacs);; kill-emacs 强制退出emacs server
  )
;; or use a command 外部命令
;; *** emacsclient -e '(kill-emacs)' *** --> 强制关闭
;; *** emacsclient -e '(client-save-kill-emacs)' *** 提示后，关闭


;; =========== relevant function definitions ================
(defun client-save-kill-emacs(&optional display)
  " This is a function that can bu used to shutdown save buffers and 
shutdown the emacs daemon. It should be called using 
emacsclient -e '(client-save-kill-emacs)'.  This function will
check to see if there are any modified buffers or active clients
or frame.  If so an x window will be opened and the user will
be prompted."

  (let (new-frame modified-buffers active-clients-or-frames)

					; Check if there are modified buffers or active clients or frames.
    (setq modified-buffers (modified-buffers-exist))
    (setq active-clients-or-frames ( or (> (length server-clients) 1)
					(> (length (frame-list)) 1)
					))  

					; Create a new frame if prompts are needed.
    (when (or modified-buffers active-clients-or-frames)
      (when (not (eq window-system 'x))
	(message "Initializing x windows system.")
	(x-initialize-window-system))
      (when (not display) (setq display (getenv "DISPLAY")))
      (message "Opening frame on display: %s" display)
      (select-frame (make-frame-on-display display '((window-system . x)))))

					; Save the current frame.  
    (setq new-frame (selected-frame))


					; When displaying the number of clients and frames: 
					; subtract 1 from the clients for this client.
					; subtract 2 from the frames this frame (that we just created) and the default frame.
    (when ( or (not active-clients-or-frames)
	       (yes-or-no-p (format "There are currently %d clients and %d frames. Exit anyway?" (- (length server-clients) 1) (- (length (frame-list)) 2)))) 
      
					; If the user quits during the save dialog then don't exit emacs.
					; Still close the terminal though.
      (let((inhibit-quit t))
					; Save buffers
	(with-local-quit
	  (save-some-buffers)) 
	
	(if quit-flag
	    (setq quit-flag nil)  
					; Kill all remaining clients
	  (progn
	    (dolist (client server-clients)
	      (server-delete-client client))
					; Exit emacs
	    (kill-emacs))) 
	))

					; If we made a frame then kill it.
    (when (or modified-buffers active-clients-or-frames) (delete-frame new-frame))
    )
  )


(defun modified-buffers-exist() 
  "This function will check to see if there are any buffers
that have been modified.  It will return true if there are
and nil otherwise. Buffers that have buffer-offer-save set to
nil are ignored."
  (let (modified-found)
    (dolist (buffer (buffer-list))
      (when (and (buffer-live-p buffer)
		 (buffer-modified-p buffer)
		 (not (buffer-base-buffer buffer))
		 (or
		  (buffer-file-name buffer)
		  (progn
		    (set-buffer buffer)
		    (and buffer-offer-save (> (buffer-size) 0))))
		 )
	(setq modified-found t)
	)
      )
    modified-found
    )
  )

;;============ customize theme for daemon ==============
(setq theme 'tsdh-dark)
(if (daemonp)
    (add-hook 'after-make-frame-functions
        (lambda (frame)
            (with-selected-frame frame
                (load-theme theme t))))
    (load-theme theme t))

;;============== variables  ============================
(if (daemonp)
    (custom-set-variables
     '(lsp-ui-doc-enable t)
     '(lsp-ui-doc-max-height 20)
     '(lsp-ui-doc-max-width 80)
     '(lsp-ui-doc-position (quote at-point))
     '(lsp-ui-imenu-enable t)
     '(lsp-ui-peek-enable t)
     '(lsp-ui-sideline-enable t)
     '(magit-diff-use-overlays t)
     ))

;;================= for windows system ====================
;; http://jixiuf.github.io/blog/windows%E4%B8%8Aemacs%E7%9A%84%E5%AE%89%E8%A3%85%E5%8F%8Aemacsclient%E8%BF%9B%E8%A1%8Cc-s%E8%BF%9E%E6%8E%A5/
;; for env variable of windows system
;; (if (eq system-type 'windows-nt)
;;     (progn
;;       (setq server-auth-dir "d:\\home\\")
;;       (setq server-name "emacs-server-file")
;;       (server-start)))
