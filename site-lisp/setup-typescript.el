(require 'el-get)
(require 'initsplit)
(require 'with-eval-after-load-feature)

(el-get-bundle typescript-mode
    (add-to-list 'auto-mode-alist '("\\.tsx?\\'" . typescript-mode)))

(el-get-bundle tide
  (defun setup-tide-mode ()
    (interactive)
    (tide-setup)
    (setq flycheck-check-syntax-automatically '(save mode-enabled idle-change))
    (tide-hl-identifier-mode t))

  (add-hook 'typescript-mode-hook #'setup-tide-mode)
  (add-hook 'web-mode-hook #'setup-tide-mode))

(provide 'setup-typescript)
