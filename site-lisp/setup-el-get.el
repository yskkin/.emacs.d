(let ((versioned-dir (locate-user-emacs-file emacs-version)))
  (setq el-get-dir (expand-file-name "el-get" versioned-dir)
        package-user-dir (expand-file-name "elpa" versioned-dir)))

(add-to-list 'load-path (locate-user-emacs-file (format "%s/el-get/el-get" emacs-version)))

(defun package--ensure-init-file ()
  "Overwrite to do nothing")

(unless (require 'el-get nil 'noerror)
  (with-current-buffer
      (url-retrieve-synchronously
       "https://raw.githubusercontent.com/dimitri/el-get/master/el-get-install.el")
    (goto-char (point-max))
    (eval-print-last-sexp)))

(add-to-list 'el-get-recipe-path (locate-user-emacs-file "recipes"))

;; http://stackoverflow.com/questions/23165158/how-do-i-install-melpa-packages-via-el-get
(require 'el-get-elpa)
(unless (file-directory-p el-get-recipe-path-elpa)
  (require 'package)
  (add-to-list 'package-archives
               '("melpa" . "http://melpa.milkbox.net/packages/") t)
  (el-get-elpa-build-local-recipes))

(el-get-bundle! initsplit)
(add-to-list 'initsplit-customizations-alist `("^el-get-" ,(or load-file-name (buffer-file-name))))

(provide 'setup-el-get)

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(el-get-git-shallow-clone t)
 '(el-get-notify-type (quote message)))
