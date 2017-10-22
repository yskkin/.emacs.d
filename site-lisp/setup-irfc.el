(require 'el-get)
(require 'initsplit)

(add-to-list 'initsplit-customizations-alist `("^irfc-" ,(or load-file-name (buffer-file-name))))

(el-get-bundle yskkin/irfc
  (add-hook 'irfc-mode-hook
            #'(lambda ()
                (read-only-mode 1))))

(provide 'setup-irfc)

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(irfc-assoc-mode t))
