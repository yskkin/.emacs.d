(require 'el-get)
(require 'initsplit)

(add-to-list 'initsplit-customizations-alist `("^\\(global-\\)?undo-tree" ,(or load-file-name (buffer-file-name))))

(el-get-bundle undo-tree)

(provide 'setup-undo-tree)

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(global-undo-tree-mode t)
 '(undo-tree-mode-lighter " 戻")
 '(undo-tree-visualizer-diff t))
