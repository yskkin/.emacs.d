(require 'el-get)
(require 'initsplit)

(add-to-list 'initsplit-customizations-alist `("^projectile-" ,(or load-file-name (buffer-file-name))))

(el-get-bundle bbatsov/helm-projectile
  :depends (cl-lib dash helm projectile)
  (helm-projectile-on))
(el-get-bundle projectile
  (projectile-global-mode))
(el-get-bundle projectile-rails
  (add-hook 'projectile-mode-hook #'projectile-rails-on))
(el-get-bundle projectile-speedbar
  (autoload 'projectile-speedbar-toggle "projectile-speedbar" nil t)
  (autoload 'projectile-speedbar-open-current-buffer-in-tree "projectile-speedbar" nil t))

(provide 'setup-projectile)

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(projectile-completion-system (quote helm)))
