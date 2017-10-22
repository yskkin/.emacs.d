;; http://futurismo.biz/archives/2213
;; 情報が古そうなので、適宜最新状況を調べつつ追加

    ;; 2 入力支援
    ;;     2.3 ruby-block
    ;; 3 コードリーディング
    ;;     3.1 ctags/ripper-tags
    ;;     3.2 rcodetools ( xmpfilter )
    ;;     3.3 rdefs
    ;;     3.4 highlight-symbol, auto-highlight-symbol
    ;; 5 コーディング支援
    ;;     5.1 inf-ruby
    ;;     5.2 SmartCompile
    ;;     5.3 auto-complite-ruby/RSense
    ;;         robe
    ;;     5.4 yasnippet-ruby

(require 'el-get)
(require 'initsplit)

(add-to-list 'initsplit-customizations-alist `("^\\(enh-\\)?ruby-" ,(or load-file-name (buffer-file-name))))

(el-get-bundle ruby-refactor)
(el-get-bundle ruby-electric)
(el-get-bundle enh-ruby-mode)

(provide 'setup-ruby)

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(enh-ruby-add-encoding-comment-on-save nil)
 '(enh-ruby-bounce-deep-indent t)
 '(enh-ruby-deep-indent-paren nil)
 '(enh-ruby-use-encoding-map t)
 '(enh-ruby-use-ruby-mode-show-parens-config t)
 '(ruby-deep-indent-paren nil)
 '(ruby-insert-encoding-magic-comment nil))
