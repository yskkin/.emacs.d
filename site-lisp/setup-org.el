;;; -*-coding:utf-8-*-

(require 'el-get)
(require 'initsplit)

(add-to-list 'initsplit-customizations-alist `("^org-" ,(or load-file-name (buffer-file-name))))

(el-get-bundle org
  (org-clock-persistence-insinuate)

  (eval-when-compile
    (require 'org-capture))

  (global-set-key "\C-cl" 'org-store-link)
  (global-set-key "\C-cc" 'org-capture)
  (global-set-key "\C-ca" 'org-agenda)
  (global-set-key "\C-cb" 'org-iswitchb)

  (unless (member "CLOCK" org-special-properties)
    (defun org-get-CLOCK-property (&optional pom)
      (org-with-wide-buffer
       (org-with-point-at pom
         (when (and (derived-mode-p 'org-mode)
                    (ignore-errors (org-back-to-heading t))
                    (search-forward org-clock-string
                                    (save-excursion (outline-next-heading) (point))
                                    t))
           (skip-chars-forward " ")
           (cons "CLOCK"  (buffer-substring-no-properties (point) (point-at-eol)))))))
    (defadvice org-entry-properties (after with-CLOCK activate)
      "special-propertyにCLOCKを復活させorg習慣仕事術を最新版orgで動かす"
      (let ((it (org-get-CLOCK-property (ad-get-arg 0))))
        (setq ad-return-value
              (if it
                  (cons it ad-return-value)
                ad-return-value)))))

  ;;; http://peccu.hatenablog.com/entry/2016/02/10/000000
  (defun org-clock-get-sum-start ()
    "Return the time from which clock times should be counted.
This is for the currently running clock as it is displayed
in the mode line.  This function looks at the properties
LAST_REPEAT and in particular CLOCK_MODELINE_TOTAL and the
corresponding variable `org-clock-mode-line-total' and then
decides which time to use."
    (let ((cmt (or (org-entry-get nil "CLOCK_MODELINE_TOTAL" t)
                   (symbol-name org-clock-mode-line-total)))
          (lr (org-entry-get nil "LAST_REPEAT")))
      (cond
       ((equal cmt "current")
        (setq org--msg-extra "showing time in current clock instance")
        (current-time))
       ((equal cmt "today")
        (setq org--msg-extra "showing today's task time.")
        (let* ((dt (decode-time))
               (hour (nth 2 dt))
               (day (nth 3 dt)))
          (if (< hour org-extend-today-until) (setf (nth 3 dt) (1- day)))
          (setf (nth 2 dt) org-extend-today-until)
          (setq dt (append (list 0 0) (nthcdr 2 dt)))
          (apply 'encode-time dt)))
       ((or (equal cmt "all")
            (and (or (not cmt) (equal cmt "auto"))
                 (not lr)))
        (setq org--msg-extra "showing entire task time.")
        nil)
       ((or (equal cmt "repeat")
            (and (or (not cmt) (equal cmt "auto"))
                 lr))
        (setq org--msg-extra "showing task time since last repeat.")
        (if (not lr)
            nil
          (org-time-string-to-time lr)))
       (t nil))))

  ;;; http://futurismo.biz/archives/4541
  (defun my-org-clocking-alert ()
    (unless (org-clocking-p)
      (alert "You should start clocking" :title "What are you doing?")))
  (defvar my-org-clocking-alert (run-at-time t 30 #'my-org-clocking-alert))
  (defun my-org-cancel-timer ()
    (interactive)
    (cancel-timer my-org-clocking-alert)))

(el-get-bundle org-reveal)
(add-to-list 'auto-mode-alist '("\\.org\\'" . org-mode))

(el-get-bundle 0x60df/ox-qmd
  (require 'ox-qmd))

(provide 'setup-org)

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(org-agenda-custom-commands
   (quote
    (("n" "Agenda and all TODOs"
      ((tags "habit-CLOCK>=\"<today>\"|repeatable")
       (alltodo)
       (agenda ""))))))
 '(org-agenda-files (list "~/Dropbox/org_memo"))
 '(org-agenda-format-date "%Y/%m/%d (%a)")
 '(org-agenda-span 30)
 '(org-agenda-start-with-log-mode (quote (state clock closed)))
 '(org-babel-load-languages (quote ((ditaa . t) (dot . t) (plantuml . t))))
 '(org-capture-templates
   (quote
    (("t" "Todo" entry
      (file+headline "tasks.org" "Tasks")
      "* TODO %?
   %i
   %a
   %t")
     ("j" "Journal" entry
      (file+datetree "journal.org")
      "* %?
   %i
   %a
   %U")
     ("q" "Question" entry
      (file+datetree "journal.org")
      "* %?    :QUESTION:
   %i
   %a
   %U")
     ("n" "Immediate TODO" entry
      (file+headline "tasks.org" "Tasks")
      "* TODO %?
   %i
   %a
   %t" :clock-in t :clock-keep t))))
 '(org-clock-clocktable-default-properties (quote (:maxlevel 4 :scope file)))
 '(org-clock-persist t)
 '(org-confirm-babel-evaluate nil)
 '(org-default-notes-file
   (concat org-directory "agenda_"
           (format-time-string "%y%m%d")
           ".org"))
 '(org-directory "~/Dropbox/org_memo/")
 '(org-ditaa-jar-path "~/.emacs.d/bin/ditaa0_9.jar")
 '(org-emphasis-alist
   (quote
    (("*" bold)
     ("/" italic)
     ("=" org-verbatim verbatim)
     ("~" org-code verbatim)
     ("+"
      (:strike-through t)))))
 '(org-export-with-section-numbers nil)
 '(org-html-inline-image-rules
   (quote
    (("file" . "\\.\\(jpeg\\|jpg\\|png\\|gif\\|svg\\|bmp\\)\\'")
     ("http" . "\\.\\(jpeg\\|jpg\\|png\\|gif\\|svg\\)\\'")
     ("https" . "\\.\\(jpeg\\|jpg\\|png\\|gif\\|svg\\)\\'"))))
 '(org-plantuml-jar-path "~/.emacs.d/bin/plantuml.7986.jar")
 '(org-return-follows-link t)
 '(org-reveal-root (locate-user-emacs-file "reveal.js"))
 '(org-src-fontify-natively t)
 '(org-startup-truncated nil)
 '(org-todo-keywords (quote ((sequence "PENDING" "TODO" "DONE")))))

(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(org-agenda-date ((t :weight bold))))

