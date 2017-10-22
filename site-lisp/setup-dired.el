;; -*-coding:utf-8-*-

(require 'el-get)
(require 'initsplit)

(add-to-list 'initsplit-customizations-alist `("^dired" ,(or load-file-name (buffer-file-name))))

;;diredで今日更新のファイルの表示色変更
;;http://masutaka.net/chalow/2011-12-17-1.html
(defface dired-todays-face '((t (:foreground "OrangeRed"))) nil)
(defvar dired-todays-face 'dired-todays-face)
(defconst month-name-alist
  '(("1"  . "Jan") ("2"  . "Feb") ("3"  . "Mar") ("4"  . "Apr")
    ("5"  . "May") ("6"  . "Jun") ("7"  . "Jul") ("8"  . "Aug")
    ("9"  . "Sep") ("10" . "Oct") ("11" . "Nov") ("12" . "Dec")))
(defun dired-today-search (arg)
  "Fontlock search function for dired."
  (search-forward-regexp
   (let ((month-name
          (cdr (assoc (format-time-string "%b") month-name-alist))))
     (format
      (format-time-string
       "\\(\\b%Y-%m-%d\\b\\|\\b%b[- ]%e\\b\\|\\b%%s %e\\b\\) [0-9:]\\{5\\}") month-name))
   arg t))
(eval-after-load "dired"
  '(font-lock-add-keywords
    'dired-mode
    (list '(dired-today-search . dired-todays-face))))

(add-hook 'dired-mode-hook
          #'(lambda ()
              (local-set-key "r" 'wdired-change-to-wdired-mode)))

;; http://kouzuka.blogspot.jp/2011/02/emacs-finder-dired.html
(if (eq system-type 'darwin)
    (progn
      (defun my-dired-finder-window ()
        "Open the front most window of Finder in dired."
        (interactive)
        (let (file
              (script (concat
                       "tell application \"Finder\"\n"
                       "    if ((count Finder windows) >= 1) then\n"
                       "        get POSIX path of (target of window 1 as alias)\n"
                       "    else\n"
                       "        get POSIX path of (desktop as alias)\n"
                       "    end if\n"
                       "end tell\n")))
          (setq file (with-temp-buffer
                       (call-process "osascript" nil t nil "-e" script)
                       (buffer-substring-no-properties (point-min) (1- (point-max)))))
          (if (file-directory-p file)
              (dired file)
            (error "Not a directory: %s" file))))
      (global-set-key "\C-cf" #'my-dired-finder-window)))

(el-get-bundle dired-toggle-sudo)
(el-get-bundle! dired-open)

(when (or (eq system-type 'windows-nt) (eq system-type 'cygwin))
  ;;http://uenox.infoseek.livedoor.com/meadow/
  (defun uenox-dired-winstart ()
    "Type '\\[uenox-dired-winstart]': win-start the current line's file."
    (interactive)
    (if (eq major-mode 'dired-mode)
        (let ((fname (dired-get-filename)))
          (w32-shell-execute "open" fname)
          (message "win-started %s" fname))))
  (add-hook 'dired-mode-hook
            #'(lambda ()
                (define-key dired-mode-map "z" 'uenox-dired-winstart)))

  (setq default-file-name-coding-system 'shift_jis))

(when (eq system-type 'cygwin)
  (el-get-bundle cygwin-mount
    (cygwin-mount-activate)))

(provide 'setup-dired)

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(dired-dwim-target t)
 '(dired-isearch-filenames t)
 '(dired-open-extensions (quote (("mwb" . "open -a MySQLWorkbench"))))
 '(dired-recursive-copies (quote always)))
