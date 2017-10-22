(require 'el-get)
(require 'initsplit)

(add-to-list 'initsplit-customizations-alist `("^speedbar-" ,(or load-file-name (buffer-file-name))))

(el-get-bundle sr-speedbar
  (add-hook 'speedbar-mode-hook
            #'(lambda ()
                (speedbar-add-supported-extension '(".js" ".html" ".css" ".php" ".rb" ".slim" ".erb")))))

(provide 'setup-speedbar)

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(speedbar-update-flag nil))
