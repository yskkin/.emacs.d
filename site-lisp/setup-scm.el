(require 'el-get-bundle)
(require 'initsplit)

(add-to-list 'initsplit-customizations-alist `("\\(^magit\\|^vc-\\)" ,(or load-file-name (buffer-file-name))))

(el-get-bundle! git-gutter-fringe+)
(el-get-bundle magit
  (global-set-key (kbd "C-x g") #'magit-status))

;; http://www.clear-code.com/blog/2012/4/3.html
(add-hook 'diff-mode-hook #'diff-auto-refine-mode)

(provide 'setup-scm)

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(magit-diff-refine-hunk (quote all))
 '(vc-annotate-background "#2B2B2B")
 '(vc-annotate-color-map
   (quote
    ((20 . "#BC8383")
     (40 . "#CC9393")
     (60 . "#DFAF8F")
     (80 . "#D0BF8F")
     (100 . "#E0CF9F")
     (120 . "#F0DFAF")
     (140 . "#5F7F5F")
     (160 . "#7F9F7F")
     (180 . "#8FB28F")
     (200 . "#9FC59F")
     (220 . "#AFD8AF")
     (240 . "#BFEBBF")
     (260 . "#93E0E3")
     (280 . "#6CA0A3")
     (300 . "#7CB8BB")
     (320 . "#8CD0D3")
     (340 . "#94BFF3")
     (360 . "#DC8CC3"))))
 '(vc-annotate-very-old-color "#DC8CC3"))
