(require 'el-get)
(require 'initsplit)

(add-to-list 'initsplit-customizations-alist `("^anzu-" ,(or load-file-name (buffer-file-name))))
(add-to-list 'initsplit-customizations-alist `("^moccur-" ,(or load-file-name (buffer-file-name))))
(add-to-list 'initsplit-customizations-alist `("^wgrep-" ,(or load-file-name (buffer-file-name))))

(el-get-bundle ag)
(el-get-bundle wgrep)

;; http://qiita.com/syohex/items/56cf3b7f7d9943f7a7ba
(el-get-bundle anzu
  (global-anzu-mode 1))

(el-get-bundle color-moccur
  (global-set-key (kbd "M-o") #'occur-by-moccur))

(el-get-bundle ace-jump-mode
  (setq ace-jump-mode-move-keys
        (append "asdfghjkl;:]qwertyuiop@zxcvbnm,." nil))
  (setq ace-jump-word-mode-use-query-char nil)
  (global-set-key (kbd "C-:") #'ace-jump-char-mode)
  (global-set-key (kbd "C-;") #'ace-jump-word-mode)
  (global-set-key (kbd "C-M-;") #'ace-jump-line-mode))

(provide 'setup-search)

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(anzu-deactivate-region t)
 '(anzu-mode-lighter "")
 '(anzu-search-threshold 500)
 '(moccur-kill-moccur-buffer t)
 '(moccur-split-word t)
 '(moccur-use-migemo t)
 '(wgrep-auto-save-buffer t)
 '(wgrep-enable-key "r"))
