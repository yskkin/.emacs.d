(require 'el-get)
(require 'initsplit)
(require 'with-eval-after-load-feature)

(add-to-list 'initsplit-customizations-alist `("^css-" ,(or load-file-name (buffer-file-name))))
(add-to-list 'initsplit-customizations-alist `("^web-mode" ,(or load-file-name (buffer-file-name))))

(el-get-bundle slim-mode)
(el-get-bundle js2-mode
  (add-to-list 'auto-mode-alist '("\\.js\\'" . js2-mode)))
(el-get-bundle vue-mode)
(el-get-bundle web-mode
  (add-to-list 'auto-mode-alist '("\\.erb\\'" . web-mode))
  (add-to-list 'auto-mode-alist '("\\.tag\\'" . web-mode))
  (add-to-list 'magic-mode-alist '("import.*react" . web-mode))
  (with-eval-after-load-feature 'web-mode
    (setq web-mode-ac-sources-alist
          '(("php" . (ac-source-yasnippet))
            ("html" . (ac-source-emmet-html-aliases ac-source-emmet-html-snippets))
            ("css" . (ac-source-css-property ac-source-emmet-css-snippets))))
    (add-hook 'web-mode-before-auto-complete-hooks
              #'(lambda ()
                  (let ((web-mode-cur-language
                         (web-mode-language-at-pos)))
                    (if (string= web-mode-cur-language "php")
                        (yas-activate-extra-mode 'php-mode)
                      (yas-deactivate-extra-mode 'php-mode))
                    (if (string= web-mode-cur-language "css")
                        (setq emmet-use-css-transform t)
                      (setq emmet-use-css-transform nil)))))))
(el-get-bundle yasuyk/web-beautify)
(el-get-bundle emmet-mode
  (with-eval-after-load-feature 'web-mode
    (defun setup-web-web-mode-hook ()
      (emmet-mode)
      ;; http://emacs.stackexchange.com/questions/20016/no-html-jsx-indentation-in-jsx-mode
      (if (equal web-mode-content-type "javascript")
          (web-mode-set-content-type "jsx")))
    (add-hook 'web-mode-hook #'setup-web-web-mode-hook))
  (add-hook 'sgml-mode-hook #'emmet-mode)
  (add-hook 'css-mode-hook #'emmet-mode))

(provide 'setup-web)

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(css-indent-offset 2)
 '(web-mode-attr-indent-offset nil)
 '(web-mode-code-indent-offset 4)
 '(web-mode-markup-indent-offset 2))
