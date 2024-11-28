;; -*- coding: utf-8; -*-

(defcustom my/proxy-use-remote-p nil
  "if to use remove proxy"
  :type 'boolean)

(defcustom my/proxy-host "localhost"
  "http proxy host ip"
  :type 'string)

(defcustom my/proxy-port "7890"
  "http proxy port"
  :type 'string)

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
  (message "env http_proxy is empty now"))

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

(defun my/wsl-get-windows-ip ()
  (when (file-exists-p "/usr/bin/wslpath")
    (car (split-string (shell-command-to-string
                        "cat /etc/resolv.conf |grep nameserver|awk '{print $2}'")))))

(defun enable-proxy-windows ()
  (interactive)
  (let ((proxy))
    (when my/wsl-p
      (setq proxy (format "http://%s:%s" (my/wsl-get-windows-ip) my/proxy-port) )

      (setenv "http_proxy" proxy)
      (setenv "https_proxy" proxy)
      (message "env http_proxy is %s now" proxy))))

(setenv "no_proxy" "127.0.0.1,localhost,172.16.10.0/24,192.168.0.0/16,10.0.18.0/24,10.8.0.0/24")
(setenv "NO_PROXY" "127.0.0.1,localhost,172.16.10.0/24,192.168.0.0/16,10.0.18.0/24,10.8.0.0/24")

(defun enable-proxy-eaf ()
  "remember to restart eaf using: `eaf-restart-process'."
  (interactive)
  (setq eaf-proxy-host "localhost"
        eaf-proxy-type "http"
        eaf-proxy-port "7890")
  (message "env http_proxy is %s now" (concat eaf-proxy-type "://" eaf-proxy-host ":" eaf-proxy-port)))

(defun enable-proxy-windows-eaf ()
  "remember to restart eaf using: `eaf-restart-process'."
  (interactive)
  (if my/wsl-p
      (setq eaf-proxy-host (my/wsl-get-windows-ip)
            eaf-proxy-type "http"
            eaf-proxy-port "7890")
    (setq eaf-proxy-host "localhost"
          eaf-proxy-type "http"
          eaf-proxy-port "7890"))

  (message "env http_proxy is %s now" (concat eaf-proxy-type "://" eaf-proxy-host ":" eaf-proxy-port)))


(defun enable-proxy-lan-eaf ()
  "remember to restart eaf using: `eaf-restart-process'."
  (interactive)
  (setq eaf-proxy-host "172.16.10.86"
        eaf-proxy-type "http"
        eaf-proxy-port "7890")

  (message "env http_proxy is %s now" (concat eaf-proxy-type "://" eaf-proxy-host ":" eaf-proxy-port)))

(defun disable-proxy-eaf ()
  (interactive)
  (setq eaf-proxy-host ""
        eaf-proxy-type ""
        eaf-proxy-port "")
  (message "env http_proxy is empty now"))

;; (enable-proxy-eaf)

;; (if my/wsl-p
;;     (progn
;;       (enable-proxy-windows)
;;       (enable-proxy-windows-eaf))
;;   (enable-proxy)
;;   (enable-proxy-eaf))


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


(defun my/with-proxy-disable (fun)
  "run function without proxy"
  (interactive)
  (let* ((proxy (getenv "http_proxy")))

    (ignore-errors
      (disable-proxy)
      (call-interactively fun))

    (setenv "http_proxy" proxy)
    (setenv "https_proxy" proxy)
    ))

(provide 'init-proxy)
