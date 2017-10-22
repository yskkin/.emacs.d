(require 'el-get)
(require 'initsplit)

(add-to-list 'initsplit-customizations-alist `("^calendar" ,(or load-file-name (buffer-file-name))))

(el-get-bundle japanese-holidays
  (require 'japanese-holidays)
  (add-hook 'calendar-today-visible-hook #'japanese-holiday-mark-weekend)
  (add-hook 'calendar-today-invisible-hook #'japanese-holiday-mark-weekend))

(provide 'setup-holiday)

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(calendar-holidays
   (append japanese-holidays holiday-local-holidays holiday-other-holidays))
 '(calendar-mark-holidays-flag t))
