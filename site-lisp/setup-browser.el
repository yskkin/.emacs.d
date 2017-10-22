(require 'el-get)
(require 'initsplit)

(add-to-list 'initsplit-customizations-alist `("^browse-url-" ,(or load-file-name (buffer-file-name))))
(add-to-list 'initsplit-customizations-alist `("^eww-" ,(or load-file-name (buffer-file-name))))
(add-to-list 'initsplit-customizations-alist `("^google-this-" ,(or load-file-name (buffer-file-name))))

(el-get-bundle google-this
  (google-this-mode 1))

(with-eval-after-load 'eww
  (defun my-eww-mode-hook ()
    (setq show-trailing-whitespace nil))
  (add-hook 'eww-mode-hook #'my-eww-mode-hook)

  ;;; http://stackoverflow.com/questions/28458784/emacs-and-eww-open-links-in-new-window
  (defun my-eww-after-render-hook ()
    (defvar eww-data)
    (let* ((title (plist-get eww-data :title))
           (url (plist-get eww-data :url))
           (result (concat "*eww-" (or title
                                       (if (string-match "://" url)
                                           (substring url (match-beginning 0))
                                         url)) "*")))
      (rename-buffer result t)))
  (add-hook 'eww-after-render-hook #'my-eww-after-render-hook)

  (defvar eww-disable-colorize t)
  (defun shr-colorize-region--disable (orig start end fg &optional bg &rest _)
    (unless eww-disable-colorize
      (funcall orig start end fg)))
  (advice-add #'shr-colorize-region :around #'shr-colorize-region--disable)
  (advice-add #'eww-colorize-region :around #'shr-colorize-region--disable)
  (defun eww-disable-color ()
    "ewwで文字色を反映させない"
    (interactive)
    (setq-local eww-disable-colorize t)
    (eww-reload))
  (defun eww-enable-color ()
    "ewwで文字色を反映させる"
    (interactive)
    (setq-local eww-disable-colorize nil)
    (eww-reload))

  ;;; http://rubikitch.com/2014/11/26/helm-eww/
  (defvar eww-data)
  (defun eww-current-url ()
    (if (boundp 'eww-current-url)
        eww-current-url                   ;emacs24.4
      (plist-get eww-data :url)))         ;emacs25
  (defun eww-current-title ()
    (if (boundp 'eww-current-title)
        eww-current-title                   ;emacs24.4
      (plist-get eww-data :title)))

  (require 'helm)
  (require 'cl-lib)

  (defun helm-eww-history-candidates ()
    (cl-loop with hash = (make-hash-table :test 'equal)
             for b in (buffer-list)
             when (eq (buffer-local-value 'major-mode b) 'eww-mode)
             append (with-current-buffer b
                      (clrhash hash)
                      (puthash (eww-current-url) t hash)
                      (cons
                       (cons (format "%s (%s) <%s>" (eww-current-title) (eww-current-url) b) b)
                       (cl-loop for pl in eww-history
                                unless (gethash (plist-get pl :url) hash)
                                collect
                                (prog1 (cons (format "%s (%s) <%s>" (plist-get pl :title) (plist-get pl :url) b)
                                             (cons b pl))
                                  (puthash (plist-get pl :url) t hash)))))))
  (defun helm-eww-history-browse (buf-hist)
    (if (bufferp buf-hist)
        (switch-to-buffer buf-hist)
      (switch-to-buffer (car buf-hist))
      (eww-save-history)
      (eww-restore-history (cdr buf-hist))))
  (defvar helm-source-eww-history
    '((name . "eww history")
      (candidates . helm-eww-history-candidates)
      (migemo)
      (action . helm-eww-history-browse)))
  (defun helm-eww-history ()
    (interactive)
    (helm :sources #'helm-source-eww-history
          :buffer "*helm eww*"))

  (define-key eww-mode-map (kbd "H") #'helm-eww-history))

(provide 'setup-browser)

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(browse-url-browser-function (quote eww-browse-url))
 '(eww-search-prefix "http://www.google.co.jp/search?q=")
 '(google-this-browse-url-function (quote eww-browse-url))
 '(google-this-keybind (kbd "C-x /"))
 '(google-this-modeline-indicator " Goog"))
