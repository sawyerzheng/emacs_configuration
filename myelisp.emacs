;; -*- coding: utf-8-unix; -*-
;; filename: myelisp.emacs

;;===================== move commands =============================
(defun open-newline-forword ()
   "make a new line, at the end of current line"
   (move-end-of-line t)
   (newline)
   (next-line)
   )


(global-key-binding (kbd "C-S-o") 'open-newline-forword)
;;=================================================================
