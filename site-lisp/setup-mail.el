(require 'el-get)

;; https://github.com/luozengbin/dot.emacs.d/blob/master/local-lisp/my-notification.el
;;
;; メール自動受信および通知
;;______________________________________________________________________
(defvar setup-mail-mew-fetch-mail-timer nil "自動受信タイマー")
(defvar setup-mail-mew-fetch-mail-interval-time (* 3 60) "自動受信間隔、単位秒")
(defvar setup-mail-mew-fetch-mail-deley-time (* 1 60) "初回自動受信延遅実行秒数")

(defun setup-mail-fetch-mail-timer-toggle ()
  "メール自動受信トグル"
  (interactive)
  (cond
   ((not setup-mail-mew-fetch-mail-timer)
    (setup-mail-mew-fetch-mail-timer-on)
    (message "Trun On mew-fetch-mail-timer"))
   (t
    (setup-mail-mew-fetch-mail-timer-off)
    (message "Trun Off mew-fetch-mail-timer"))))

(defun setup-mail-mew-fetch-mail-timer-on ()
  (setup-mail-cancel-timer-by-funcname 'setup-mail-mew-fetch-mail)
  (setq setup-mail-mew-fetch-mail-timer
        (run-with-timer setup-mail-mew-fetch-mail-deley-time
                        setup-mail-mew-fetch-mail-interval-time 'setup-mail-mew-fetch-mail)))

(defun setup-mail-mew-fetch-mail-timer-off ()
  (cancel-timer setup-mail-mew-fetch-mail-timer)
  (setq setup-mail-mew-fetch-mail-timer nil))

(defun setup-mail-mew-fetch-mail ()
  "受信処理を駆動する"
  (interactive)
  (if mew-passwd-alist                  ;認証済み、精密な確認ではない
      (save-excursion
        (save-window-excursion
          ;; 新しいフレームを作成し、受信処理を行い
          (let ((temp-current-frame (selected-frame))
                (temp-frame (make-frame '((visibility . nil)
                                          (minibuffer . t)))))
            (select-frame temp-frame)
            (put 'my-mew-fetch-mail 'running t)
            ;; (put 'my-mew-fetch-mail 'current-work-frame temp-frame)
            (with-current-buffer (setup-mail-mew-get-summary-buffer-name)
              (setup-mail-mew-fetch-mail-log "------ fetch new mail ------")
              (put 'setup-mail-mew-fetch-mail 'old-inbox-line-count (count-lines (point-min) (point-max)))
              ;; (put 'my-mew-temp-work-frame temp-frame)
              (setup-mail-mew-fetch-mail-log "[before fetch] count line in mail box: " (get 'setup-mail-mew-fetch-mail 'old-inbox-line-count))
              ;; メール受信処理
              (setup-mail-mew-fetch-mail-log "running mew-summary-retrieve...")
              (if (mew-folder-remotep (mew-proto mew-case))
                  ;; imapの場合は "s"
                  (setup-mail-mew-fetch-mail-log (pp-to-string (mew-summary-ls nil 'goend 'update)))
                ;; popの場合は "i"
                (setup-mail-mew-fetch-mail-log (pp-to-string (mew-summary-retrieve)))))
            (select-frame temp-current-frame)
            ;; フレームを削除する
            (if (frame-live-p temp-frame)
                (delete-frame temp-frame)))))))

(defun setup-mail-mew-get-summary-buffer-name ()
  "現在選択されたメールアカウントのsummaryバッファー名を求める関数"
  (let* ((proto (mew-proto mew-case))
         (inbox (mew-proto-inbox-folder proto mew-case))
         case:inbox)
    (cond
     ((mew-folder-remotep proto)
      (setq case:inbox (mew-case-folder mew-case inbox)))
     (t ;; local
      (setq case:inbox inbox)))))

(defun setup-mail-summary-matched-regp ()
  "サマリーバッファーから受信したメッセージの情報を抽出するための正規表現式を求める関数"
  (let (matched-regp last-form)
    (setq matched-regp "^")
    (dolist (current-form mew-summary-form)
      (when (stringp current-form)
        (setq matched-regp
              (concat matched-regp
                      (if (and (consp last-form)
                               (or (equal (cdr last-form) '(from))
                                   (equal (cdr last-form) '(subj))))
                          "\\(.*?\\)"
                        ".*?") current-form)))
      (setq last-form current-form))
    (setq matched-regp (concat matched-regp "\\(.*?$\\)"))))

(defvar setup-mail-mew-notification-max 10)

(defun setup-mail-mew-mail-notification ()
  "受信ボックスの件数差を見て、新たなメッセージ情報を通知する"
  (let* ((is-fetch-status (get 'setup-mail-mew-fetch-mail 'running))
         (old-inbox-line-count (get 'setup-mail-mew-fetch-mail 'old-inbox-line-count))
         (setup-mail-summary-matched-regp (setup-mail-summary-matched-regp))
         setup-mail-summary-from-str setup-mail-summary-title-str setup-mail-summary-content-str
         count-line-inbox new-message-count)
    ;; 実行フラグをOFFにする
    (if is-fetch-status
        (put 'setup-mail-mew-fetch-mail 'running nil))
    ;; 受信件数確認
    (when old-inbox-line-count
      (setup-mail-mew-fetch-mail-log "running my-mew-mail-notification...")
      (put 'setup-mail-mew-fetch-mail 'old-inbox-line-count nil)
      (save-excursion
        (save-window-excursion
          (with-current-buffer (setup-mail-mew-get-summary-buffer-name)
            (setq count-line-inbox (count-lines (point-min) (point-max)))
            (setq new-message-count (- count-line-inbox old-inbox-line-count))
            (setup-mail-mew-fetch-mail-log "[after fetch] count line in mail box: " count-line-inbox)
            (setup-mail-mew-fetch-mail-log (format "you got %s new email. " new-message-count))
            (when (> count-line-inbox old-inbox-line-count)
              (goto-line (1+ old-inbox-line-count))
              (if (> new-message-count setup-mail-mew-notification-max)
                  (alert (format "着信%s件あり" new-message-count) :title "Mew Notification"))
              (let ((notification-counter 0))
                (while (and (< notification-counter setup-mail-mew-notification-max)
                            (search-forward-regexp setup-mail-summary-matched-regp nil t))
                  (setq notification-counter (1+ notification-counter))
                  (setq setup-mail-summary-from-str (buffer-substring (match-beginning 1) (match-end 1)))
                  (setq setup-mail-summary-title-str (buffer-substring (match-beginning 2) (match-end 2)))
                  (setq setup-mail-summary-content-str (buffer-substring (match-beginning 3) (match-end 3)))
                  (setup-mail-mew-fetch-mail-log "receive new mail from" setup-mail-summary-from-str)
                  (alert setup-mail-summary-from-str :title setup-mail-summary-title-str))))))))))

;; "ログ出力関数"
(defvar setup-mail-fetch-mail-log-buffer " *setup-mail-fetch-mail*")

(defun setup-mail-fetch-mail-log (&rest msgs)
  (apply 'setup-mail-log setup-mail-fetch-mail-log-buffer msgs))

(defun setup-mail-show-fetch-mail-log ()
  (interactive)
  (pop-to-buffer setup-mail-fetch-mail-log-buffer))

(defun setup-mail-log (log-bn &rest msgs)
  "ログ出力関数"
  (with-current-buffer (get-buffer-create log-bn)
    (goto-char (point-max))
    (insert (format "[%s] " (format-time-string "%Y/%m/%d %H:%M:%S")))
    (dolist (msg msgs)
      (insert (format "%s " msg)))
    (insert "\n")))

(defun setup-mail-cancel-timer-by-funcname (func-name)
  (loop for x in timer-list do
        (if (string-match (format ".*%s.*" (symbol-name func-name)) (prin1-to-string x))
            (cancel-timer x))))

(el-get-bundle mew
  (autoload 'mew "mew" nil t)
  (autoload 'mew-send "mew" nil t)
  (with-eval-after-load-feature 'mew
    (setq mew-rc-file "~/.emacs.d/mew")
    (setq read-mail-command 'mew)
    (setq mew-ssl-verify-level 0)
    (setq mew-use-cached-passwd t)
    (setq mew-use-master-passwd t)
    (setq mew-use-full-window t)
    (setq mew-summary-show-direction 'up)
    (setq mew-use-unread-mark t)
    (setq mew-use-header-veil nil)

    ;;; 自動受信時message出力しないようにするため
    ;;; 一部の内部関数にアドバイザを適用し、messageの出力を制御する
    (defadvice mew-pop-message (before mew-pop-message-before activate)
      (if (and (get 'setup-mail-mew-fetch-mail 'running) (not (mew-pop-get-no-msg pnm)))
          (mew-pop-set-no-msg pnm t)))

    (defadvice mew-pop-open (before mew-pop-open-before activate)
      (if (get 'setup-mail-mew-fetch-mail 'running)
          (ad-set-arg 3 t)))

    (defadvice mew-imap-message (before mew-imap-message-before activate)
      (if (and (get 'setup-mail-mew-fetch-mail 'running) (not (mew-imap-get-no-msg pnm)))
          (mew-imap-set-no-msg pnm t)))

    (defadvice mew-imap-open (before mew-imap-open-before activate)
      (if (get 'my-mew-fetch-mail 'running)
          (ad-set-arg 3 t)))

    ;; Optional setup (e.g. C-xm for sending a message):
    (autoload 'mew-user-agent-compose "mew" nil t)
    (if (boundp 'mail-user-agent)
        (setq mail-user-agent 'mew-user-agent))
    (if (fboundp 'define-mail-user-agent)
        (define-mail-user-agent
          'mew-user-agent
          'mew-user-agent-compose
          'mew-draft-send-message
          'mew-draft-kill
          'mew-send-hook))))

(provide 'setup-mail)
