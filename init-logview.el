(my/straight-if-use 'logview)

(use-package logview
  :commands (logview-mode)
  :mode (("\\.log\\'" . logview-mode )
	 ("log.out" . logview-mode)
	 )

  :config
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
