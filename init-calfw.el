(provide 'init-calfw)

(use-package calfw
  :straight t
  :config)

(use-package calfw-org
  :straight t
  :commands (cfw:open-org-calendar))

(use-package cal-china-x
  :after calendar
  :straight t ;; (:repo "xwl/cal-china-x" :type git :host github :files ("*"))
  :config
  (setq mark-holidays-in-calendar t)
  (setq cal-china-x-important-holidays cal-china-x-chinese-holidays)
  (setq cal-china-x-general-holidays '((holiday-lunar 1 15 "元宵节")))
  (setq calendar-holidays
        (append cal-china-x-important-holidays
                cal-china-x-general-holidays
                ;; calendar-holidays
                )))
