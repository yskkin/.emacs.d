;; https://tamosblog.wordpress.com/2013/12/11/cocoa-emacs24_print/
(require 'pdf-preview)
(setq pdf-preview-preview-command "open -a Preview.app")
(setq ps-line-number t)


(setq ps-multibyte-buffer 'non-latin-printer)
(require 'ps-mule)
(defalias 'ps-mule-header-string-charsets 'ignore)

(provide 'setup-printer)
