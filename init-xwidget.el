;; Webkit browser
(use-package xwidget
  :ensure nil
  :if (featurep 'xwidget-internal)
  :bind (("C-c C-z w" . xwidget-webkit-browse-url)
         :map xwidget-webkit-mode-map
         (("h" . xwidget-hydra/body)
          ("<" . xwidget-webkit-scroll-down)
          (">" . xwidget-webkit-scroll-up)
          ) )
  :hook (xwidget-webkit-mode . my/xwidget-dark-mode)
  :pretty-hydra
  ((:title (pretty-hydra-title "Webkit" 'devicon "nf-fa-chrome" :face 'nerd-icons-blue)
           :color amaranth :quit-key ("q" "C-g"))
   ("Navigate"
    (("H" xwidget-webkit-back "back")
     ("L" xwidget-webkit-forward "forward")
     ("r" xwidget-webkit-reload "refresh")
     ("SPC" xwidget-webkit-scroll-up "scroll up")
     ("DEL" xwidget-webkit-scroll-down "scroll down")
     ("S-SPC" xwidget-webkit-scroll-down "scroll down"))
    "Zoom"
    (("+" xwidget-webkit-zoom-in "zoom in")
     ("=" xwidget-webkit-zoom-in "zoom in")
     ("-" xwidget-webkit-zoom-out "zoom out"))
    "Misc"
    (("g" xwidget-webkit-browse-url "browse url" :exit t)
     ("u" xwidget-webkit-current-url "show url" :exit t)
     ("v" xwwp-follow-link "follow link" :exit t)
     ("f" xwwp-follow-link "follow link" :exit t)
     ("w" xwidget-webkit-current-url-message-kill "copy url" :exit t)
     ("?" describe-mode "help" :exit t)
     ("x" quit-window "quit" :exit t)
     ("q" hydra-keyboard-quit "quit" :exit t)
     ("Q" quit-window "quit" :exit t)
     ("<escape>" nil "quit hydra" :exit t)
     ))))



;;;###autoload
(defun my/xwidget-webkit--disable-dark-mode-simple ()
  "Toggle dark mode for xwidget-webkit."
  (interactive)
  (when (xwidget-webkit-current-session)
    (xwidget-webkit-execute-script
     (xwidget-webkit-current-session)
     "
    (function() {
      let style = document.getElementById('dark-mode-style');
      if (style) {
        style.remove();
      } else {
        xwidget-webkit-dark-mode();
      }
    })()
   ")))

;;;###autoload
(defun my/xwidget-webkit--enable-dark-mode-simple ()
  "Enable dark mode for xwidget-webkit."
  (interactive)
  (when (xwidget-webkit-current-session)
    (xwidget-webkit-execute-script
     (xwidget-webkit-current-session)
     "
    (function() {
      // Create dark mode style element if it doesn't exist
      let style = document.getElementById('dark-mode-style');
      if (!style) {
        style = document.createElement('style');
        style.id = 'dark-mode-style';
        document.head.appendChild(style);
      }

      // Add dark mode CSS rules
      style.textContent = `
        html {
          background-color: #0d1117 !important;
          filter: invert(90%) hue-rotate(180deg) !important;
        }

        img, picture, video, pre, [style*='background-image'] {
          filter: invert(100%) hue-rotate(180deg) !important;
        }

        :root {
          color-scheme: dark !important;
        }
      `;
    })()
   ")))

;;;###autoload
(defun my/xwidget-webkit--enable-dark-mode-darkreaderjs ()
  "Enable dark mode for xwidget-webkit."
  (interactive)
  (when (xwidget-webkit-current-session)
    (xwidget-webkit-execute-script
     (xwidget-webkit-current-session)
     "(function() {
        function initDarkReader() {
          if (typeof DarkReader !== 'undefined') {
            try {
              DarkReader.enable({
                brightness: 100,
                contrast: 90,
                sepia: 10
              });
              return 'Dark Reader enabled successfully';
            } catch (e) {
              console.error('Error enabling Dark Reader:', e);
              return 'Error enabling Dark Reader: ' + e.message;
            }
          } else {
            var script = document.createElement('script');
            script.src = 'https://cdn.jsdelivr.net/npm/darkreader@4.9.96/darkreader.min.js';
            script.onload = function() {
              DarkReader.enable({
                brightness: 100,
                contrast: 90,
                sepia: 10
              });
            };
            script.onerror = function(e) {
              console.error('Error loading Dark Reader script:', e);
            };
            document.head.appendChild(script);
            return 'Dark Reader script loading...';
          }
        }
        return initDarkReader();
      })();")))

;;;###autoload
(defun my/xwidget-webkit--disable-dark-mode-darkreaderjs ()
  "Toggle dark mode for xwidget-webkit."
  (interactive)
  (when (xwidget-webkit-current-session)
    (xwidget-webkit-execute-script
     (xwidget-webkit-current-session)
     "(function() {
        function initDarkReader() {
          if (typeof DarkReader !== 'undefined') {

            try {
DarkReader.disable();
              return 'Dark Reader enabled successfully';
            } catch (e) {
              console.error('Error enabling Dark Reader:', e);
              return 'Error enabling Dark Reader: ' + e.message;
            }
          }
        }
        return initDarkReader();
      })();")))



(defvar my/xwidget-dark-mode-simple t
  "if to use karreaderjs")

(if my/xwidget-dark-mode-simple
    (progn
      (defalias 'my/xwidget-webkit--disable-dark-mode 'my/xwidget-webkit--disable-dark-mode-simple)
      (defalias 'my/xwidget-webkit--enable-dark-mode 'my/xwidget-webkit--enable-dark-mode-simple))
  (defalias 'my/xwidget-webkit--disable-dark-mode 'my/xwidget-webkit--disable-dark-mode-darkreaderjs)
  (defalias 'my/xwidget-webkit--enable-dark-mode 'my/xwidget-webkit--enable-dark-mode-darkreaderjs)
  )

;;;###autoload
(define-minor-mode my/xwidget-dark-mode
  "Minor Mode for xwidget dark mode"
  :init-value nil
  :group xwidget-webkit
  (if my/xwidget-dark-mode
      (run-with-timer 0.1 1 #'my/xwidget-webkit--enable-dark-mode)
    (my/xwidget-webkit--disable-dark-mode)))


;;;###autoload
(defun my/xwidget--dark-mode-with-delay ()
  (interactive)
  (run-with-timer 0.1 1 #'my/xwidget-webkit--enable-dark-mode))

(defun my/xwidget--disable-dark-mode-with-delay ()
  (interactive)
  (run-with-timer 0.1 1 #'my/xwidget-webkit--disable-dark-mode))
(use-package xwwp
  :straight t
  :after xwidget)

(provide 'init-xwidget)
