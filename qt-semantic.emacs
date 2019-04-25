;;================ Qt 5 completion ====================================
(when (eq system-type 'windows-nt)
  (setq qt5-base-dir "D:/Qt/Qt5.10.1/5.10.1/mingw53_32/include")
  (semantic-add-system-include qt5-base-dir 'c++-mode)
  (add-to-list 'auto-mode-alist (cons qt5-base-dir 'c++-mode))
;;  (add-to-list 'semantic-lex-c-preprocessor-symbol-file (concat qt5-base-dir "/QtCore/qconfig.h"))
  (setq  semantic-lex-c-preprocessor-symbol-file (list (concat qt5-base-dir "/QtCore/qconfig.h")))  
(add-to-list 'semantic-lex-c-preprocessor-symbol-file (concat qt5-base-dir "/QtCore/qglobal-dist.h"))
  (add-to-list 'semantic-lex-c-preprocessor-symbol-file (concat qt5-base-dir "/QtCore/qglobal.h"))
  )
;;====== Qt include files ======
(defconst qt-win-inclue-dirs
  (list "D:/Qt/Qt5.10.1/5.10.1/mingw53_32/include"
	"D:/Qt/Qt5.10.1/5.10.1/mingw53_32/include/ActiveQt"
	"D:/Qt/Qt5.10.1/5.10.1/mingw53_32/include/Qt3DAnimation"
	"D:/Qt/Qt5.10.1/5.10.1/mingw53_32/include/Qt3DCore"
	"D:/Qt/Qt5.10.1/5.10.1/mingw53_32/include/Qt3DExtras"
	"D:/Qt/Qt5.10.1/5.10.1/mingw53_32/include/Qt3DInput"
	"D:/Qt/Qt5.10.1/5.10.1/mingw53_32/include/Qt3DLogic"
	"D:/Qt/Qt5.10.1/5.10.1/mingw53_32/include/Qt3DQuick"
	"D:/Qt/Qt5.10.1/5.10.1/mingw53_32/include/Qt3DQuickAnimation"
	"D:/Qt/Qt5.10.1/5.10.1/mingw53_32/include/Qt3DQuickExtras"
	"D:/Qt/Qt5.10.1/5.10.1/mingw53_32/include/Qt3DQuickInput"
	"D:/Qt/Qt5.10.1/5.10.1/mingw53_32/include/Qt3DQuickRender"
	"D:/Qt/Qt5.10.1/5.10.1/mingw53_32/include/Qt3DQuickScene2D"
	"D:/Qt/Qt5.10.1/5.10.1/mingw53_32/include/Qt3DRender"
	"D:/Qt/Qt5.10.1/5.10.1/mingw53_32/include/QtAccessibilitySupport"
	"D:/Qt/Qt5.10.1/5.10.1/mingw53_32/include/QtANGLE"
	"D:/Qt/Qt5.10.1/5.10.1/mingw53_32/include/QtBluetooth"
	"D:/Qt/Qt5.10.1/5.10.1/mingw53_32/include/QtConcurrent"
	"D:/Qt/Qt5.10.1/5.10.1/mingw53_32/include/QtCore"
	"D:/Qt/Qt5.10.1/5.10.1/mingw53_32/include/QtDBus"
	"D:/Qt/Qt5.10.1/5.10.1/mingw53_32/include/QtDesigner"
	"D:/Qt/Qt5.10.1/5.10.1/mingw53_32/include/QtDesignerComponents"
	"D:/Qt/Qt5.10.1/5.10.1/mingw53_32/include/QtDeviceDiscoverySupport"
	"D:/Qt/Qt5.10.1/5.10.1/mingw53_32/include/QtEdidSupport"
	"D:/Qt/Qt5.10.1/5.10.1/mingw53_32/include/QtEglSupport"
	"D:/Qt/Qt5.10.1/5.10.1/mingw53_32/include/QtEventDispatcherSupport"
	"D:/Qt/Qt5.10.1/5.10.1/mingw53_32/include/QtFbSupport"
	"D:/Qt/Qt5.10.1/5.10.1/mingw53_32/include/QtFontDatabaseSupport"
	"D:/Qt/Qt5.10.1/5.10.1/mingw53_32/include/QtGamepad"
	"D:/Qt/Qt5.10.1/5.10.1/mingw53_32/include/QtGui"
	"D:/Qt/Qt5.10.1/5.10.1/mingw53_32/include/QtHelp"
	"D:/Qt/Qt5.10.1/5.10.1/mingw53_32/include/QtLocation"
	"D:/Qt/Qt5.10.1/5.10.1/mingw53_32/include/QtMultimedia"
	"D:/Qt/Qt5.10.1/5.10.1/mingw53_32/include/QtMultimediaQuick"
	"D:/Qt/Qt5.10.1/5.10.1/mingw53_32/include/QtMultimediaWidgets"
	"D:/Qt/Qt5.10.1/5.10.1/mingw53_32/include/QtNetwork"
	"D:/Qt/Qt5.10.1/5.10.1/mingw53_32/include/QtNfc"
	"D:/Qt/Qt5.10.1/5.10.1/mingw53_32/include/QtOpenGL"
	"D:/Qt/Qt5.10.1/5.10.1/mingw53_32/include/QtOpenGLExtensions"
	"D:/Qt/Qt5.10.1/5.10.1/mingw53_32/include/QtPacketProtocol"
	"D:/Qt/Qt5.10.1/5.10.1/mingw53_32/include/QtPlatformCompositorSupport"
	"D:/Qt/Qt5.10.1/5.10.1/mingw53_32/include/QtPlatformHeaders"
	"D:/Qt/Qt5.10.1/5.10.1/mingw53_32/include/QtPositioning"
	"D:/Qt/Qt5.10.1/5.10.1/mingw53_32/include/QtPrintSupport"
	"D:/Qt/Qt5.10.1/5.10.1/mingw53_32/include/QtQml"
	"D:/Qt/Qt5.10.1/5.10.1/mingw53_32/include/QtQmlDebug"
	"D:/Qt/Qt5.10.1/5.10.1/mingw53_32/include/QtQuick"
	"D:/Qt/Qt5.10.1/5.10.1/mingw53_32/include/QtQuickControls2"
	"D:/Qt/Qt5.10.1/5.10.1/mingw53_32/include/QtQuickParticles"
	"D:/Qt/Qt5.10.1/5.10.1/mingw53_32/include/QtQuickTemplates2"
	"D:/Qt/Qt5.10.1/5.10.1/mingw53_32/include/QtQuickTest"
	"D:/Qt/Qt5.10.1/5.10.1/mingw53_32/include/QtQuickWidgets"
	"D:/Qt/Qt5.10.1/5.10.1/mingw53_32/include/QtScxml"
	"D:/Qt/Qt5.10.1/5.10.1/mingw53_32/include/QtSensors"
	"D:/Qt/Qt5.10.1/5.10.1/mingw53_32/include/QtSerialBus"
	"D:/Qt/Qt5.10.1/5.10.1/mingw53_32/include/QtSerialPort"
	"D:/Qt/Qt5.10.1/5.10.1/mingw53_32/include/QtSql"
	"D:/Qt/Qt5.10.1/5.10.1/mingw53_32/include/QtSvg"
	"D:/Qt/Qt5.10.1/5.10.1/mingw53_32/include/QtTest"
	"D:/Qt/Qt5.10.1/5.10.1/mingw53_32/include/QtTextToSpeech"
	"D:/Qt/Qt5.10.1/5.10.1/mingw53_32/include/QtThemeSupport"
	"D:/Qt/Qt5.10.1/5.10.1/mingw53_32/include/QtUiPlugin"
	"D:/Qt/Qt5.10.1/5.10.1/mingw53_32/include/QtUiTools"
	"D:/Qt/Qt5.10.1/5.10.1/mingw53_32/include/QtWebChannel"
	"D:/Qt/Qt5.10.1/5.10.1/mingw53_32/include/QtWebSockets"
	"D:/Qt/Qt5.10.1/5.10.1/mingw53_32/include/QtWidgets"
	"D:/Qt/Qt5.10.1/5.10.1/mingw53_32/include/QtWinExtras"
	"D:/Qt/Qt5.10.1/5.10.1/mingw53_32/include/QtXml"
	"D:/Qt/Qt5.10.1/5.10.1/mingw53_32/include/QtXmlPatterns"
	))


(setq qt5-headers '("/usr/include/x86_64-linux-gnu/qt5/QtConcurrent" 
		    "/usr/include/x86_64-linux-gnu/qt5/QtCore" 
		    "/usr/include/x86_64-linux-gnu/qt5/QtDBus" 
		    "/usr/include/x86_64-linux-gnu/qt5/QtGui" 
		    "/usr/include/x86_64-linux-gnu/qt5/QtNetwork" 
		    "/usr/include/x86_64-linux-gnu/qt5/QtOpenGL" 
		    "/usr/include/x86_64-linux-gnu/qt5/QtOpenGLExtensions" 
		    "/usr/include/x86_64-linux-gnu/qt5/QtPlatformHeaders" 
		    "/usr/include/x86_64-linux-gnu/qt5/QtPrintSupport" 
		    "/usr/include/x86_64-linux-gnu/qt5/QtSql" 
		    "/usr/include/x86_64-linux-gnu/qt5/QtTest" 
		    "/usr/include/x86_64-linux-gnu/qt5/QtWidgets" 
		    "/usr/include/x86_64-linux-gnu/qt5/QtXml"))


(require 'semantic-c nil 'noerror)
;; add include file ---> using semantic
(let ((include-dirs nil))
  (when (eq system-type 'windows-nt)
    (setq include-dirs (append include-dirs qt-win-inclue-dirs)))
  (when (eq system-type 'gnu/linux)
    (setq include-dirs (append include-dirs qt5-headers)))
  (mapc (lambda (dir)
          (semantic-add-system-include dir 'c++-mode)
          (semantic-add-system-include dir 'c-mode))
        include-dirs))
