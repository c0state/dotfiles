; set time, line number and column number in status bar
(display-time)
(line-number-mode t)
(column-number-mode t)

; turn on visible bell
(setq visible-bell t)

; load coloration module
(ansi-color-for-comint-mode-on)

; load color-theme and use 'parus' theme
(add-to-list 'load-path "~/Dropbox/Linux/Config")
(require 'color-theme)
(eval-after-load "color-theme"
  '(progn
     (color-theme-parus)))

; set paren mode to highlight previous expression
(paren-set-mode 'sexp)

(custom-set-variables
 '(case-fold-search t)
 '(current-language-environment "English")
 '(global-font-lock-mode t nil (font-lock))
 '(save-place t nil (saveplace))
 '(show-paren-mode t nil (paren))
 '(transient-mark-mode t)
 '(uniquify-buffer-name-style 'forward))

; set fixed font size of 10 point
(custom-set-faces
 '(default ((t (:size "10pt" :family "Fixed" nil nil)))))

(setq frame-title-format
 '("%S: " (buffer-file-name "%f" (dired-directory dired-directory "%b"))))

(push '("/.*" . binary) process-coding-system-alist)

; load desktop session support
(require 'desktop)

; for python indenting

; turn off file backups
(setq make-backup-files nil)

; set mac os meta key to option key
(setq mac-option-modifier 'meta)
(setq mac-command-modifier 'none)
(set-keyboard-coding-system nil)

;;=============================================================================
;;                    scroll on  mouse wheel
;;=============================================================================

;; scroll on wheel of mouses
(define-key global-map 'button4
	'(lambda (&rest args)
	  (interactive) 
	  (let ((curwin (selected-window)))
	    (select-window (car (mouse-pixel-position)))
	    (scroll-down 5)
	    (select-window curwin)
)))
(define-key global-map [(shift button4)]
	'(lambda (&rest args)
	  (interactive) 
	  (let ((curwin (selected-window)))
	    (select-window (car (mouse-pixel-position)))
	    (scroll-down 1)
	    (select-window curwin)
)))
(define-key global-map [(control button4)]
	'(lambda (&rest args)
	  (interactive) 
	  (let ((curwin (selected-window)))
	    (select-window (car (mouse-pixel-position)))
	    (scroll-down)
	    (select-window curwin)
)))

(define-key global-map 'button5
	'(lambda (&rest args)
	  (interactive) 
	  (let ((curwin (selected-window)))
	    (select-window (car (mouse-pixel-position)))
	    (scroll-up 5)
	    (select-window curwin)
)))
(define-key global-map [(shift button5)]
	'(lambda (&rest args)
	  (interactive) 
	  (let ((curwin (selected-window)))
	    (select-window (car (mouse-pixel-position)))
	    (scroll-up 1)
	    (select-window curwin)
)))
(define-key global-map [(control button5)]
	'(lambda (&rest args)
	  (interactive) 
	  (let ((curwin (selected-window)))
	    (select-window (car (mouse-pixel-position)))
	    (scroll-up)
	    (select-window curwin)
)))

