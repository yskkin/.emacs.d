(require 'el-get)

(el-get-bundle alert
  (custom-set-variables
   '(alert-default-style 'notifier)))
(el-get-bundle auto-highlight-symbol
  (global-auto-highlight-symbol-mode t))
(el-get-bundle edbi)
(el-get-bundle editorconfig
  (editorconfig-mode 1)
  (setcar (cdr (assq 'editorconfig-mode minor-mode-alist)) " EC"))
(el-get-bundle evil)
(el-get-bundle htmlize)
(el-get-bundle pomodoro)
(el-get-bundle reveal-in-osx-finder)
(el-get-bundle sudo-edit)
(el-get-bundle fiplr)

(provide 'setup-misc)
