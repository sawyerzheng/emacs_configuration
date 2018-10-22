;;==================== AucTeX ==========================
;; for parse
(setq TeX-auto-save t)
(setq TeX-parse-self t)

;; for latex, include and input methods
;; it will ask master file for every tex file
;;(setq-default TeX-master nil)

(eval-after-load "tex" ;; for xelatex
  '(add-to-list 'TeX-command-list
     		'("XeLaTeX" "xelatex %s" TeX-run-command t t :help "Run xelatex to output pdf file") t))
(eval-after-load "tex" ;; for xelatex
  '(setq TeX-command-default "XeLaTeX")
  )

(defun xelatex-commands ()
  "for define command in C-c C-c"
  (add-to-list 'TeX-command-list
     	       '("XeLaTeX" ;; "%`xelatex%(mode)%'%t "
		 "xelatex %s" TeX-run-TeX nil t :help "Run xelatex to output pdf file") )
;;  (setq-local TeX-command-default "XeLaTeX")
;;  (setq TeX-command-default "XeLaTeX")
  (setq TeX-save-query nil)
  (setq TeX-show-compilation t)
  )

(add-hook 'LaTeX-mode-hook 'xelatex-commands)


;; customize viewer for pdf, SumatraPDF, windows, CTEX
(if (string-equal system-type "windows-nt")
    (setq TeX-view-program-selection '((output-pdf "SumatraPDF"))))



(load "auctex.el" nil t t)

;; for windows mikTeX
(if (string-equal system-type "windows-nt")
    (require 'tex-mik))
;; for hook
(mapc (lambda (mode)
      (add-hook 'LaTeX-mode-hook mode))
      (list 'auto-fill-mode
            'LaTeX-math-mode
            'turn-on-reftex
;;            'linum-mode
	    ))
;; for auto-complet-auctex
(require 'auto-complete-auctex)


;; my custo history


;; for latex-preview
;;()
;;(load "preview-latex.el" nil t t)

;; for Tex-command-list
;;(eval-after-load "tex" ;; for xelatex
;;  '(add-to-list 'TeX-command-list
;;     		'("XeLaTeX" "xelatex %s" TeX-run-command t t :help "Run xelatex to output pdf file") t))

;;(eval-after-load "tex" ;; for preview  无效，没成功
;;  '(add-to-list 'TeX-command-list
;;     		'("pdfview" "sumatra %o" TeX-run-command t t :help "Run sumatra to view pdf file") t))
;; %s--> file name,  %o for ----> open extension --> filename.pdf

;;(eval-after-load 'tex ;; for xelatex --> TeX-command-default
