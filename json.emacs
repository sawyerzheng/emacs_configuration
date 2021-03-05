;; -*- coding: utf-8; -*-

;; ref: https://stackoverflow.com/a/39864915
(defun json-to-single-line (beg end)
  "Collapse prettified json in region between BEG and END to a single line"
  (interactive "r")
  (if (use-region-p)
      (save-excursion
	(save-restriction
	  (narrow-to-region beg end)
	  (goto-char (point-min))
	  (while (re-search-forward "\\s-+" nil t)
	    (replace-match " "))))
    (print "This function operates on a region")))
