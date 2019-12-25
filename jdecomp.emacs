;; -*- coding: utf-8-dos; -*-
(use-package jdecomp
  :ensure t)

(customize-set-variable 'jdecomp-decompiler-type 'fernflower)

(jdecomp-mode 1)

(customize-set-variable 'jdecomp-decompiler-paths
			'((cfr . "~/.emacs.d/decompiler/cfr-0.146.jar")
			  (fernflower . "~/.emacs.d/decompiler/fernflower.jar")
			  (procyon . "~/.emacs.d/decompiler/procyon-decompiler-0.5.36.jar")))


(customize-set-variable 'jdecomp-decompiler-options
                        '((cfr "--comments false" "--removeboilerplate false")
                          (fernflower "-hes=0" "-hdc=0")))
