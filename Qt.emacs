;; this is for Windows
(setenv "QTDIR" "D:\\Qt\\Qt5.10.1\\5.10.1\\mingw53_32\\") 
(setq qt-base-directory "C:\\QtSDK\\") "D:\\Qt\\Qt5.10.1\\Tools\\mingw530_32"
(setenv "PATH" (concat (concat (getenv "QTDIR") "bin" ) "; " (getenv "PATH")))
(setenv "PATH" (concat (concat qt-base-directory "\\bin") ";" (getenv "PATH")))
(setenv "PATH" (concat (concat qt-base-directory "\\lib")
		        ";" (getenv "PATH")))
