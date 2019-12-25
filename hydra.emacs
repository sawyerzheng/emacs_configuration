;; -*- coding: utf-8-unix; -*-
;; https://github.com/abo-abo/hydra#sample-hydras
(defhydra hydra-zoom (global-map "<f2>")
  "zoom"
  ("g" text-scale-increase "in")
  ("l" text-scale-decrease "out"))

