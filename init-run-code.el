;; for run or compile the code
;; http://ergoemacs.org/emacs/elisp_run_current_file.html

(define-minor-mode my-qexit-mode
  "Minor mode to keymap `q' to quit-window"
  :init-value nil
  ;; (interactive (list (or current-prefix-arg 'toggle)))
  ;; (let ((enable
  ;; 	 (if (eq arg 'toggle)
  ;; 	     (not foo-mode) ; this is the mode’s mode variable
  ;; 	   (> (prefix-numeric-value arg) 0))))
  ;;   ))
  :keymap
  '(("q" . quit-window)))


(defvar xah-run-current-file-before-hook nil "Hook for `xah-run-current-file'. Before the file is run.")

(defvar xah-run-current-file-after-hook nil "Hook for `xah-run-current-file'. After the file is run.")

(defun xah-run-current-go-file ()
  "Run or build current golang file.

To build, call `universal-argument' first.

Version 2018-10-12"
  (interactive)
  (when (not (buffer-file-name)) (save-buffer))
  (when (buffer-modified-p) (save-buffer))
  (let* (
         ($outputb "*xah-run output*")
         (resize-mini-windows nil)
         ($fname (buffer-file-name))
         ($fSuffix (file-name-extension $fname))
         ($prog-name "go")
         $cmd-str)
    (setq $cmd-str (concat $prog-name " \""   $fname "\" &"))
    (if current-prefix-arg
        (progn
          (setq $cmd-str (format "%s build \"%s\" " $prog-name $fname)))
      (progn
        (setq $cmd-str (format "%s run \"%s\" &" $prog-name $fname))))
    (progn
      (message "running %s" $fname)
      (message "%s" $cmd-str)
      (shell-command $cmd-str $outputb )
      ;;
      )
    ))

(defun xah-run-current-file ()
  "Execute the current file.
For example, if the current buffer is x.py, then it'll call 「python x.py」 in a shell.
Output is printed to buffer “*xah-run output*”.

The file can be Emacs Lisp, PHP, Perl, Python, Ruby, JavaScript, TypeScript, golang, Bash, Ocaml, Visual Basic, TeX, Java, Clojure.
File suffix is used to determine what program to run.

If the file is modified or not saved, save it automatically before run.

URL `http://ergoemacs.org/emacs/elisp_run_current_file.html'
Version 2018-10-12"
  (interactive)
  (let (
        ($outputb "*xah-run output*")
        (resize-mini-windows nil)
        ($suffix-map
         ;; (‹extension› . ‹shell program name›)
         `(
           ("php" . "php")
           ("pl" . "perl")
           ("py" . "python")
           ;; ("py3" . ,(if (string-equal system-type "windows-nt") "c:/Python32/python.exe" "python3"))
	   ("py3". "python3")
           ("rb" . "ruby")
           ("go" . "go run")
           ("hs" . "runhaskell")
           ("js" . "node")
           ("mjs" . "node --experimental-modules ")
           ("ts" . "tsc") ; TypeScript
           ("tsx" . "tsc")
           ("sh" . "bash")
           ("clj" . "java -cp ~/apps/clojure-1.6.0/clojure-1.6.0.jar clojure.main")
           ("rkt" . "racket")
           ("ml" . "ocaml")
           ("vbs" . "cscript")
           ("tex" . "pdflatex")
           ("latex" . "pdflatex")
           ("java" . "javac")
           ;; ("pov" . "/usr/local/bin/povray +R2 +A0.1 +J1.2 +Am2 +Q9 +H480 +W640")
           ))
        $fname
        $fSuffix
        $prog-name
        $cmd-str)
    (when (not (buffer-file-name)) (save-buffer))
    (when (buffer-modified-p) (save-buffer))
    (setq $fname (buffer-file-name))
    (setq $fSuffix (file-name-extension $fname))
    (setq $prog-name (cdr (assoc $fSuffix $suffix-map)))
    (setq $cmd-str (concat $prog-name " \""   $fname "\" &"))
    (run-hooks 'xah-run-current-file-before-hook)

    (setq $outputbBuff (get-buffer-create $outputb))
    (with-current-buffer $outputb
      (my-qexit-mode 1))

    (cond
     ((string-equal $fSuffix "el")
      (load $fname))
     ((or (string-equal $fSuffix "ts") (string-equal $fSuffix "tsx"))
      (if (fboundp 'xah-ts-compile-file)
          (progn
            (xah-ts-compile-file current-prefix-arg))
        (if $prog-name
            (progn
              (message "Running")
              (shell-command $cmd-str $outputb ))
          (error "No recognized program file suffix for this file."))))
     ((string-equal $fSuffix "go")
      (xah-run-current-go-file))
     ((string-equal $fSuffix "java")
      (progn
        (shell-command (format "java %s" (file-name-sans-extension (file-name-nondirectory $fname))) $outputb )))
     (t (if $prog-name
            (progn
              (message "Running")
              (shell-command $cmd-str $outputb ))
          (error "No recognized program file suffix for this file."))))
    (run-hooks 'xah-run-current-file-after-hook)
    ;; (with-current-buffer $outputb
    ;;   (my-qexit-mode 1))

    ;; (with-current-buffer $outputb
    ;;   (ignore-errors
    ;; 	(shell-mode -1)
    ;; 	;; (compilation-mode)
    ;; 	;; (read-only-mode -1)
    ;; 	)
    ;;   (local-set-key (kbd "q") 'quit-window))

    ;; (with-current-buffer $outputb
    ;;   (if (equal (buffer-name) "*xah-run output*")
    ;;   	  (progn
    ;;   	    ;; (message (buffer-name))
    ;;   	    (local-unset-key (kbd "q"))
    ;;   	    (local-set-key (kbd "q") 'quit-window)
    ;;   	    )
    ;;   	(progn
    ;;   	  (local-unset-key (kbd "q"))
    ;;   	  (local-set-key (kbd "q") 'self-insert-command))
    ;;   	)
    ;;   )
    ))

;;(global-key-binding "<")

;; key binding
(global-set-key (kbd "<f6>") 'xah-run-current-file)


(add-hook 'xah-run-current-file-after-hook
	  (lambda ()
	    (if (equal (buffer-name) "*xah-run output*")
		(local-set-key (kbd "q") 'quit-window)
	      (progn
		(local-unset-key (kbd "q"))
		(local-set-key (kbd "q") 'self-insert-command)))))


(provide 'init-run-code)
