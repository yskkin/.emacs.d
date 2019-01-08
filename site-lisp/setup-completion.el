(require 'el-get)
(require 'initsplit)
(require 'with-eval-after-load-feature)

(add-to-list 'initsplit-customizations-alist `("^ac-" ,(or load-file-name (buffer-file-name))))
(add-to-list 'initsplit-customizations-alist `("^helm-" ,(or load-file-name (buffer-file-name))))

(el-get-bundle company
  (setq company-tooltip-align-annotations t)
  (global-company-mode))

(el-get-bundle! helm
  (helm-mode 1)
  (eval-after-load 'migemo #'(lambda () (helm-migemo-mode 1)))
  (setq helm-completion-mode-string " H")

  (define-key helm-read-file-map (kbd "C-h") #'delete-backward-char)
  ;; For find-file etc.
  (define-key helm-read-file-map (kbd "TAB") #'helm-execute-persistent-action)
  ;; For helm-find-files etc.
  (define-key helm-find-files-map (kbd "TAB") #'helm-execute-persistent-action)

  ;;http://d.hatena.ne.jp/a_bicky/20140104/1388822688
  (define-key global-map (kbd "M-x") #'helm-M-x)
  (define-key global-map (kbd "C-x C-f") #'helm-find-files)
  (define-key global-map (kbd "C-x C-r") #'helm-recentf)
  (define-key global-map (kbd "M-y") #'helm-show-kill-ring)
  (define-key global-map (kbd "C-c i") #'helm-imenu)
  (define-key global-map (kbd "C-x b") #'helm-buffers-list))

(el-get-bundle helm-descbinds
  (helm-descbinds-mode 1))

(el-get-bundle auto-complete
  (add-to-list 'ac-dictionary-directories "~/.emacs.d/ac-dict")
  (ac-config-default))
(el-get-bundle yasuyk/ac-emmet
  :depends (auto-complete emmet-mode))
(el-get-bundle ac-helm)
(el-get-bundle ac-html)
(el-get-bundle knu/ac-ja.el
  :depends auto-complete
  :name ac-ja)
(el-get-bundle ac-js2)

(el-get-bundle yasnippet
  (add-hook 'prog-mode-hook #'yas-minor-mode)
  (with-eval-after-load-feature 'yasnippet
    (yas-reload-all)
    (setq yas-snippet-dirs '("~/.emacs.d/yasnippet" "~/.emacs.d/yasnippet-php-mode" yas-installed-snippets-dir))))

(el-get-bundle smartparens
  (smartparens-global-mode t))
(show-paren-mode t)

(provide 'setup-completion)

;;; See http://qiita.com/akisute3@github/items/7c8ea3970e4cbb7baa97
;;; for `helm-completing-read-handlers-alist'
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(ac-modes
   (quote
    (emacs-lisp-mode lisp-mode lisp-interaction-mode c-mode cc-mode c++-mode go-mode java-mode scala-mode coq-mode haskell-mode perl-mode python-mode ruby-mode php-mode js-mode js2-mode css-mode scss-mode less-css-mode makefile-mode sh-mode xml-mode sgml-mode web-mode sql-mode)))
 '(helm-completing-read-handlers-alist
   (quote
    ((find-file-at-point)
     (describe-function . helm-completing-read-symbols)
     (describe-variable . helm-completing-read-symbols)
     (describe-symbol . helm-completing-read-symbols)
     (debug-on-entry . helm-completing-read-symbols)
     (find-function . helm-completing-read-symbols)
     (disassemble . helm-completing-read-symbols)
     (trace-function . helm-completing-read-symbols)
     (trace-function-foreground . helm-completing-read-symbols)
     (trace-function-background . helm-completing-read-symbols)
     (find-tag . helm-completing-read-with-cands-in-buffer)
     (org-capture . helm-org-completing-read-tags)
     (org-set-tags . helm-org-completing-read-tags)
     (ffap-alternate-file)
     (tmm-menubar)
     (find-file)
     (execute-extended-command))))
 '(helm-ff-auto-update-initial-value nil)
 '(helm-ff-guess-ffap-filenames t)
 '(helm-ff-search-library-in-sexp t)
 '(helm-ff-skip-boring-files t))
