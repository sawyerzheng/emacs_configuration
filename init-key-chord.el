(use-package key-chord
  :straight t
  :commands (key-chord-define)
  ;; :defer t
  :config
  (setq key-chord-two-keys-delay 0.1)
  (setq key-chord-one-key-delay 0.2) ; default 0.2
  (setq key-chord-safety-interval-forward 0.1)
  (key-chord-mode 1))


(provide 'init-key-chord)
