;;; codes from doom emacs
;;; tools/lookup/autoload/online.el -*- lexical-binding: t; -*-
(defvar +lookup-provider-url-alist
  '(("Doom Emacs issues" "https://github.com/hlissner/doom-emacs/issues?q=is%%3Aissue+%s")
    ("Google"            +lookup--online-backend-google "https://google.com/search?q=%s")
    ("Google images"     "https://www.google.com/images?q=%s")
    ("Google maps"       "https://maps.google.com/maps?q=%s")
    ("Project Gutenberg" "http://www.gutenberg.org/ebooks/search/?query=%s")
    ("DuckDuckGo"        +lookup--online-backend-duckduckgo "https://duckduckgo.com/?q=%s")
    ("DevDocs.io"        "https://devdocs.io/#q=%s")
    ("StackOverflow"     "https://stackoverflow.com/search?q=%s")
    ("Github"            "https://github.com/search?ref=simplesearch&q=%s")
    ("Youtube"           "https://youtube.com/results?aq=f&oq=&search_query=%s")
    ("Wolfram alpha"     "https://wolframalpha.com/input/?i=%s")
    ("Wikipedia"         "https://wikipedia.org/search-redirect.php?language=en&go=Go&search=%s")
    ("MDN"               "https://developer.mozilla.org/en-US/search?q=%s")
    ("Rust Docs" "https://doc.rust-lang.org/std/?search=%s"))

  "An alist that maps online resources to either:

  1. A search url (needs on '%s' to substitute with an url encoded query),
  2. A non-interactive function that returns the search url in #1,
  3. An interactive command that does its own search for that provider.

Used by `+lookup/online'.")


(defvar +lookup-open-url-fn #'browse-url
  "Function to use to open search urls.")

(defvar +lookup-definition-functions
  '(+lookup-dictionary-definition-backend-fn
    +lookup-xref-definitions-backend-fn
    +lookup-dumb-jump-backend-fn
    +lookup-project-search-backend-fn
    +lookup-evil-goto-definition-backend-fn)
  "Functions for `+lookup/definition' to try, before resorting to `dumb-jump'.
Stops at the first function to return non-nil or change the current
window/point.

If the argument is interactive (satisfies `commandp'), it is called with
`call-interactively' (with no arguments). Otherwise, it is called with one
argument: the identifier at point. See `set-lookup-handlers!' about adding to
this list.")

(defvar +lookup-implementations-functions ()
  "Function for `+lookup/implementations' to try. Stops at the first function to
return non-nil or change the current window/point.

If the argument is interactive (satisfies `commandp'), it is called with
`call-interactively' (with no arguments). Otherwise, it is called with one
argument: the identifier at point. See `set-lookup-handlers!' about adding to
this list.")

(defvar +lookup-type-definition-functions ()
  "Functions for `+lookup/type-definition' to try. Stops at the first function to
return non-nil or change the current window/point.

If the argument is interactive (satisfies `commandp'), it is called with
`call-interactively' (with no arguments). Otherwise, it is called with one
argument: the identifier at point. See `set-lookup-handlers!' about adding to
this list.")

(defvar +lookup-references-functions
  '(+lookup-thesaurus-definition-backend-fn
    +lookup-xref-references-backend-fn
    +lookup-project-search-backend-fn)
  "Functions for `+lookup/references' to try, before resorting to `dumb-jump'.
Stops at the first function to return non-nil or change the current
window/point.

If the argument is interactive (satisfies `commandp'), it is called with
`call-interactively' (with no arguments). Otherwise, it is called with one
argument: the identifier at point. See `set-lookup-handlers!' about adding to
this list.")

(defvar +lookup-documentation-functions
  '(+lookup-online-backend-fn)
  "Functions for `+lookup/documentation' to try, before resorting to
`dumb-jump'. Stops at the first function to return non-nil or change the current
window/point.

If the argument is interactive (satisfies `commandp'), it is called with
`call-interactively' (with no arguments). Otherwise, it is called with one
argument: the identifier at point. See `set-lookup-handlers!' about adding to
this list.")

(defvar +lookup-file-functions
  '(+lookup-bug-reference-backend-fn
    +lookup-ffap-backend-fn)
  "Function for `+lookup/file' to try, before restoring to `find-file-at-point'.
Stops at the first function to return non-nil or change the current
window/point.

If the argument is interactive (satisfies `commandp'), it is called with
`call-interactively' (with no arguments). Otherwise, it is called with one
argument: the identifier at point. See `set-lookup-handlers!' about adding to
this list.")

(defvar +lookup-dictionary-prefer-offline nil
  "If non-nil, look up dictionaries online.

Setting this to nil will force it to use offline backends, which may be less
than perfect, but available without an internet connection.

Used by `+lookup/dictionary-definition' and `+lookup/synonyms'.

For `+lookup/dictionary-definition', this is ignored on Mac, where Emacs users
Dictionary.app behind the scenes to get definitions.")



(defvar +lookup--last-provider nil)

(defun +lookup--online-provider (&optional force-p namespace)
  (let ((key (or namespace major-mode)))
    (or (and (not force-p)
             (cdr (assq key +lookup--last-provider)))
        (when-let (provider
                   (completing-read
                    "Search on: "
                    (mapcar #'car +lookup-provider-url-alist)
                    nil t))
          (setf (alist-get key +lookup--last-provider) provider)
          provider))))

;;;###autoload
(defun +lookup-online-backend-fn (identifier)
  "Open the browser and search for IDENTIFIER online.
When called for the first time, or with a non-nil prefix argument, prompt for
the search engine to use."
  (+lookup/online
   identifier
   (+lookup--online-provider (not current-prefix-arg))))

;;;###autoload
(defun +lookup/online (query provider)
  "Look up QUERY in the browser using PROVIDER.
When called interactively, prompt for a query and, when called for the first
time, the provider from `+lookup-provider-url-alist'. In subsequent calls, reuse
the previous provider. With a non-nil prefix argument, always prompt for the
provider.

QUERY must be a string, and PROVIDER must be a key of
`+lookup-provider-url-alist'."
  (interactive
   (list (if (use-region-p)
             (thing-at-point 'symbol)
           ;; (doom-thing-at-point-or-region)
           )
         (+lookup--online-provider current-prefix-arg)))
  (let ((backends (cdr (assoc provider +lookup-provider-url-alist))))
    (unless backends
      (user-error "No available online lookup backend for %S provider"
                  provider))
    (catch 'done
      (dolist (backend backends)
        (cl-check-type backend (or string function))
        (cond ((stringp backend)
               (funcall +lookup-open-url-fn
                        (format backend
                                (url-encode-url
                                 (or query
                                     (read-string (format "Search for (on %s): " provider)
                                                  (thing-at-point 'symbol t)))))))
              ((condition-case-unless-debug e
                   (and (fboundp backend)
                        (funcall backend query))
                 (error
                  (delq! major-mode +lookup--last-provider 'assq)
                  (signal (car e) (cdr e))))
               (throw 'done t)))))))

;;;###autoload
(defun +lookup/online-select ()
  "Run `+lookup/online', but always prompt for the provider to use."
  (interactive)
  (let ((current-prefix-arg t))
    (call-interactively #'+lookup/online)))


;;
;;; Special provider frontends

(defvar ivy-initial-inputs-alist)
(defvar counsel-search-engine)
;;;###autoload
(defun +lookup--online-backend-google (query)
  "Search Google, starting with QUERY, with live autocompletion."
  (cond ((and (bound-and-true-p ivy-mode) (fboundp 'counsel-search))
         (let ((ivy-initial-inputs-alist `((t . ,query)))
               (counsel-search-engine 'google))
           (call-interactively #'counsel-search)
           t))
        ((and (bound-and-true-p helm-mode) (require 'helm-net nil t))
         (helm :sources 'helm-source-google-suggest
               :buffer "*helm google*"
               :input query)
         t)))

;;;###autoload
(defun +lookup--online-backend-duckduckgo (query)
  "Search DuckDuckGo, starting with QUERY, with live autocompletion."
  (cond ((and (bound-and-true-p ivy-mode) (fboundp 'counsel-search))
         (let ((ivy-initial-inputs-alist `((t . ,query)))
               (counsel-search-engine 'ddg))
           (call-interactively #'counsel-search)
           t))))
