(provide 'init-ligature)

;; 参考：https://github.com/mickeynp/ligature.el/wiki
(use-package ligature
  :straight (:type git :host github :repo "mickeynp/ligature.el")
  :config
  (ligature-set-ligatures 't '(
                               ;; arrows
                               "==>"
                               "<=="
                               ;; "-->" ;; not suitable for html and markdown mode
                               ;; "<--"
                               ;; "->"
                               ;; "<-"
                               "~>"
                               "<~"
                               "~~>"
                               "<~~"
                               "<==>"
                               ))

  (ligature-set-ligatures '(python-mode) '(
                                           ;; arrows
                                           "-->" ;; not suitable for html and markdown mode
                                           "<--"
                                           "->"
                                           "<-"

                                           ;; equals
                                           "!="
                                           ":="
                                           ">="
                                           "<="
                                           "=="

                                           "//"

                                           ))
  ;; (ligature-set-ligatures
  ;;  'prog-mode
  ;;  '("|||>" "<|||" "<==>" "<!--" "####" "~~>" "***" "||=" "||>"
  ;;    ":::" "::=" "=:=" "===" "==>" "=!=" "=>>" "=<<" "=/=" "!=="
  ;;    "!!." ">=>" ">>=" ">>>" ">>-" ">->" "->>" "-->" "---" "-<<"
  ;;    "<~~" "<~>" "<*>" "<||" "<|>" "<$>" "<==" "<=>" "<=<" "<->"
  ;;    "<--" "<-<" "<<=" "<<-" "<<<" "<+>" "</>" "###" "#_(" "..<"
  ;;    "..." "+++" "/==" "///" "_|_" "www" "&&" "^=" "~~" "~@" "~="
  ;;    "~>" "~-" "**" "*>" "*/" "||" "|}" "|]" "|=" "|>" "|-" "{|"
  ;;    "[|" "]#" "::" ":=" ":>" ":<" "$>" "==" "=>" "!=" "!!" ">:"
  ;;    ">=" ">>" ">-" "-~" "-|" "->" "--" "-<" "<~" "<*" "<|" "<:"
  ;;    "<$" "<=" "<>" "<-" "<<" "<+" "</" "#{" "#[" "#:" "#=" "#!"
  ;;    "##" "#(" "#?" "#_" "%%" ".=" ".-" ".." ".?" "+>" "++" "?:"
  ;;    "?=" "?." "??" ";;" "/*" "/=" "/>" "//" "__" "~~" "(*" "*)"
  ;;    "\\\\" "://"))
  :hook ((prog-mode org-mode markdown-mode gfm-mode)  . ligature-mode)
  )


(with-eval-after-load 'prog-mode

  (add-hook 'python-mode-hook #'(lambda ()
                                  (add-to-list 'python--prettify-symbols-alist '("->" . ?→)))))
