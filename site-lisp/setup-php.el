(require 'el-get)
(require 'initsplit)

(add-to-list 'initsplit-customizations-alist `("^php" ,(or load-file-name (buffer-file-name))))

(el-get-bundle php-mode
  (add-to-list 'auto-mode-alist '("\\.ctp$" . php-mode))
  (defun my-php-hook-php-mode ()
    (c-set-offset 'case-label 4))
  (add-hook 'php-mode-hook #'my-php-hook-php-mode))

(el-get-bundle nishimaki10/emacs-phpcbf
  :name phpcbf
  :depends (s))

(el-get-bundle! ejmr/php-auto-yasnippets
  (define-key php-mode-map (kbd "C-c C-y") 'yas/create-php-snippet)
  (payas/ac-setup))

(el-get-bundle ac-php
  (defun my-php-hook-ac-php ()
    (require 'ac-php)
    (add-to-list 'ac-sources 'ac-source-php)
    (define-key php-mode-map (kbd "C-]") 'ac-php-find-symbol-at-point)
    (define-key php-mode-map (kbd "C-t") 'ac-php-lotion-stack-back))
  (add-hook 'php-mode-hook #'my-php-hook-ac-php))

(provide 'setup-php)

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(phpcbf-executable "~/.composer/vendor/bin/phpcbf")
 '(phpcbf-standard "PSR2"))
