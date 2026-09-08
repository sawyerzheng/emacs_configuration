;;; test-init-liberime.el -*- lexical-binding: t; -*-
;; TDD 回归测试: liberime 在 snap Emacs 下的构建修复 (~/.conf.d/init-liberime.el).
;;
;; Run (batch, 单测):
;;   emacs -Q --batch -l test-init-liberime.el \
;;     --eval "(ert-run-tests-batch-and-exit '(not (tag e2e)))"
;; Run (e2e, 真实构建):
;;   emacs -Q --batch -l test-init-liberime.el \
;;     --eval "(ert-run-tests-batch-and-exit '(tag :e2e))"

(require 'ert)
(require 'cl-lib)

;; 避免 advising 内置函数时 native-comp 蹦床写 /tmp 被沙箱拦截
(setq native-comp-enable-subr-trampolines nil)

;;; 被测文件外部依赖 stub ----------------------------------------------------
(defvar my/windows-p nil)
(defvar no-littering-var-directory "/tmp/no-littering/")
(defun my/straight-if-use (&rest _) nil)
(eval-and-compile
  ;; Emacs 29+ 内置 use-package, 无需桩; 其 :after 延迟的块在测试中不加载
  ;; (pyim 永不加载), 这正是把发行版专属设置提升到文件顶层的原因.
  nil)

;; 加载被测文件; +liberime-snap-fix-mode 置 nil 阻止顶层构建逻辑真实执行.
;; (被测文件为动态作用域, 这里先用无值 defvar 声明为 special 变量)
(defvar +liberime-snap-fix-mode)
(defvar liberime-module-file)
;; 测试局部跨闭包变量: 声明为动态 (词法闭包在宏拼接体中会丢失捕获,
;; defvar 是 elisp 测试的惯用解法)
(defvar +test-orig-called nil)
(defvar +test-load-called nil)
;; 发行版环境 stub: 自有发行版默认 (my/doom-p nil); 测试内 let 切换
(defvar my/doom-p nil)
(defvar liberime-user-data-dir nil)
(let ((+liberime-snap-fix-mode nil))
  (load-file (expand-file-name "~/.conf.d/init-liberime.el")))

;;; mock 辅助 ----------------------------------------------------------------
(defmacro +test/stub-env (snap-p &rest body)
  "在 mock 环境执行 BODY. SNAP-P 非 nil 时 files.el 位于 snap 前缀下."
  (declare (indent 1))
  `(let ((files-el (if ,snap-p
                       "/snap/emacs/current/usr/share/emacs/31.1/lisp/files.el"
                     "/usr/share/emacs/31.1/lisp/files.el"))
         (make-calls nil)
         (make-exit 0)
         (existing (list "/fake/lib/src/liberime-core.so"))
         (copies nil)
         (liberime-module-file nil))
     (cl-letf (((symbol-function 'locate-library)
                (lambda (name)
                  (cond ((equal name "files") files-el)
                        ((equal name "liberime") "/fake/lib/liberime.el")
                        (t nil))))
               ((symbol-function 'file-exists-p)
                (lambda (f) (member f existing)))
               ((symbol-function 'call-process)
                (lambda (&rest args)
                  (push args make-calls)
                  (when (= make-exit 0)
                    (cl-pushnew (expand-file-name "src/liberime-core.so" (nth 5 args))
                                existing :test #'equal))
                  make-exit))
               ((symbol-function 'copy-file)
                (lambda (src dst &optional _ok)
                  (push (list src dst) copies)
                  (cl-pushnew dst existing :test #'equal)))
               ((symbol-function 'make-directory)
                (lambda (&rest _) t)))
       ,@body)))

;;; Slice 1: +liberime-snap-include-dir --------------------------------------

(ert-deftest +liberime-snap-include-dir-returns-dir-for-snap ()
  (+test/stub-env t
    (should (equal (+liberime-snap-include-dir)
                   "/snap/emacs/current/usr/include/"))))

(ert-deftest +liberime-snap-include-dir-nil-for-non-snap ()
  (+test/stub-env nil
    (should-not (+liberime-snap-include-dir))))


;;; Slice 2: +liberime-module-file-path --------------------------------------

(ert-deftest +liberime-module-file-path-snap-stable-location ()
  (+test/stub-env t
    (should (equal (+liberime-module-file-path)
                   (expand-file-name "liberime-core.so"
                                     "~/.emacs.d.doom/.local/")))))

(ert-deftest +liberime-module-file-path-non-snap-existing-so ()
  (+test/stub-env nil
    (should (equal (+liberime-module-file-path)
                   "/fake/lib/src/liberime-core.so"))))

(ert-deftest +liberime-module-file-path-non-snap-missing-so-nil ()
  (+test/stub-env nil
    (cl-letf (((symbol-function 'file-exists-p) (lambda (_) nil)))
      (should-not (+liberime-module-file-path)))))


;;; Slice 3: +liberime-ensure-module -----------------------------------------

(ert-deftest +liberime-ensure-module-noop-non-snap ()
  (+test/stub-env nil
    (should-not (+liberime-ensure-module))
    (should-not make-calls)
    (should-not copies)
    (should-not (bound-and-true-p liberime-module-file))))

(ert-deftest +liberime-ensure-module-snap-existing-only-setq ()
  (+test/stub-env t
    (let ((expected (+liberime-module-file-path)))
      (cl-pushnew expected existing :test #'equal)
      (should (+liberime-ensure-module))
      (should-not make-calls)
      (should-not copies)
      (should (equal liberime-module-file expected)))))

(ert-deftest +liberime-ensure-module-snap-missing-builds-copies-sets ()
  (+test/stub-env t
    (let ((expected (+liberime-module-file-path)))
      (should (+liberime-ensure-module))
      ;; 默认 Makefile (-C 库目录), 显式 EMACS_MAJOR_VERSION;
      ;; 绝不引用 snap 头目录, 绝不走生成的有毒 Makefile-liberime-build
      (should (equal (car make-calls)
                     (list "make" nil "*liberime build*" nil
                           "-C" "/fake/lib"
                           (format "EMACS_MAJOR_VERSION=%d" emacs-major-version))))
      (should (equal (car copies)
                     (list "/fake/lib/src/liberime-core.so" expected)))
      (should (equal liberime-module-file expected)))))

(ert-deftest +liberime-ensure-module-make-failure-errors-no-setq ()
  (+test/stub-env t
    (setq make-exit 2)
    (should-error (+liberime-ensure-module) :type 'error)
    (should-not (bound-and-true-p liberime-module-file))))

(ert-deftest +liberime-ensure-module-force-rebuilds ()
  (+test/stub-env t
    (let ((expected (+liberime-module-file-path)))
      (cl-pushnew expected existing :test #'equal)
      (should (+liberime-ensure-module t))
      (should make-calls)
      (should (equal liberime-module-file expected)))))

(ert-deftest +liberime-ensure-module-falls-back-to-repos-dir ()
  (+test/stub-env t
    (cl-letf (((symbol-function 'locate-library)
               (lambda (name)
                 (cond ((equal name "files")
                        "/snap/emacs/current/usr/share/emacs/31.1/lisp/files.el")
                       (t nil)))))
      (should (+liberime-ensure-module))
      (should (equal (car make-calls)
                     (list "make" nil "*liberime build*" nil
                           "-C" (expand-file-name "straight/repos/liberime"
                                                  "~/.emacs.d.doom/.local/")
                           (format "EMACS_MAJOR_VERSION=%d" emacs-major-version)))))))


;;; Slice 4: +liberime-build-around (advice) ---------------------------------

(ert-deftest +liberime-build-around-snap-overrides-and-reloads ()
  (+test/stub-env t
    (let ((+test-orig-called nil)
          (+test-load-called nil)
          (orig (lambda (&rest _) (setq +test-orig-called t))))
      (cl-letf (((symbol-function 'liberime-load)
                 (lambda () (setq +test-load-called t))))
        (+liberime-build-around orig 'arg1)
        (should-not +test-orig-called)
        (should +test-load-called)
        (should make-calls)          ;; force 重建
        (should (equal liberime-module-file
                       (expand-file-name "liberime-core.so"
                                         "~/.emacs.d.doom/.local/")))))))

(ert-deftest +liberime-build-around-non-snap-passthrough ()
  (+test/stub-env nil
    (let ((+test-orig-called nil)
          (orig (lambda (&rest args) (setq +test-orig-called args))))
      (+liberime-build-around orig 'arg1 'arg2)
      (should (equal +test-orig-called '(arg1 arg2)))
      (should-not make-calls)
      (should-not (bound-and-true-p liberime-module-file)))))


;;; Slice 5: 接线 (顶层修复块在 snap 下加载时生效) ----------------------------

(ert-deftest +liberime-load-wires-module-in-snap ()
  (+test/stub-env t
    (let ((expected (expand-file-name "liberime-core.so"
                                      "~/.emacs.d.doom/.local/"))
          (+liberime-snap-fix-mode t))
      (cl-pushnew expected existing :test #'equal)
      (load-file (expand-file-name "~/.conf.d/init-liberime.el"))
      (should (equal liberime-module-file expected)))))

(ert-deftest +liberime-load-does-nothing-non-snap ()
  (+test/stub-env nil
    (let ((+liberime-snap-fix-mode t))  ;; 即使开启, 非 snap 环境也不动作
      (load-file (expand-file-name "~/.conf.d/init-liberime.el"))
      (should-not (bound-and-true-p liberime-module-file))
      (should-not make-calls))))


;;; Slice 6: E2E (真实环境: make + 加载模块) ---------------------------------

(ert-deftest +liberime-e2e-real-build-and-load ()
  :tags '(:e2e)
  (skip-unless (+liberime-snap-include-dir))
  (let ((build-dir (expand-file-name "straight/build-31.1/liberime"
                                     "~/.emacs.d.doom/.local/")))
    (add-to-list 'load-path build-dir)
    ;; 真实构建 (force 重建), 真实拷贝, 真实加载
    (should (+liberime-ensure-module t))
    (should (file-exists-p (+liberime-module-file-path)))
    (require 'liberime)
    (should (featurep 'liberime-core))
    ;; 接线断言: liberime 加载后 advice 已安装 (顶层 with-eval-after-load)
    (should (advice-member-p #'+liberime-build-around 'liberime-build))))


;;; Slice 7: doom / 自有发行版隔离 --------------------------------------------

(ert-deftest +liberime-load-own-distro-registers-recipe-and-dirs ()
  (+test/stub-env nil
    (let ((my/doom-p nil)
          (recipe-calls nil)
          (liberime-user-data-dir :unset))
      (cl-letf (((symbol-function 'my/straight-if-use)
                 (lambda (&rest args) (push args recipe-calls))))
        (load-file (expand-file-name "~/.conf.d/init-liberime.el"))
        (should recipe-calls)                     ; 自有发行版: 注册 straight recipe
        (should-not (eq liberime-user-data-dir :unset)))))) ; no-littering 目录生效

(ert-deftest +liberime-load-doom-skips-distro-config ()
  (+test/stub-env nil
    (let ((my/doom-p t)
          (recipe-calls nil)
          (liberime-user-data-dir :unset))
      (cl-letf (((symbol-function 'my/straight-if-use)
                 (lambda (&rest args) (push args recipe-calls))))
        (load-file (expand-file-name "~/.conf.d/init-liberime.el"))
        (should-not recipe-calls)                 ; doom: 不注册 recipe (packages.el 管)
        (should (eq liberime-user-data-dir :unset)))))) ; doom: 不动 user-data-dir

;;; test-init-liberime.el ends here
