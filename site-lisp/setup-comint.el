;;; -*- coding: utf-8 -*-
(require 'initsplit)

(add-to-list 'initsplit-customizations-alist `("^comint-" ,(or load-file-name (buffer-file-name))))

;;; for projectile-rails-server
(add-hook 'compilation-filter-hook #'comint-truncate-buffer)
;;; for shell-mode
(add-hook 'comint-output-filter-functions #'comint-truncate-buffer)

(provide 'setup-comint)

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(comint-buffer-maximum-size 2000))
