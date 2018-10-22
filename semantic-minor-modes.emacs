;; all initializations -----> sub minor modes
(global-semanticdb-minor-mode t)
;;enables global support for Semanticdb;
(global-semantic-mru-bookmark-mode t)
;;enables automatic bookmarking of tags that you edited, so you can return to them later with the semantic-mrub-switch-tags command;
;;(global-cedet-m3-minor-mode t)
;;activates CEDET's context menu that is bound to right mouse button;
(global-semantic-highlight-func-mode t)
;;activates highlighting of first line for current tag (function, class, etc.);
(global-semantic-stickyfunc-mode t)
;;activates mode when name of current tag will be shown in top line of buffer;
(global-semantic-decoration-mode t)
;;activates use of separate styles for tags decoration (depending on tag's class). These styles are defined in the semantic-decoration-styles list;
(global-semantic-idle-local-symbol-highlight-mode t)
;;;;activates highlighting of local names that are the same as name of tag under cursor;
(global-semantic-idle-scheduler-mode t)
;;activates automatic parsing of source code in the idle time;
;;(global-semantic-idle-completions-mode t)
;;activates displaying of possible name completions in the idle time. Requires that global-semantic-idle-scheduler-mode was enabled;
;;(global-semantic-idle-summary-mode t)
;;activates displaying of information about current tag in the idle time. Requires that global-semantic-idle-scheduler-mode was enabled.

;;Following sub-modes are usually useful when you develop and/or debug CEDET:
(global-semantic-show-unmatched-syntax-mode t)
;;shows which elements weren't processed by current parser's rules;
(global-semantic-show-parser-state-mode t)
;;shows current parser state in the modeline;
(global-semantic-highlight-edits-mode t)
;;shows changes in the text that weren't processed by incremental parser yet.

(setq-mode-local c-mode semanticdb-find-default-throttle
                 '(project unloaded system recursive))
