(require 'el-get)
(require 'initsplit)

(add-to-list 'initsplit-customizations-alist `("^default-input-method" ,(or load-file-name (buffer-file-name))))
(add-to-list 'initsplit-customizations-alist `("^skk-" ,(or load-file-name (buffer-file-name))))

(set-language-environment "Japanese")
(prefer-coding-system 'utf-8)
(setq default-process-coding-system '(utf-8 . utf-8))
(when (eq system-type 'darwin)
  (require 'ucs-normalize)
  (set-file-name-coding-system 'utf-8-hfs))
(setenv "LC_ALL" "ja_JP.UTF-8")

(set-face-attribute 'default nil
                  :family "Source Han Code JP")

(el-get-bundle migemo
  (require 'migemo)
  (setq migemo-command "cmigemo")
  (setq migemo-options '("-q" "--emacs"))

  ;; Set your installed path
  (setq migemo-dictionary "/usr/local/share/migemo/utf-8/migemo-dict")

  (setq migemo-user-dictionary nil)
  (setq migemo-regex-dictionary nil)
  (setq migemo-coding-system 'utf-8-unix)
  (load-library "migemo")
  (migemo-init))

;; http://d.hatena.ne.jp/tomoya/20090711/1247314350
(el-get-bundle ddskk
  ;;(global-set-key "\C-x\C-j" 'skk-mode)
  ;;(global-set-key "\C-xj" 'dired-jump)
  (with-eval-after-load-feature 'skk
    (require 'skk-hint)                         ; ヒント
    (require 'context-skk)

    (add-hook 'isearch-mode-hook #'skk-isearch-mode-setup)
    (add-hook 'isearch-mode-end-hook #'skk-isearch-mode-cleanup)))

(provide 'setup-language)

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(default-input-method "japanese-skk")
 '(skk-auto-insert-paren nil)
 '(skk-delete-implies-kakutei nil)
 '(skk-egg-like-newline t)
 '(skk-henkan-show-candidates-rows 2)
 '(skk-henkan-strict-okuri-precedence t)
 '(skk-show-annotation t)
 '(skk-show-inline t)
 '(skk-sticky-key ";")
 '(skk-use-look t))
