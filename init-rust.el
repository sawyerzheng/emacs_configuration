(provide 'init-rust)

(use-package rust-mode
  :straight t
  :commands (rust-mode)
  :mode ("\\.rs\\'"))

(use-package cargo
  :straight t
  :hook ((rust-mode . cargo-minor-mode)
         (rust-ts-mode . cargo-minor-mode))
  :config
  (when (boundp 'rust-mode-map)
    (define-key rust-mode-map (kbd "C-c C-c") #'cargo-minor-mode-command-map))
  (when
      (boundp 'rust-ts-mode-map)
    (define-key rust-ts-mode-map (kbd "C-c C-c") #'cargo-minor-mode-command-map)))

(major-mode-hydra-define rust-mode
  (:title "Rust Mode" :color blue :quit-key "q")
  ("Cargo"
   (("SPC" cargo-process-run "cargo run")
    ("r" cargo-process-run "cargo run")
    ("b" cargo-process-build "cargo build")
    ("t" cargo-process-test "cargo test"))
   "Format"
   (("f" cargo-process-fmt "cargo fmt"))))


(major-mode-hydra-define rust-ts-mode
  (:title "Rust Mode" :color blue :quit-key "q")
  ("Cargo"
   (("SPC" cargo-process-run "cargo run")
    ("r" cargo-process-run "cargo run")
    ("b" cargo-process-build "cargo build")
    ("t" cargo-process-test "cargo test"))
   "Format"
   (("f" cargo-process-fmt "cargo fmt"))))
