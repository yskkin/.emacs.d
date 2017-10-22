(require 'el-get)
(require 'initsplit)

(add-to-list 'initsplit-customizations-alist `("^linum" ,(or load-file-name (buffer-file-name))))

(el-get-bundle elpa:hlinum
  (hlinum-activate))

(add-hook 'find-file-hook #'linum-mode)

(provide 'setup-line-number)

(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(linum-highlight-face ((t (:foreground "black" :background "yellow")))))
