(require 'auth-source)
(add-to-list 'auth-sources (concat user-emacs-directory ".authinfo.plist"))

(provide 'setup-auth)
