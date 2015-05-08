;; Display tabs as two spaces wide.
(setq tab-width 2)
(setq-default tab-width 2)

;; .. also in python-mode.
(add-hook 'python-mode-hook
      (lambda ()
        (setq indent-tabs-mode t)
        (setq tab-width 2)
        (setq python-indent 2)))

(set-default-font "-adobe-courier-medium-r-normal--14-140-75-75-m-90-iso8859-1")

;; Put autosave files (ie #foo#) in one place, *not*
;; scattered all over the file system!
(defvar autosave-dir
 (concat "/tmp/emacs_autosaves/" (user-login-name) "/"))

(make-directory autosave-dir t)

(defun auto-save-file-name-p (filename)
  (string-match "^#.*#$" (file-name-nondirectory filename)))

(defun make-auto-save-file-name ()
  (concat autosave-dir
   (if buffer-file-name
      (concat "#" (file-name-nondirectory buffer-file-name) "#")
    (expand-file-name
     (concat "#%" (buffer-name) "#")))))

;; Put backup files (ie foo~) in one place too. (The backup-directory-alist
;; list contains regexp=>directory mappings; filenames matching a regexp are
;; backed up in the corresponding directory. Emacs will mkdir it if necessary.)
(defvar backup-dir (concat "/tmp/emacs_backups/" (user-login-name) "/"))
(setq backup-directory-alist (list (cons "." backup-dir)))

(make-directory autosave-dir t)

(defun auto-save-file-name-p (filename)
  (string-match "^#.*#$" (file-name-nondirectory filename)))

(defun make-auto-save-file-name ()
  (concat autosave-dir
   (if buffer-file-name
      (concat "#" (file-name-nondirectory buffer-file-name) "#")
    (expand-file-name
     (concat "#%" (buffer-name) "#")))))

;; Use html-mode for .tmpl files.
(add-to-list 'auto-mode-alist '("\\.tmpl\\'" . html-mode))

;; We want go-mode, and goimports + gofmt hook.
(add-to-list 'load-path "~/.emacs.d/go-mode")
(require 'go-mode-autoloads)
(setq gofmt-command "goimports")
(add-hook 'before-save-hook #'gofmt-before-save)

;; ELPA packages; install interactively with M-x package-list-packages.
(require 'package)
(add-to-list 'package-archives
						 '("melpa" . "http://melpa.org/packages/") t)
(when (< emacs-major-version 24)
	;; For important compatibility libraries like cl-lib
	(add-to-list 'package-archives '("gnu" . "http://elpa.gnu.org/packages/")))
(package-initialize)

;; By default, enable indent-tabs-mode. This will be overridden by
;; smart-tabs-mode enabled languages (below).
(setq-default indent-tabs-mode t)

(autoload 'smart-tabs-mode "smart-tabs-mode"
	"Intelligently indent with tabs, align with spaces!")
 (autoload 'smart-tabs-mode-enable "smart-tabs-mode")
 (autoload 'smart-tabs-advice "smart-tabs-mode")
 (autoload 'smart-tabs-insinuate "smart-tabs-mode")
 (smart-tabs-insinuate 'c 'c++ 'java 'javascript 'cperl 'python
                      'ruby 'nxml)
(smart-tabs-advice html-indent-line html-basic-offset)

