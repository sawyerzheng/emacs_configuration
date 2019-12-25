;;================ Chinese Font ===========================
;(set-default-font "Monaco")
(set-fontset-font "fontset-default" 'chinese-gbk "Microsoft YaHei UI")
(setq face-font-rescale-alist '(("SimSun" . 1.2)
				("Microsoft YaHei UI" . 1.2)
				("微软雅黑" . 1.2)
				("文泉驿等宽微米黑" . 1.2)
				))
;;===========================================================


;; =================== English Font =============================
(custom-set-faces
 '(default ((t (:family "Monaco" :foundry "outline" :slant normal :weight normal :height 120 :width normal)))))
;;=============================================================

(custom-set-faces
 '(default ((t (:family "文泉驿等宽微米黑" :foundry "WQYF" :slant normal :weight normal :height 100 :width normal)))))
(custom-set-faces
  '(default ((t (:family "微软雅黑" :foundry "MS  " :slant normal :weight normal :height 100 :width normal)))))

(defun font-rationit (x)
  "change chinese font ration, and use it"
  (setq face-font-rescale-alist '(("SimSun" . 1.2)
				  ("Microsoft YaHei UI" . 1.2)
				  ("微软雅黑" . 1.2)
				  ("文泉驿等宽微米黑" . x)
				  ))
  (custom-set-faces
   '(default ((t (:family "文泉驿等宽微米黑" :foundry "WQYF" :slant normal :weight normal :height 95 :width normal)))))
  )

(font-rationit 2)


;; (custom-set-faces
;;  ;; custom-set-faces was added by Custom.
;;  ;; If you edit it by hand, you could mess it up, so be careful.
;;  ;; Your init file should contain only one such instance.
;;  ;; If there is more than one, they won't work right.
;;  '(default ((t (:family "Monaco" :foundry "outline" :slant normal :weight normal :height 150 :width normal)))))

;; (set-default-font "Monaco 15")
