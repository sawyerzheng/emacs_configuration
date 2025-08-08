(use-package logview
  :commands (logview-mode)
  :mode (("\\.log\\'" . logview-mode )
	 ("log.out" . logview-mode)
	 )

  :config
  ;; disable background color for info entry
  (set-face-attribute 'logview-information-entry nil :background 'unspecified)

  ;; loguru
  (setq logview-additional-submodes 
	'(("loguru" 
	   (format . "TIMESTAMP | LEVEL | NAME -")
	   (levels . "loguru")
	   (aliases  "python loguru")
	   )
	  )
	)
  (setq logview-additional-level-mappings
	'(("python" .
	   ((error       "ERROR" "CRITICAL")
            (warning     "WARNING")
            (information "INFO" "SUCCESS")
            (debug       "DEBUG")
            (trace       "TRACE")
            (aliases     "loguru"))
	   )))
  )


(provide 'init-logview)
