(require 'el-get)
(require 'initsplit)

(add-to-list 'initsplit-customizations-alist `("^c?tags-" ,(or load-file-name (buffer-file-name))))

(el-get-bundle ctags-update)
(el-get-bundle helm-etags-plus
  (add-hook 'c-mode-common-hook #'turn-on-ctags-auto-update-mode)
  (add-hook 'emacs-lisp-mode-hook #'turn-on-ctags-auto-update-mode)

  (global-set-key "\C-cE" #'ctags-update))

(provide 'setup-tags)

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(ctags-update-other-options
   (quote
    ("--fields=+iaSt" "--extra=+q" "--exclude='*.elc'" "--exclude='*.class'" "--exclude='.git'" "--exclude='.svn'" "--exclude='test'" "--exclude='vendor'")))
 '(tags-revert-without-query t))
