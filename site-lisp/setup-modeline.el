;; http://shibayu36.hatenablog.com/entry/2012/12/29/001418
(require 'initsplit)
(require 'uniquify)

(add-to-list 'initsplit-customizations-alist `("^display-time-" ,(or load-file-name (buffer-file-name))))

(setq uniquify-buffer-name-style 'post-forward-angle-brackets)

;; https://github.com/znz/dot-emacs/blob/8434c73ba833791eedc1411360e10441e52b370e/init.el.d/50mode-line.el
(line-number-mode nil)
(column-number-mode nil)
(size-indication-mode nil)
(setq mode-line-position
      '(:eval (format "L%%l/%d,C%%c"
                      (count-lines (point-max)
                                   (point-min)))))

(which-function-mode 1)
(display-time-mode t)

;; http://blog.n-z.jp/blog/2013-12-11-emacs-color-mode-line.html
(defun my-shorten-minor-mode-name (mode-sym short-name &optional face)
  "minor-modeの名前を短くする。"
  (let ((cell (assq mode-sym minor-mode-alist)))
    (when (consp cell)
      (if face
          (setq short-name (propertize short-name 'face face))
        (setq short-name (concat " " short-name)))
      (setcar (cdr cell) short-name))))

(eval-after-load "view" '(my-shorten-minor-mode-name 'view-mode "見"))
(eval-after-load "guide-key" '(my-shorten-minor-mode-name 'guide-key-mode "案"))

(defvar my-shorten-mode-name-list
      '((change-log-mode "歴")
        (fundamental-mode "基")
        (help-mode "助")
        (emacs-lisp-mode "'" (:foreground "green" :background "white"))
        (lisp-interaction-mode "`" (:foreground "red" :background "white"))
        (perl-mode "pl" (:foreground "yellow" :background "white"))
        (python-mode "py" (:foreground "yellow" :background "white"))
        (ruby-mode "rb" (:foreground "red" :background "white"))
        (texinfo-mode "Texi")))

(defun my-shorten-mode-name ()
  (let ((m (assq major-mode my-shorten-mode-name-list)))
    (when m
      (let* ((sym (car m))
             (face (caddr m))
             (name (cadr m)))
        (when (and face (fboundp 'propertize))
          (setq name (propertize name 'face face)))
        (setq mode-name name)))))

(add-hook 'after-change-major-mode-hook #'my-shorten-mode-name)

(provide 'setup-modeline)

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(display-time-default-load-average 1)
 '(display-time-format "%m/%e %R")
 '(display-time-load-average-threshold 0.8))
