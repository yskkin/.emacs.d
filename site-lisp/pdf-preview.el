;; -*- mode: lisp-interaction; syntax: elisp -*-

;; pdf-preview.el : preview text from the buffer as pdf files through PostScript
;; Version 1.0.4
;;
;; Copyright (C) 2004-2005 by T. Hiromatsu <matsuan@users.sourceforge.jp>

;;; Commentary:

;; Comments, questions and feedback will be sent to an english list
;; <http://lists.sourceforge.jp/mailman/listinfo/macemacsjp-english>
;; of MacEmacs JP project <http://macemacsjp.sourceforge.jp/en/>.
;;----------------------------------------------------------------------
;; This program is free software; you can redistribute it and/or
;; modify it under the terms of the GNU General Public License
;; as published by the Free Software Foundation; either version 2
;; of the License, or (at your option) any later version.
;;
;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.
;;
;; The GNU General Public License can be gotten from
;; the Free Software Foundation, Inc.,
;;     59 Temple Place - Suite 330, Boston, MA  02111-1307, USA.
;;     http://www.gnu.org/licenses/gpl.html
;;
;;----------------------------------------------------------------------
;;      本プログラムはフリー・ソフトウェアです。
;;      あなたは、Free Software Foundationが公表したGNU 一般公有使用許諾の
;;      「バージョン２」或いはそれ以降の各バージョンの中からいずれかを選択し、
;;      そのバージョンが定める条項に従って本プログラムを
;;      再頒布または変更することができます。
;;
;;      本プログラムは有用とは思いますが、頒布にあたっては、
;;      市場性及び特定目的適合性についての暗黙の保証を含めて、
;;      いかなる保証も行ないません。
;;      詳細についてはGNU 一般公有使用許諾書をお読みください。
;;
;;      GNU一般公有使用許諾は、　
;;      Free Software Foundation,
;;         59 Temple Place - Suite 330, Boston, MA 02111-1307, USA
;;         http://www.gnu.org/licenses/gpl.html
;;      から入手可能です。
;;
;;----------------------------------------------------------------------
;; 1. Features
;;
;;     This package requires Multilingual Ghostscript. I suggest to
;;     use the package provided by Dr. Ogawa (Kumamoto Gakuen
;;     University).
;;         http://www2.kumagaku.ac.jp/teacher/herogw/index.html
;;         http://www2.kumagaku.ac.jp/teacher/herogw/archive/gplgs041101.dmg
;;
;;     1) Print texts in Emacs buffer through PostScript format as
;;        pdf(portable document format) file, then show it by
;;        adequate viewer. By default, GhostScript (ps2pdf13) will
;;        be used for transform from PostScript to pdf.
;;     2) Make cjk font width 2 times as ascii font.
;;     3) enable to input some parameters interactively.
;;
;; 2. Functions
;;     Totally 10 interactive functions are defined. Main 8 functions
;;     has names similar like as ps-print-* functions.
;;
;;         pdf-preview-spool-buffer
;;         pdf-preview-spool-buffer-with-faces
;;         pdf-preview-spool-region
;;         pdf-preview-spool-region-with-faces
;;
;;     These 4 functions make PostScript buffer "*PostScript*" by
;;     calling ps-spool-* functions after getting parameters
;;     interactively.
;;
;;         pdf-preview-buffer
;;         pdf-preview-buffer-with-faces
;;         pdf-preview-region
;;         pdf-preview-region-with-faces
;;
;;     These 4 functions compensate font width of CJK fonts (multipe
;;     by 1.2) to have 2 times width of ascii by calling
;;     pdf-preview-rescale-mule-font, then make pdf files through
;;     temporal PostScript file by pdf-preview-do-despool.
;;
;;         pdf-preview-rescale-mule-font
;;
;;     Compensate font width of CJK fonts (multipe by 1.2) to have 2
;;     times width of ascii on "*PostScript*" buffer.
;;
;;         pdf-preview-do-despool
;;
;;     Make and preview pdf files through temporal PostScript file.
;;
;; 3. Usage
;; usage1: call interactively
;;     M-x pdf-preview-(buffer|region)(-with-faces)
;;
;; usage2: call interactively with prefix argument
;;     C-u M-x pdf-preview-(buffer|region)(-with-faces)
;;     You can set some factors interactively shown as follows.
;;         ps-paper-type (Paper Size)
;;         ps-landscape-mode (Paper Direction)
;;         ps-print-header (Title on/off)
;;         pdf-preview-font-rescale-factor (Font Rescale Factor)
;;         ps-line-spacing (Linse Spacing)
;;
;; usage3:
;;     (pdf-preview-buffer arg-list) 
;;         arg-list contains
;;             (ps-paper-type ps-landscape-mode
;;              ps-print-header pdf-preview-font-rescale-factor ps-line-spacing).
;;
;;     example ; (pdf-preview-buffer '(a3 t nil 8 6))
;;
;; 4. variables
;;     1) pdf-preview-ps2pdf-command
;;             command for ps2pdf (transform Postscript to Portable Document Format)
;;             default : "ps2pdf13"
;;   
;;     2) pdf-preview-ps2pdf-paper-size-option
;;             option for paper size of pdf-preview-ps2pdf-command
;;             default : "-sPAPERSIZE="
;;   
;;     3) pdf-preview-preview-command
;;             command for launching pdf viewer
;;             default :
;;                  windows + CMD.EXE --- "start"
;;                  windows + cygwin  --- "cygstart"
;;                  carbon-emacs      --- "open"
;;                  others            --- "xpdf"
;;   
;;     4) pdf-preview-font-rescale-factor
;;             rescale factor of font size defined in ps-print package
;;             default : 1.0
;;   
;;----------------------------------------------------------------------
;;
;; 1. 機能
;;
;;     このパッケージを使う為には、多言語化された、Ghostscript が必要です。
;;     熊本学園大学の、小川先生が提供されている、パッケージなどがお勧めです。
;;         http://www2.kumagaku.ac.jp/teacher/herogw/index.html
;;
;;     1) Emacs の バッファーのテキストを、PostScript format を経由して、
;;        pdf に変換し、適当なビュワーを使って表示します。
;;        Default では、GhostScript (ps2pdf13) を使っています。
;;     2) 日本語フォントとアスキーフォントの幅を 2:1 に設定します。
;;     3) プレフィックス付きで呼び出すと、幾つかの項目を対話的に設定できます。
;;
;; 2. 関数
;;     主な関数は、以下の8個。各々の差は、ps-print(spool系の関数と同じ
;;
;;         pdf-preview-spool-buffer
;;         pdf-preview-spool-buffer-with-faces
;;         pdf-preview-spool-region
;;         pdf-preview-spool-region-with-faces
;;     上記4関数は、interactiveに変数を取得した上、ps-spool-* でPostScript
;;     フォーマットのbuffer(*PostScript)を作成します。
;;
;;         pdf-preview-buffer
;;         pdf-preview-buffer-with-faces
;;         pdf-preview-region
;;         pdf-preview-region-with-faces
;;     上記4関数は、ps-preview-spool-* でspoolした、PostScriptフォーマットに対し、
;;         関数 pdf-preview-rescale-mule-font
;;     を使って、Mule Font のみ 1.2 倍(所謂当幅にする為)した後、
;;         関数 pdf-preview-do-despool
;;     で、pdfファイルを作成します。
;;
;; 3. 使い方
;;
;;     1) M-x pdf-preview-(buffer|region)(-with-faces)
;;         初期設定値で、ps、pdf ファイルが作られます。
;;
;;     2) C-u M-x pdf-preview-(buffer|region)(-with-faces)
;;         下記項目を、対話的に設定できます。
;;                 紙サイズ (ps-paper-type)
;;                     'b5, 'b4, 'a4small, 'ledger, 'lettersmall, 'legal,
;;                     'letter, 'a3, 'a4,
;;                 紙の向き (ps-landscape-mode)
;;                     'Landscape, 'Portrait,
;;                 ヘッダーの有無 (ps-preint-header)
;;                     't, 'nil,
;;                 フォントサイズの拡大比率 (pdf-preview-font-rexcale-factor)
;; 　　                任意の正の数
;;                 行間隔 (ps-line-spacing)
;;                     任意の正の数
;;
;;     3) (pdf-preview-buffer arg-list)
;;         引数付きで関数呼び出し。引数は、上記の5項目を含んだリストである事。
;;         例 ; (pdf-preview-buffer '(a3 t nil 8 10))
;;                 a3、横置きで、ヘッダー無し、フォントサイズは標準の8倍
;;                 行間隔は 10/72 inch
;;
;; 4. 設定可能な変数
;;     1) pdf-preview-ps2pdf-command
;;             ps2pdf に使うコマンド
;;             デフォルト : "ps2pdf13"
;;    
;;             * 私は、cjkps2pdf.pl を使ったりしているので、
;;                 "perl ~/bin/cjkps2pdf.pl --keepmetrics"
;;               にしています。
;;    
;;     2) pdf-preview-ps2pdf-paper-size-option
;;             pdf-preview-ps2pdf-command で、紙サイズの指定に使うオプション
;;             デフォルト : "-sPAPERSIZE="
;;    
;;             * 私は、cjkps2pdf.pl を使ったりしているので、
;;                 "--papersize "
;;               にしています。
;;    
;;     3) pdf-preview-preview-command
;;             プレビュワーを起動するコマンド
;;             デフォルト :
;;                  windows + CMD.EXE --- "start"
;;                  windows + cygwin  --- "cygstart"
;;                  carbon-emacs      --- "open"
;;                  others            --- "xpdf"
;;    
;;     4) pdf-preview-font-rescale-factor
;;             フォントの拡大率
;;             デフォルト : 1.0
;;    
;;             * 私は、1.1 にしてます。
;;    
;; 5. 履歴
;;     1.0.4 2005-10-17 bug fix
;;     1.0.3 2005-05-30 bug fix
;;     1.0.2 2005-05-24 bug fix
;;                      プレビュワーコマンドのデフォルト値をOS毎に設定
;;     1.0.1 2005-05-23 .emacs の設定がなくても動くように変更
;;                      紙サイズA4, 行間隔6をデフォルトに
;;                      行間隔も対話的に設定できるように
;;     1.0.0 2005-05-20 リリース

;;; code

;;;
;;; initialize section
;;;

(if (not (boundp 'ps-paper-type)) (setq ps-paper-type 'a4))
(if (not (boundp 'ps-line-spacing)) (setq ps-line-spacing 6))

(require 'ps-print)
(require 'ps-mule)

(defalias 'ps-mule-header-string-charsets 'ignore)

(defvar pdf-preview-ps2pdf-command "ps2pdf13")

(defvar pdf-preview-ps2pdf-paper-size-option "-sPAPERSIZE=")

(defvar pdf-preview-preview-command
  (cond
   ((featurep 'dos-w32)
    (if (string-match "\\(cmdproxy\.exe$\\|cmd\.exe$\\)" shell-file-name) "start"
      "cygstart"))
   ((featurep 'mac-carbon) "open")
   ("xpdf")))

(defvar pdf-preview-ignored-papersize-list '("tabloid" "statement" "executive"))

(defvar pdf-preview-font-rescale-factor 1.0)

(defvar pdf-preview-ps-mule-search-word
  (concat "/f[89][29]-[0-2] \\([0-9]+\.[0-9][0-9][0-9][0-9][0-9][0-9]\\) /"
          "\\(Ryumin-Light\\|GothicBBB-Medium\\)"
          "\\(-H\\|\\.Katakana\\|\\.Hankaku\\) "
          "\\(DefFontMule\\)"))

(defun pdf-preview-get-paper-size (paper-type)
  (downcase (nth 3 (or (assoc paper-type ps-page-dimensions-database)
                       (assoc ps-paper-type ps-page-dimensions-database)))))

(defvar pdf-preview-papersize-list
  (let ((lst
         (mapcar
          (function (lambda (s) (cons (car s) (pdf-preview-get-paper-size (car s)))))
          ps-page-dimensions-database)))
    (dolist (elt pdf-preview-ignored-papersize-list) (delete (rassoc elt lst) lst))
    lst))

;;;
;;; Function section
;;;

(defun pdf-preview-do-despool (&optional papersize)
  "Preview PostScript spool via PDF"
  (interactive (list (pdf-preview-papersize current-prefix-arg)))
  (let* ((ps-temp-file
          (concat (make-temp-name (concat temporary-file-directory "pdf")) ".ps"))
         (pdf-temp-file
          (concat (file-name-sans-extension ps-temp-file) ".pdf"))
         (paper
          (cdr (assoc (or papersize ps-paper-type) pdf-preview-papersize-list)))
         (ps2pdf-command
          (format "%s %s%s %s %s" pdf-preview-ps2pdf-command
                  pdf-preview-ps2pdf-paper-size-option paper
                  ps-temp-file pdf-temp-file))
         (preview-command
          (format "%s %s" pdf-preview-preview-command pdf-temp-file)))
    (ps-do-despool ps-temp-file)
    (shell-command (concat ps2pdf-command " && " preview-command))))

(defun pdf-preview-rescale-mule-font (&optional arg)
  "Rescale mule fonts for keeping in line with ascii"
  (interactive)
  (save-excursion
    (set-buffer "*PostScript*")
    (goto-char (point-min))
    (while (re-search-forward pdf-preview-ps-mule-search-word nil t)
      (let* ((end (match-end 4))
             (num (buffer-substring (match-beginning 1) (match-end 1)))
             (str (format "%.6f" (* (string-to-number num) 1.2))))
        (goto-char (match-beginning 1))
        (delete-region (match-beginning 1) (match-end 1))
        (insert str)
        (goto-char end)))))

(defun pdf-preview-spool-buffer (&optional arg-list)
  "Generate and spool a PostScript image of the buffer for pdf preview."
  (interactive (pdf-preview-factor current-prefix-arg))
  (pdf-preview-spool 'ps-spool-buffer arg-list))

(defun pdf-preview-buffer (&optional arg-list)
  "Generate and preview a pdf file of the buffer via PostScript."
  (interactive (pdf-preview-factor current-prefix-arg))
  (pdf-preview-spool-buffer arg-list)
  (save-excursion (pdf-preview-rescale-mule-font))
  (pdf-preview-do-despool (car arg-list)))
  
(defun pdf-preview-spool-buffer-with-faces (&optional arg-list)
  "Generate and spool a PostScript image of the buffer with faces for pdf preview."
  (interactive (pdf-preview-factor current-prefix-arg))
  (pdf-preview-spool 'ps-spool-buffer-with-faces arg-list))

(defun pdf-preview-buffer-with-faces (&optional arg-list)
  "Generate and preview a pdf file of the buffer with faces via PostScript."
  (interactive (pdf-preview-factor current-prefix-arg))
  (pdf-preview-spool-buffer-with-faces arg-list)
  (save-excursion (pdf-preview-rescale-mule-font))
  (pdf-preview-do-despool (car arg-list)))
  
(defun pdf-preview-spool-region (from to &optional arg-list)
  "Generate and spool a PostScript image of the region for pdf preview."
  (interactive (pdf-preview-region-factor current-prefix-arg))
  (pdf-preview-spool 'ps-spool-region arg-list from to))

(defun pdf-preview-region (from to &optional arg-list)
  "Generate and preview a pdf file of the region via PostScript."
  (interactive (pdf-preview-region-factor current-prefix-arg))
  (pdf-preview-spool-region from to arg-list)
  (save-excursion (pdf-preview-rescale-mule-font))
  (pdf-preview-do-despool (car arg-list)))
  
(defun pdf-preview-spool-region-with-faces (from to &optional arg-list)
  "Generate and spool a PostScript image of the region with faces for pdf preview."
  (interactive (pdf-preview-region-factor current-prefix-arg))
  (pdf-preview-spool 'ps-spool-region-with-faces arg-list from to))

(defun pdf-preview-region-with-faces (from to &optional arg-list)
  "Generate and preview a pdf file of the region with faces via PostScript."
  (interactive (pdf-preview-region-factor current-prefix-arg))
  (pdf-preview-spool-region-with-faces from to arg-list)
  (save-excursion (pdf-preview-rescale-mule-font))
  (pdf-preview-do-despool (car arg-list)))

(defun pdf-preview-region-factor (prefix-arg)
  (let ((lst (car (pdf-preview-factor prefix-arg))))
    (list (region-beginning) (region-end) lst)))

(defun pdf-preview-papersize (prefix-arg)
  (and prefix-arg
       (or (numberp prefix-arg) (listp prefix-arg))
       (let* ((prompt "Papersize : ")
              (completion-ignore-case t)
              (default (cdr (assoc ps-paper-type pdf-preview-papersize-list)))
              (lst (mapcar (lambda (ls) (cdr ls)) pdf-preview-papersize-list))
              (str (completing-read prompt lst nil t default)))
         (car (rassoc str pdf-preview-papersize-list)))))

(defun pdf-preview-factor (prefix-arg)
  (and prefix-arg
       (or (numberp prefix-arg) (listp prefix-arg))
       (list
        (list
         (pdf-preview-papersize prefix-arg)
         (let* ((prompt (format "Direction : "))
                (completion-ignore-case t)
                (default (if ps-landscape-mode "Landscape" "Portrait"))
                (lst '("Landscape" "Portrait"))
                (str (completing-read prompt lst nil t default)))
           (if (string-match str "Landscape") t nil))
         (let* ((prompt (format "Print Title : "))
                (completion-ignore-case t)
                (default (if ps-print-header "t" "nil"))
                (str (completing-read prompt '("t" "nil") nil t default)))
           (if (string-match str "t") t nil))
         (let ((prompt (format "Font Rescale Factor : "))
               (factor)
               (default (number-to-string pdf-preview-font-rescale-factor)))
           (while (not (numberp (setq factor (read-minibuffer prompt default)))))
           factor)
         (let ((prompt (format "Line Spacing : "))
               (spacing)
               (default (number-to-string ps-line-spacing)))
           (while (not (numberp (setq spacing (read-minibuffer prompt default)))))
           spacing)))))

(defun pdf-preview-mult (cons_cell factor)
  (if (numberp cons_cell) (* cons_cell factor)
    (cons (* factor (car cons_cell)) (* factor (cdr cons_cell)))))

(defun pdf-preview-spool (pdf-preview-spool-function arg-list &optional from to)
  (save-excursion
    (let* ((ps-paper-type (if arg-list (nth 0 arg-list) ps-paper-type))
           (ps-landscape-mode (if arg-list (nth 1 arg-list) ps-landscape-mode))
           (ps-print-header (if arg-list (nth 2 arg-list) ps-print-header))
           (factor (if arg-list (nth 3 arg-list) pdf-preview-font-rescale-factor))
           (ps-line-spacing (if arg-list (nth 4 arg-list) ps-line-spacing))
           (ps-font-size (pdf-preview-mult ps-font-size factor))
           (ps-header-font-size (pdf-preview-mult ps-header-font-size factor))
           (ps-footer-font-size (pdf-preview-mult ps-footer-font-size factor))
           (ps-header-title-font-size
            (pdf-preview-mult ps-header-title-font-size factor))
           (ps-line-number-font-size
            (pdf-preview-mult ps-line-number-font-size factor))
           (ps-multibyte-buffer 'non-latin-printer))
      (if from (funcall pdf-preview-spool-function from to)
        (funcall pdf-preview-spool-function)))))

(provide 'pdf-preview)

;;; pdf-preview.el ends here
