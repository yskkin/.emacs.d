(require 'el-get)

(setq frame-title-format '("" invocation-name "@" system-name ":%b"))
(when (window-system)
  (tool-bar-mode -1)
  (scroll-bar-mode -1)
  (setq initial-frame-alist
        (append
         '((width               . 81)
           (fullscreen . fullheight)
           ;;(height              . 56)
           (top                 .  0)
           (left                .  (- 0))
           ;;通常　非アクティブ
           (alpha               . (92 . 88)))
         initial-frame-alist))
  ;; http://d.hatena.ne.jp/sugyan/20120828/1346082898
  (set-fontset-font nil 'japanese-jisx0208
                    (font-spec :family "Noto Sans CJK JP")))
(menu-bar-mode -1)

(el-get-bundle elpa:elscreen)
(el-get-bundle elscreen-separate-buffer-list)

;;; http://fukuyama.co/sticky-buffer
(defvar sticky-buffer-previous-header-line-format)
(define-minor-mode sticky-buffer-mode
  "Make the current window always display this buffer."
  nil " sticky" nil
  (if sticky-buffer-mode
      (progn
        (set (make-local-variable 'sticky-buffer-previous-header-line-format)
             header-line-format)
        (set-window-dedicated-p (selected-window) sticky-buffer-mode))
    (set-window-dedicated-p (selected-window) sticky-buffer-mode)
    (setq header-line-format sticky-buffer-previous-header-line-format)))

(el-get-bundle buffer-move
  (global-set-key (kbd "M-g h") 'buf-move-left)
  (global-set-key (kbd "M-g j") 'buf-move-down)
  (global-set-key (kbd "M-g k") 'buf-move-up)
  (global-set-key (kbd "M-g l") 'buf-move-right))

;;; https://www.emacswiki.org/emacs/WindMove
(windmove-default-keybindings)

(provide 'setup-window-manager)
