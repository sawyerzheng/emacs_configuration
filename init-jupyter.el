;;; init-jupyter.el --- jupyter.el init -*- lexical-binding: t; -*-
;;
;; Copyright (C) 2025
;;
;; Author:  <sawyer@jishutest>
;; Maintainer:  <sawyer@jishutest>
;; Created: July 22, 2025
;; Modified: July 22, 2025
;; Version: 0.0.1
;; Keywords: abbrev bib c calendar comm convenience data docs emulations extensions faces files frames games hardware help hypermedia i18n internal languages lisp local maint mail matching mouse multimedia news outlines processes terminals tex text tools unix vc wp
;; Homepage: https://github.com/sawyerzheng/init-jupyter
;; Package-Requires: ((emacs "24.3"))
;;
;; This file is not part of GNU Emacs.
;;
;;; Commentary:
;;
;;  Description
;;
;;; Code:

(use-package scimax-ob
  :after org
  :commands (scimax-ob/body))

(use-package scimax-jupyter
  :init
  (require 'jupyter-org-client)
  :commands (scimax-jupyter-org-hydra/body)
  :bind (:map jupyter-org-interaction-mode-map
              ("C-c C-h" . scimax-jupyter-org-hydra/body)))

(use-package ob-jupyter
  :after jupyter)

(use-package jupyter
  :after (org ob-core)
  :init
  :config
  (require 'scimax-jupyter)
  (setq jupyter-api-authentication-method 'password)

  (add-to-list 'org-babel-load-languages '(emacs-lisp . t) t)
  (add-to-list 'org-babel-load-languages '(julia . t) t)
  (add-to-list 'org-babel-load-languages '(python . t) t)
  (add-to-list 'org-babel-load-languages '(jupyter . t) t)

  (require 'jupyter-org-extensions)
  (with-eval-after-load 'jupyter-org-extensions
    (when (not my/doom-p)
      (define-key jupyter-org-hydra/keymap (kbd "a") (lambda () (interactive) (jupyter-org-insert-src-block nil current-prefix-arg)))
      (define-key jupyter-org-hydra/keymap (kbd "b") (lambda () (interactive) (jupyter-org-insert-src-block t current-prefix-arg)))
      ))

  :mode-hydra
  (org-mode
   (:title "Org Commands")
   ("Babel"
    (("j" scimax-jupyter-org-hydra/body "Jupyter org hydra"))))

  :config
  (require 'jupyter-org-client)
  (define-key jupyter-org-interaction-mode-map (kbd "M-i") nil)
  (when (not my/doom-p)
    (dolist (lang-info my/org-babel-language-alist)
      ;; (add-to-list 'org-babel-load-languages '(jupyter . t) t)
      (add-to-list 'org-babel-load-languages lang-info t)
      ))

  (with-eval-after-load 'ob-jupyter
    (defun my/org-return (&optional indent arg interactive)

      (interactive "i\nP\np")
      (let* ((context (if org-return-follows-link (org-element-context)
                        (org-element-at-point)))
             (element-type (org-element-type context)))
        (if (eq element-type 'src-block)
            (call-interactively #'org-return-and-maybe-indent)
          (org-return indent arg interactive))))

    (define-key org-mode-map (kbd "RET") #'my/org-return))
  (with-eval-after-load 'org
    (with-eval-after-load 'scimax-ob
      (remove-hook 'org-mode-hook #'scimax-ob-src-key-bindings)))



  ;;   (require 'scimax-jupyter)
  ;;   (add-hook 'org-mode-hook #'scimax-jupyter-ansi)
  ;;   (setq my/scimax-ob-src-key-bindings
  ;;         '(
  ;;           ;; ("<return>" . #'newline-and-indent)
  ;;           ("C-<return>" #'org-ctrl-c-ctrl-c #'org-insert-heading-respect-content)
  ;;           ("S-<return>"  #'scimax-ob-execute-and-next-block #'org-table-copy-down)
  ;;           ("M-<return>"  (lambda ()
  ;; 		           (interactive)
  ;; 		           (scimax-ob-execute-and-next-block t))
  ;;            nil)
  ;;           ("M-S-<return>" #'scimax-ob-execute-to-point #'org-insert-todo-heading)
  ;;           ("C-M-<return>" #'org-babel-execute-buffer nil)
  ;;           ;; ("s-." . #'scimax-ob/body nil)
  ;;           )
  ;;         )

  ;;   (defmacro my/scimax-ob-define-src-key (language key def default-def)
  ;;     "For LANGUAGE (symbol) src blocks, define key sequence KEY as DEF.
  ;; KEY should be a string sequence that will be used in a `kbd' sequence.
  ;; This is like `define-key', except the definition only applies in
  ;; src blocks for a specific LANGUAGE.

  ;; If language is nil apply to all src-blocks.

  ;; Adapted from
  ;; http://endlessparentheses.com/define-context-aware-keys-in-emacs.html"
  ;;     (declare (indent 3)
  ;; 	     (debug (form form form &rest sexp)))
  ;;     ;; ;; store the key in scimax-src-keys
  ;;     ;; (unless (cdr (assoc language scimax-ob-src-keys))
  ;;     ;;   (cl-pushnew (list language '()) scimax-ob-src-keys))

  ;;     ;; (cl-pushnew (cons key def) (cdr (assoc language scimax-ob-src-keys)))

  ;;     `(define-key org-mode-map ,(kbd key)
  ;;                  '(menu-item
  ;;                    ,(format "maybe-%s" (or (car (cdr-safe def)) def))
  ;;                    nil
  ;;                    :filter (lambda (&optional _)
  ;; 		             ,(if language
  ;; 		                  `(when (and (org-in-src-block-p)
  ;; 				              (string= ,(symbol-name language)
  ;; 					               (car (org-babel-get-src-block-info t))))
  ;; 			             ,def)
  ;; 		                `(cond ((org-in-src-block-p)
  ;; 		                        ,def)
  ;;                                        (t
  ;;                                         ,default-def)))))))

  ;;   (defun my/scimax-ob-src-key-bindings ()
  ;;     "context key binding, but still use original command when no in a org src code block"
  ;;     ;; These should work in every src-block IMO.
  ;;     (cl-loop for (key  cmd default-cmd) in my/scimax-ob-src-key-bindings
  ;; 	     do
  ;; 	     (eval `(my/scimax-ob-define-src-key nil ,key ,cmd ,default-cmd))))

  ;;   (add-hook 'org-mode-hook #'my/scimax-ob-src-key-bindings)

  ;;   (define-key org-mode-map (kbd "M-' M-'") #'scimax-jupyter-org-hydra/body)
  ;;   (define-key org-mode-map (kbd "M-\"") #'scimax-jupyter-org-hydra/body)

  ;; (defalias 'org-babel-execute:python 'org-babel-execute:jupyter-python)

  ;; treesit patch, ref: https://github.com/emacs-jupyter/jupyter/issues/478
  ;; (org-babel-jupyter-override-src-block "python")
  ;; To ensure python src blocks are opened in python-ts-mode
  ;; (setf (alist-get "python" org-src-lang-modes nil nil #'equal) 'python-ts)
  ;; (setf (alist-get "python" org-src-lang-modes nil nil #'equal) 'python)

  ;; my patch
  (defun jupyter-repl-associate-buffer (client)
    "Associate the `current-buffer' with a REPL CLIENT.
If the `major-mode' of the `current-buffer' is the
`jupyter-repl-lang-mode' of CLIENT, call the function
`jupyter-repl-interaction-mode' to enable the corresponding mode.

CLIENT should be the symbol `jupyter-repl-client' or the symbol
of a subclass.  If CLIENT is a buffer or the name of a buffer, use
the `jupyter-current-client' local to the buffer."
    (interactive
     (list
      (when-let* ((buffer (jupyter-repl-completing-read-repl-buffer major-mode)))
        (buffer-local-value 'jupyter-current-client buffer))))
    (if (not client)
        (when (y-or-n-p "No REPL for `major-mode' exists.  Start one? ")
          (call-interactively #'jupyter-run-repl))
      (setq client (if (or (bufferp client) (stringp client))
                       (with-current-buffer client
                         jupyter-current-client)
                     client))
      (unless (object-of-class-p client 'jupyter-repl-client)
        (error "Not a REPL client (%s)" client))
      (let ((client-major-mode (jupyter-kernel-language-mode client)))
        (cond ((and (eq client-major-mode 'python-ts-mode)
                    (eq major-mode 'python-mode)
                    )
               nil)
              (t
               (unless (eq (jupyter-kernel-language-mode client) major-mode)
                 (error "Cannot associate buffer to REPL.  Wrong `major-mode'"))))
        )

      (setq-local jupyter-current-client client)
      (unless jupyter-repl-interaction-mode
        (jupyter-repl-interaction-mode))))

  )
(when (not my/doom-p)

  (use-package ob-jupyter
    :after ob-core
    :init
    (with-eval-after-load 'ob-async
      (dolist (elt ("jupyter-python" "jupyter-julia" "jupyter-R"))
        (pushnew elt ob-async-no-async-languages-alist))))

  ;; add jupyter-python, ...
  (with-eval-after-load 'org-src
    (dolist (lang '(python julia R))
      (cl-pushnew (cons (format "jupyter-%s" lang) lang)
                  org-src-lang-modes :key #'car)))
  )



;; (with-eval-after-load 'org
;;   (require 'jupyter)
;;   ;; (require 'ob-jupyter)
;;   ;; (require 'scimax-jupyter)
;;   )

;;; fix wrong marker error when using jupyter-completion-at-point inside `org-mode'
(with-eval-after-load 'jupyter-org-client
  (defun jupyter-org--set-src-block-cache ()
    "Set the src-block cache.
If set successfully or if `point' is already inside the cached
source block, return non-nil.  Otherwise, when `point' is not
inside a Jupyter src-block, return nil."
    (unless jupyter-org--src-block-cache
      (setq jupyter-org--src-block-cache
            (list 'invalid nil (make-marker)
                  (let ((end (make-marker)))
                    ;; Move the end marker when text is inserted
                    (set-marker-insertion-type end t)
                    end))))
    (if (org-in-src-block-p 'inside)
        (or (jupyter-org--at-cached-src-block-p)
            (when-let* ((el (org-element-at-point))
                        (info (and (eq (org-element-type el) 'src-block)
                                   (org-babel-jupyter-language-p
                                    (org-element-property :language el))
                                   (org-babel-get-src-block-info t el)))
                        (params (nth 2 info)))
              (when (eq (car jupyter-org--src-block-cache) 'invalid)
                (pop jupyter-org--src-block-cache))
              (pcase-let (((and cache `(,_ ,beg ,end))
                           jupyter-org--src-block-cache))
                (setcar cache params)
                (save-excursion
                  (goto-char (org-element-property :post-affiliated el))
                  (move-marker beg (line-beginning-position 2))
                  (goto-char (org-element-property :end el))
                  (skip-chars-backward "\r\n")
                  (move-marker end (line-beginning-position))))
              t))
      ;; Invalidate cache when going outside of a source block.  This
      ;; way if the language of the block changes we don't end up using
      ;; the cache since it is only used for Jupyter blocks.
      (pcase jupyter-org--src-block-cache
        ((and `(,x . ,_) (guard (not (eq x 'invalid))))
         (push 'invalid jupyter-org--src-block-cache)))
      nil)))


(use-package ob-async
  :defer t
  :config
  (setq ob-async-no-async-languages-alist '("jupyter-python" "jupyter-julia")))

(when (boundp 'native-comp-jit-compilation-deny-list)
  (add-to-list 'native-comp-jit-compilation-deny-list ".*jupyter.*"))

(defun my/org-babel-lazy-load-language-advice (orig-fun &rest args)
  (let* ((info (nth 1 args))
	 (lang (nth 0 info))
	 (alist))
    (message "language: %s, args: %s, orig-fun: %s" lang args orig-fun)
    (unless (assoc lang org-babel-load-languages)
      (if (or (eq lang 'jupyter-python) (eq lang 'jupyter-julia))
	  (setq alist '((julia . t)
			(python . t)
			(jupyter . t)))
	(list (cons lang t))))
    (org-babel-do-load-languages
     'org-babel-load-in-session
     alist))
  (apply orig-fun args))

(with-eval-after-load 'ob-core
  (advice-add 'org-babel-execute-src-block :around #'my/org-babel-lazy-load-language-advice))


(provide 'init-jupyter)
;;; init-jupyter.el ends here
