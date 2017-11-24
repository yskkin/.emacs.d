(require 'el-get)
(require 'initsplit)

(add-to-list 'initsplit-customizations-alist `("^flycheck-" ,(or load-file-name (buffer-file-name))))

(el-get-bundle flycheck
  (add-hook 'after-init-hook #'global-flycheck-mode)

  (with-eval-after-load-feature 'flycheck

    (flycheck-add-mode 'php 'web-mode)
    (flycheck-add-mode 'php-phpcs 'web-mode)
    (flycheck-add-mode 'javascript-eslint 'web-mode)

    (put 'flycheck-javascript-eslint-executable 'safe-local-variable #'stringp)
    (flycheck-define-checker php-phpcs1
      "A PHP style checker using PHP Code Sniffer.

Works with older PHP Code Sniffer.

See URL `http://pear.php.net/package/PHP_CodeSniffer/'."
      :command ("phpcs" "--report=checkstyle"
                (option "--standard=" flycheck-phpcs-standard concat) source)
      :standard-input nil
      :error-parser flycheck-parse-checkstyle
      :error-filter
      (lambda (errors)
        (flycheck-sanitize-errors
         (flycheck-remove-error-file-names "STDIN" errors)))
      :modes (php-mode php+-mode))
    (add-to-list 'flycheck-checkers 'php-phpcs1)
    (flycheck-add-next-checker 'php '(warning . php-phpcs1))))

(el-get-bundle flycheck-pos-tip
  (with-eval-after-load 'flycheck
    (flycheck-pos-tip-mode)))

(provide 'setup-flycheck)

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(flycheck-disabled-checkers (quote (javascript-jshint javascript-jscs)))
 '(flycheck-phpcs-standard "PSR2")
 '(flycheck-pos-tip-timeout 30))
