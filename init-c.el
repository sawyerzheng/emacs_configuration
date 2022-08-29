(provide 'init-c)

(use-package modern-cpp-font-lock
  :straight t
  :defer t
  :commands (modern-c++-font-lock-mode modern-c++-font-lock-global-mode)
  :hook (c++-mode . modern-c++-font-lock-mode))

;; `qt' keywords setup
(use-package cc-mode
  :config
  (defun c-mode-style-setup ()
    (interactive)
    ;; cpp font lock.
    ;; (modern-c++-font-lock-global-mode t)

    ;; base-style
    (c-set-style "stroustrup")

    ;; qt keywords and stuff ...
    ;; set up indenting correctly for new qt kewords
    (setq c-protection-key (concat "\\<\\(public\\|public slot\\|protected"
                                   "\\|protected slot\\|private\\|private slot"
                                   "\\)\\>")
          c-C++-access-key (concat "\\<\\(signals\\|public\\|protected\\|private"
                                   "\\|public slots\\|protected slots\\|private slots"
                                   "\\)\\>[ \t]*:"))
    (progn
      ;; modify the colour of slots to match public, private, etc ...
      (font-lock-add-keywords 'c++-mode
                              '(("\\<\\(slots\\|signals\\)\\>" . font-lock-type-face)))
      ;; make new font for rest of qt keywords
      (make-face 'qt-keywords-face)
      (set-face-foreground 'qt-keywords-face "DeepSkyBlue1")
      ;; qt keywords
      (font-lock-add-keywords 'c++-mode
                              '(("\\<Q_OBJECT\\>" . 'qt-keywords-face)))
      (font-lock-add-keywords 'c++-mode
                              '(("\\<SIGNAL\\|SLOT\\>" . 'qt-keywords-face)))
      (font-lock-add-keywords 'c++-mode
                              '(("\\<Q[A-Z][A-Za-z]\\>" . 'qt-keywords-face)))))
  :hook ((c-mode c++-mode c-mode-common) . c-mode-style-setup)
  )

;; cmake
(use-package cmake-mode
  :straight t
  :commands (cmake-mode))

;; 太老，无法使用
;; (use-package cmake-project
;;   :straight t
;;   :hook ((c-mode c++-mode) . maybe-cmake-project-mode)
;;   :config
;;   (defun maybe-cmake-project-mode ()
;;     (if (or (file-exists-p "CMakeLists.txt")
;;             (file-exists-p (expand-file-name "CMakeLists.txt" (car (project-roots (project-current))))))
;;         (cmake-project-mode))))

(use-package eldoc-cmake
  :straight t
  :hook (cmake-mode . eldoc-cmake-enable))

(use-package cmake-integration
  :straight (:type git :host github :repo "darcamo/cmake-integration")
  :commands (cmake-integration-save-and-compile))

(use-package cmake-project
  :straight t
  :config
  (setq cmake-project-default-build-dir-name "build")
  (defun maybe-cmake-project-mode ()
    (if (or (file-exists-p "CMakeLists.txt")
            (file-exists-p (expand-file-name "CMakeLists.txt" (car (project-roots (project-current))))))
        (cmake-project-mode)))
  :hook ((c-mode c++-mode) . maybe-cmake-project-mode)
  :commands (cmake-project-configure-project))

(use-package project-cmake
  :straight (:type git :host github :repo "juanjosegarciaripoll/project-cmake"
                   :fork (:repo "sawyerzheng/project-cmake"))
  :commands (
             project-cmake-test
             project-cmake-build
             project-cmake-configure
             project-cmake-shell
             project-cmake-select-kit
             project-cmake-edit-settings
             project-cmake-save-settings
             project-cmake-debug
             project-cmake-run-target
             project-cmake-scan-kits)
  :config
  (setq project-cmake-build-directory-name "build")
  (setq project-cmake-msys2-root "e:/soft/msys64")


  ;; my fix for commit: 328a2b1834a0c889372ab2cca048a90c8dddb157
  (defun project-cmake-unix-kits ()
    (let* ((all-kits (list (project-cmake-build-kit "unix")))
           (compiler-alist '(("gcc" . (("cc" . "gcc")
                                       ("cxx". "g++")))
                             ("clang" . (("cc" . "clang")
                                         ("cxx" ."clang++")))
                             ("icc" . (("cc" . "icc")
                                       ("cxx" . "icpc")))))
           (compiler-names (mapcar #'car compiler-alist))

           (all-compilers (delq nil (mapcar 'executable-find compiler-names))))
      (when (> (length all-compilers) 1)
        ;; If there are multiple compilers, create specialized kits
        (dolist (compiler all-compilers)
          (let* ((kit-name (concat "unix-" (file-name-base compiler)))
                 (compiler-set (cdr (assoc (file-name-base compiler) compiler-alist)))
                 (cc-compiler (cdr (assoc "cc" compiler-set)))
                 (cxx-compiler (cdr (assoc "cxx" compiler-set)))
                 (environment (cl-list* (format "CC=%s" (executable-find cc-compiler))
                                        (format "CXX=%s" (executable-find cxx-compiler))
                                        process-environment)))
            (push (project-cmake-build-kit kit-name environment)
                  all-kits))))
      all-kits))



  ;; add function for run target
  (defun project-cmake-run-target ()
    "Run a debugger on a selected target. Run the toolkit's
debugger passing a compiled executable target as argument. The
target is selected from the list of CMake executable targets. If
the current buffer belongs to one such executable target, it is
passed as initial value in the selection list.

Note: This function defaults to calling the old interface GUD-GDB
on the Windows platform."
    (interactive)
    (require 'comint)
    (let* ((default-directory (project-root (project-current t)))
           (buffer-name (format "*Run Target %s*" default-directory))
           (compilation-buffer-name-function (lambda (mode) buffer-name))
           (target (project-cmake-kit-convert-path
                    (project-cmake-api-choose-executable-file)))
           (process-environment (project-cmake-kit-debug-environment))
           (gdb-executable (project-cmake-kit-value :gdb)))
      (compile (project-cmake-kit-wrap (list target))
               ;; (get-buffer buffer-name)
               )))

  

  :commands (project-cmake-map)
  :bind (:map project-prefix-map
              ("U" . project-cmake-run-target))



  :defer t)

;;;###autoload
(defvar project-cmake-map
  (let* ((map (make-sparse-keymap)))
    (define-key map "t" 'project-cmake-test)
    (define-key map "m" 'project-cmake-build)
    (define-key map "c" 'project-cmake-configure)
    (define-key map "s" 'project-cmake-shell)
    (define-key map "SK" 'project-cmake-select-kit)
    (define-key map "SE" 'project-cmake-edit-settings)
    (define-key map "SS" 'project-cmake-save-settings)
    (define-key map "d" 'project-cmake-debug)
    (define-key map "u" 'project-cmake-run-target)
    map))


(bind-key "." project-cmake-map 'project-prefix-map)

(with-eval-after-load 'project
  (require 'project-cmake))

(defun my/conan-install ()
  (interactive)
  (let* ((default-directory (my/get-project-root))
         (buffer-name (format "*conan install: %s*" default-directory))
         (compilation-buffer-name-function (lambda (mode) buffer-name))
         )
    (compile (format "conan install %s -if ./build --build missing" default-directory)) (get-buffer buffer-name)))
