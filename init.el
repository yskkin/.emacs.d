;;;-*- coding: utf-8 -*-
;;(setq debug-on-error t)

;;; init.el 内でコメントでもいいので記載がないと自動的に挿入されてしまう
;;; (package-initialize)

;; http://d.hatena.ne.jp/tarao/20150221/1424518030
(when load-file-name
  (setq user-emacs-directory (file-name-directory load-file-name)))

(let ((default-directory (expand-file-name "~/.emacs.d/site-lisp")))
  (add-to-list 'load-path default-directory)
  (normal-top-level-add-subdirs-to-load-path))

(require 'setup-el-get)
(require 'initsplit)

(add-to-list 'initsplit-customizations-alist '("^safe-local" "~/.emacs.d/private.el"))

(el-get-bundle! with-eval-after-load-feature in tarao/with-eval-after-load-feature-el)
(el-get-bundle exec-path-from-shell
  (setq exec-path-from-shell-variables '("PATH" "MANPATH" "PERL5LIB"))
  (exec-path-from-shell-initialize))

(require 'setup-language)
(require 'setup-auth)
(require 'setup-dired)
(require 'setup-clipboard)
(require 'setup-comint)
(require 'setup-completion)
(require 'setup-flycheck)
(require 'setup-key)
(require 'setup-text)
(require 'setup-irfc)
(require 'setup-holiday)
(require 'setup-jvm)
(require 'setup-line-number)
(require 'setup-mail)
(require 'setup-misc)
(require 'setup-modeline)
(require 'setup-browser)
(require 'setup-org)
(require 'setup-org-gcal nil t)
(require 'setup-php)
(require 'setup-plantuml)
(require 'setup-printer)
(require 'setup-projectile)
(require 'setup-ruby)
(require 'setup-scm)
(require 'setup-search)
(require 'setup-shell)
(require 'setup-speedbar)
(require 'setup-tags)
(require 'setup-theme)
(require 'setup-undo-tree)
(require 'setup-web)
(require 'setup-typescript)
(require 'setup-window-manager)

(server-start)

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(alert-default-style (quote notifier))
 '(ansi-color-names-vector
   ["#3F3F3F" "#CC9393" "#7F9F7F" "#F0DFAF" "#8CD0D3" "#DC8CC3" "#93E0E3" "#DCDCCC"])
 '(blink-matching-paren t)
 '(confirm-kill-emacs (quote yes-or-no-p))
 '(custom-safe-themes
   (quote
    ("f1ee3126c1aba9f3ba35bb6f17cb2190557f2223646fd6796a1eb30a9d93e850" default)))
 '(fci-rule-color "#383838")
 '(indent-tabs-mode nil)
 '(inhibit-startup-screen t)
 '(make-backup-files nil)
 '(nrepl-message-colors
   (quote
    ("#CC9393" "#DFAF8F" "#F0DFAF" "#7F9F7F" "#BFEBBF" "#93E0E3" "#94BFF3" "#DC8CC3")))
 '(package-check-signature nil)
 '(package-selected-packages
   (quote
    (php-mode nil async helm-swoop nlinum org scala-mode2 csv-mode)))
 '(require-final-newline t)
 '(show-paren-style (quote mixed))
 '(show-trailing-whitespace t)
 '(sp-autodelete-closing-pair nil)
 '(sp-autodelete-opening-pair nil)
 '(tab-width 4)
 '(visible-bell t)
 '(whitespace-style
   (quote
    (face trailing tabs spaces newline empty indentation space-after-tab space-before-tab space-mark tab-mark newline-mark))))
