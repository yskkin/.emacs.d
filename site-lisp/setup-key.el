(require 'el-get-bundle)
(require 'initsplit)

(add-to-list 'initsplit-customizations-alist `("^guide-key" ,(or load-file-name (buffer-file-name))))
(add-to-list 'initsplit-customizations-alist `("^ns-" ,(or load-file-name (buffer-file-name))))

(el-get-bundle guide-key
  (with-eval-after-load-feature 'guide-key
    (defun guide-key/my-hook-function-for-org-mode ()
      (guide-key/add-local-highlight-command-regexp "org-"))
    (add-hook 'org-mode-hook #'guide-key/my-hook-function-for-org-mode)))

(el-get-bundle keyfreq
  (keyfreq-mode 1)
  (keyfreq-autosave-mode 1))

;; キー
(define-key global-map [?¥] [?\\])
;; `ffap-bindings' をいじる
(global-set-key "\C-h" #'delete-backward-char)
(global-set-key [S-mouse-3] #'ffap-at-mouse)
(global-set-key [C-S-mouse-3] #'ffap-menu)

;;(global-set-key "\C-x\C-f" #'find-file-at-point)
(global-set-key "\C-x\C-r" #'ffap-read-only)
(global-set-key "\C-x\C-v" #'ffap-alternate-file)

(global-set-key "\C-x4f"   #'ffap-other-window)
(global-set-key "\C-x5f"   #'ffap-other-frame)
(global-set-key "\C-x4r"   #'ffap-read-only-other-window)
(global-set-key "\C-x5r"   #'ffap-read-only-other-frame)

(global-set-key "\C-xd"    #'dired-at-point)
(global-set-key "\C-x4d"   #'ffap-dired-other-window)
(global-set-key "\C-x5d"   #'ffap-dired-other-frame)
(global-set-key "\C-x\C-d" #'ffap-list-directory)

(add-hook 'gnus-summary-mode-hook #'ffap-gnus-hook)
(add-hook 'gnus-article-mode-hook #'ffap-gnus-hook)
(add-hook 'vm-mode-hook #'ffap-ro-mode-hook)
(add-hook 'rmail-mode-hook #'ffap-ro-mode-hook)

(global-set-key (kbd "M-<down>")
                #'(lambda () (interactive) (scroll-up-command 1)))
(global-set-key (kbd "M-<up>")
                #'(lambda () (interactive) (scroll-down-command 1)))
(global-set-key (kbd "<C-tab>")
                #'(lambda () (interactive) (switch-to-buffer nil)))
(global-set-key (kbd "<C-S-tab>") #'bury-buffer)

(when (or (eq system-type 'windows-nt) (eq system-type 'cygwin))
  ;; http://ergoemacs.org/emacs/emacs_hyper_super_keys.html
  ;; make PC keyboard's Win key or other to type Super or Hyper, for emacs running on Windows.
  (setq w32-pass-lwindow-to-system nil
        w32-pass-rwindow-to-system t
        w32-pass-apps-to-system nil
        w32-lwindow-modifier 'super ; Left Windows key
        w32-rwindow-modifier 'super ; Right Windows key
        w32-apps-modifier 'hyper))  ; Menu key

(provide 'setup-key)

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(guide-key-mode t)
 '(guide-key/guide-key-sequence (quote ("C-c" "C-x" "C-z")))
 '(guide-key/highlight-command-regexp "rectangle")
 '(guide-key/recursive-key-sequence-flag t)
 '(ns-alternate-modifier (quote super))
 '(ns-command-modifier (quote meta))
 '(ns-function-modifier (quote hyper)))
