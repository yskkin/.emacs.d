(require 'el-get)

(add-hook 'prog-mode-hook #'whitespace-mode)
(el-get-bundle yafolding
  (add-hook 'prog-mode-hook #'yafolding-mode))

(set-face-attribute 'default nil
                  :family "Source Han Code JP")

(el-get-bundle csv-mode)
(el-get-bundle markdown-mode)
(el-get-bundle yaml-mode
  (add-to-list 'auto-mode-alist '("\\.ya?ml$" . yaml-mode)))

(el-get-bundle 'comment-dwim-2
  (global-set-key (kbd "M-;") #'comment-dwim-2))

(defun indent-buffer ()
  "Indent the currently visited buffer."
  (interactive)
  (indent-region (point-min) (point-max)))

(defun indent-region-or-buffer ()
  "Indent a region if selected, otherwise the whole buffer."
  (interactive)
  (save-excursion
    (if (region-active-p)
        (progn
          (indent-region (region-beginning) (regioin-end))
          (message "Indented selected region."))
      (progn
        (indent-buffer)
        (message "Indented buffer.")))))

;; http://d.hatena.ne.jp/kitokitoki/20101211/p1
(defun my-auto-revert-tail-mode-on ()
  (interactive)
  (if (string-match "\\.log$" buffer-file-name)
      (auto-revert-tail-mode t)
    (auto-revert-tail-mode 0)))

(global-auto-revert-mode t)
(add-hook 'find-file-hook #'my-auto-revert-tail-mode-on)
(add-hook 'after-revert-hook
          #'(lambda ()
              (when auto-revert-tail-mode
                (end-of-buffer))))

(add-hook 'picture-mode-hook #'picture-mode-init)
(autoload #'picture-mode-init "picture-init")

(provide 'setup-text)
