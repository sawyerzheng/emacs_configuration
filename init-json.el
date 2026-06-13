;;; init-json.el --- Description -*- lexical-binding: t; -*-
;;
;; Copyright (C) 2026 sawyer
;;
;; Author: sawyer <sawyer@helium>
;; Maintainer: sawyer <sawyer@helium>
;; Created: May 06, 2026
;; Modified: May 06, 2026
;; Version: 0.0.1
;; Keywords: abbrev bib c calendar comm convenience data docs emulations extensions faces files frames games hardware help hypermedia i18n internal languages lisp local maint mail matching mouse multimedia news outlines processes terminals tex text tools unix vc wp
;; Homepage: https://github.com/sawyerzheng/init-json
;; Package-Requires: ((emacs "24.3"))
;;
;; This file is not part of GNU Emacs.
;;
;;; Commentary:
;;
;;  Description
;;
;;; Code:

;;;###autoload
(defun my/json-unwrap-string-at-point ()
  "Extract the JSON string value under cursor, unescape it, and display in a temp buffer."
  (interactive)
  (let* ((bounds (json-unwrap--find-string-bounds))
         (raw (and bounds (buffer-substring-no-properties (car bounds) (cdr bounds))))
         (unescaped (and raw (json-unwrap--unescape raw)))
         (buf-name "*json-unwrap-text*"))
    (if unescaped
        (progn
          (with-current-buffer (get-buffer-create buf-name)
            (erase-buffer)
            (insert unescaped)
            ;; Try to detect and enable a suitable major mode
            (json-unwrap--maybe-set-mode unescaped)
            (goto-char (point-min)))
          (pop-to-buffer buf-name))
      (message "No JSON string found at point"))))

(defun json-unwrap--find-string-bounds ()
  "Find the bounds of the JSON string value at point.
Returns (start . end) of content INSIDE the quotes, or nil."
  (save-excursion
    (let ((pos (point)))
      ;; If we're already on a quote, move inside
      (when (eq (char-after) ?\")
        (forward-char 1))
      ;; Search backward for the opening quote, skipping escaped quotes
      (let ((found-open nil)
            (search-start (point)))
        ;; Walk backward to find unescaped opening quote
        (goto-char pos)
        (when (eq (char-after) ?\")
          (setq found-open t)
          (forward-char 1))
        (unless found-open
          ;; Try to find enclosing string by going backward
          (let ((continue t))
            (while (and continue (search-backward "\"" nil t))
              (let ((num-backslashes 0)
                    (check-pos (1- (point))))
                (while (and (>= check-pos (point-min))
                            (eq (char-after check-pos) ?\\))
                  (cl-incf num-backslashes)
                  (cl-decf check-pos))
                (when (evenp num-backslashes)
                  (setq found-open t
                        continue nil))))))
        (when found-open
          (let ((open-pos (1+ (point))))
            ;; Now find the closing quote
            (goto-char open-pos)
            (let ((close-pos nil)
                  (continue t))
              (while (and continue (search-forward "\"" nil t))
                (let ((num-backslashes 0)
                      (check-pos (- (point) 2)))
                  (while (and (>= check-pos (point-min))
                              (eq (char-after check-pos) ?\\))
                    (cl-incf num-backslashes)
                    (cl-decf check-pos))
                  (when (evenp num-backslashes)
                    (setq close-pos (1- (point))
                          continue nil))))
              (when close-pos
                (cons open-pos close-pos)))))))))

(defun json-unwrap--maybe-set-mode (content)
  "Try to detect content type and set an appropriate major mode."
  (cond
   ((string-match-p "\\`\\s-*[{\[]" content) (json-mode))
   ((string-match-p "#!.*python\\|import \\|def \\|class " content) (python-mode))
   ((string-match-p "#!.*bash\\|#!/bin/sh" content) (sh-mode))
   (t (text-mode))))

(defun json-unwrap--unescape (s)
  "Unescape a JSON string value via single-pass scan."
  (let ((result (make-string 0 0))
        (i 0)
        (len (length s)))
    (while (< i len)
      (let ((ch (aref s i)))
        (if (and (eq ch ?\\) (< (1+ i) len))
            (let ((next (aref s (1+ i))))
              (setq result
                    (concat result
                            (pcase next
                              (?n  "\n")
                              (?t  "\t")
                              (?r  "\r")
                              (?\\  "\\")
                              (?\"  "\"")
                              (?/  "/")
                              (?b  "\b")
                              (?f  "\f")
                              (?u  ;; \uXXXX
                               (if (< (+ i 5) len)
                                   (let ((hex (substring s (+ i 2) (+ i 6))))
                                     (setq i (+ i 4))
                                     (string (string-to-number hex 16)))
                                 ""))
                              (_   (string next)))))
              (setq i (+ i 2)))
          (setq result (concat result (string ch)))
          (setq i (1+ i)))))
    result))

(provide 'init-json)
;;; init-json.el ends here
