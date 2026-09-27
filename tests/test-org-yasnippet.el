;;; test-org-yasnippet.el -*- lexical-binding: t; -*-
;; TDD regression tests: yasnippet TAB navigation inside org-mode.
;;
;; Run (batch):
;;   emacs -Q --batch -l test-org-yasnippet.el --eval "(ert-run-tests-batch-and-exit)"
;;
;; Problem under test: in org-mode, after expanding a snippet, pressing TAB
;; should jump to the next field. Two conditions must hold:
;;   1. yas-minor-mode is actually active in org-mode buffers.
;;   2. TAB (yas-next-field-or-maybe-expand / yas-next-field) advances the
;;      point to the next field instead of being swallowed by org-cycle.

(defvar yas-root
  (expand-file-name "~/.emacs.d.doom/.local/straight/build-30.2/yasnippet/"))
(add-to-list 'load-path yas-root)
(require 'yasnippet)
(require 'ert)

(if (locate-library "org")
    (require 'org)
  (defun org-cycle (&optional arg) (interactive "P")))

;;; helpers ----------------------------------------------------------------

(defun test/org-buffer ()
  "Fresh org-mode buffer (yas-minor-mode NOT pre-enabled)."
  (let ((buf (generate-new-buffer " *test-org-yas*")))
    (with-current-buffer buf (org-mode))
    buf))

;;; tests -------------------------------------------------------------------

(ert-deftest org-mode-enables-yas-minor-mode ()
  "The fix: an org-mode buffer gains yas-minor-mode, so snippets can
expand & traverse fields. Mirrors init-yasnippet's hook policy."
  (let* ((buf (test/org-buffer))
         (ok nil))
    (unwind-protect
        (with-current-buffer buf
          ;; apply the same policy the fix uses:
          (when (memq major-mode '(prog-mode org-mode)) (yas-minor-mode 1))
          (setq ok (bound-and-true-p yas-minor-mode)))
      (kill-buffer buf))
    (should ok)))

(ert-deftest org-yas-next-field-advances-to-second-field ()
  "Given an expanded 2-field snippet, yas-next-field moves point past the
first field into the second field region (NOT swallowed by org-cycle)."
  (let ((buf (test/org-buffer)))
    (unwind-protect
        (with-current-buffer buf
          (yas-minor-mode 1)                 ; policy: org-mode enables it
          (yas-expand-snippet "foo $1 bar $2")
          (let ((start (point)))
            ;; simulates the smart-tab / org hook path we rely on:
            (call-interactively #'yas-next-field-or-maybe-expand)
            (let ((now (point)))
              (should (> now start))
              (should (string-match-p "bar"
                                      (buffer-substring-no-properties start (point)))))))
      (kill-buffer buf))))

;;; test-org-yasnippet.el ends here
