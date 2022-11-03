;; -*- coding: utf-8; -*-

(defcustom my/proxy-use-remote-p nil
  "if to use remove proxy"
  :type 'boolean)

(defun get-my-http-proxy ()
  "retrieve proxy value, depending on if current machine is windows sub linux"
  (if my/proxy-use-remote-p
      "http://home.zhenglei.site:17890"
    "http://localhost:7890"))

(defun toggle-proxy ()
  "set/unset the environment variable http_proxy which w3m uses"
  (interactive)
  (let* ((proxy (get-my-http-proxy)))

    (if (string= (getenv "http_proxy") proxy)
        ;; clear the proxy
        (progn
          (setenv "http_proxy" "")
          (setenv "https_proxy" "")
          (message "env http_proxy is empty now"))

      ;; set the proxy
      (progn
        (setenv "http_proxy" proxy)
        (setenv "https_proxy" proxy)
        (message "env http_proxy is %s now" proxy)))))

(defun disable-proxy ()
  (interactive)
  (setenv "http_proxy" "")
  (setenv "https_proxy" "")
  (message "env http_proxy is empty now")
  )

(defun enable-proxy ()
  (interactive)
  (let ((proxy))
    (setq proxy (get-my-http-proxy))
    (setenv "http_proxy" proxy)
    (setenv "https_proxy" proxy)
    (message "env http_proxy is %s now" proxy))
  )

(defun enable-proxy-remote ()
  (interactive)
  (let ((proxy))
    (setq proxy "http://home.zhenglei.site:17890")
    (setenv "http_proxy" proxy)
    (setenv "https_proxy" proxy)
    (message "env http_proxy is %s now" proxy))
  )

(defun enable-proxy-windows ()
  (interactive)
  (let ((proxy))
    (when (file-exists-p "/usr/bin/wslpath")
      ;; "http://localhost:7890"
      ;;
      (setq proxy (car (split-string (shell-command-to-string
                                      "echo http://$(cat /etc/resolv.conf |grep nameserver|awk '{print $2}'):7890"))) )

      (setenv "http_proxy" proxy)
      (setenv "https_proxy" proxy)
      (message "env http_proxy is %s now" proxy))))

(defun enable-proxy-eaf ()
  "remember to restart eaf using: `eaf-restart-process'."
  (interactive)
  (if my/wsl-p
      (setq eaf-proxy-host "home.zhenglei.site"
            eaf-proxy-type "http"
            eaf-proxy-port "17890")
    (setq eaf-proxy-host "localhost"
          eaf-proxy-type "http"
          eaf-proxy-port "7890"))

  (message "env http_proxy is %s now" (concat eaf-proxy-type "://" eaf-proxy-host ":" eaf-proxy-port)))

(defun disable-proxy-eaf ()
  (interactive)
  (setq eaf-proxy-host ""
        eaf-proxy-type ""
        eaf-proxy-port "")
  (message "env http_proxy is empty now"))

;; (enable-proxy-eaf)

(if my/wsl-p
    (enable-proxy-windows)
  (enable-proxy))


(defun my-toggle-eaf-proxy ()
  (interactive)
  (if (equal eaf-proxy-host "")
      (progn
        (enable-proxy-eaf)
        (eaf-toggle-proxy))
    (progn
      (disable-proxy-eaf)
      (eaf-toggle-proxy)
      )))


(provide 'init-proxy)
