(require 'el-get)

(el-get-bundle plantuml-mode
  ;;; http://d.hatena.ne.jp/a_bicky/20121016/1350347857
  (add-to-list 'auto-mode-alist '("\\.uml\\'" . plantuml-mode))

  (defvar plantuml-jar-path "/usr/local/Cellar/plantuml/8031/plantuml.8031.jar")
  (defvar plantuml-java-options "")
  (defvar plantuml-options "-charset UTF-8")
  (defvar plantuml-mode-map
    (let ((map (make-sparse-keymap)))
      (define-key map (kbd "C-c C-c") #'plantuml-execute)
      map))

  (defun plantuml-execute ()
    (interactive)
    (when (buffer-modified-p)
      (map-y-or-n-p "Save this buffer before executing PlantUML?"
                    'save-buffer (list (current-buffer))))
    (let ((code (buffer-string))
          out-file
          cmd)
      (when (string-match "^\\s-*@startuml\\s-+\\(\\S-+\\)\\s*$" code)
        (setq out-file (match-string 1 code)))
      (setq cmd (concat
                 "java -jar " plantuml-java-options " "
                 (shell-quote-argument plantuml-jar-path) " "
                 (and out-file (concat "-t" (file-name-extension out-file))) " "
                 plantuml-options " "
                 (buffer-file-name)))
      (message cmd)
      (shell-command cmd)
      (message "done"))))

(provide 'setup-plantuml)
