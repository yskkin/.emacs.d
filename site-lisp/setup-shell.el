(require 'el-get)
(require 'initsplit)

(add-to-list 'initsplit-customizations-alist `("^\\(multi-\\)?term" ,(or load-file-name (buffer-file-name))))

(el-get-bundle multi-term)

(provide 'setup-shell)
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(term-bind-key-alist
   (quote
    (("C-c C-c" . term-interrupt-subjob)
     ("C-c C-e" . term-send-esc)
     ("C-p" . previous-line)
     ("C-n" . next-line)
     ("C-s" . isearch-forward)
     ("C-r" . isearch-backward)
     ("C-m" . term-send-return)
     ("C-y" . term-paste)
     ("M-f" . term-send-forward-word)
     ("M-b" . term-send-backward-word)
     ("M-o" . term-send-backspace)
     ("M-p" . term-send-up)
     ("M-n" . term-send-down)
     ("M-M" . term-send-forward-kill-word)
     ("M-N" . term-send-backward-kill-word)
     ("<C-backspace>" . term-send-backward-kill-word)
     ("M-r" . term-send-reverse-search-history)
     ("M-d" . term-send-delete-word)
     ("M-," . term-send-raw)
     ("M-." . comint-dynamic-complete)
     ("C-c C-n" . multi-term-next)
     ("C-c C-p" . multi-term-prev))))
 '(term-unbind-key-list
   (quote
    ("C-a" "C-e" "C-n" "C-p" "C-@" "C-z" "C-x" "C-c" "C-h" "C-y" "<ESC>"))))
