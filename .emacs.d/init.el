; set time, line number and column number in status bar
(display-time)
(line-number-mode t)
(column-number-mode t)

; turn on visible bell
(setq visible-bell t)

; load coloration module
(ansi-color-for-comint-mode-on)

; load color-theme and use specified theme
(add-to-list 'load-path "~/Dropbox/Linux/Config/.emacs.d/packages")
(require 'color-theme)
(eval-after-load "color-theme"
  '(progn
     (color-theme-parus)))

; turn off file backups
(setq make-backup-files nil)

; set mac os meta key to option key
(setq mac-option-key-is-meta nil)
(setq mac-command-key-is-meta t)
(setq mac-command-modifier 'meta)
(setq mac-option-modifier nil)

(set-keyboard-coding-system nil)

(setq custom-file "~/.emacs.d/custom.el")
(load custom-file)

; use ctrl-<arrow> to move between buffers
(global-set-key (kbd "C-x <up>") 'windmove-up)
(global-set-key (kbd "C-x <down>") 'windmove-down)
(global-set-key (kbd "C-x <right>") 'windmove-right)
(global-set-key (kbd "C-x <left>") 'windmove-left)

; cycle through buffers with ctrl-tab
(global-set-key (kbd "<C-tab>") 'bury-buffer)

; rebind ctrl-w to kill backward word
; (ctrl-x|ctrl-c), ctrl-k will now be used for kill region
(global-set-key "\C-w" 'backward-kill-word)
(global-set-key "\C-x\C-k" 'kill-region)

; remove toolbar
(if (fboundp 'tool-bar-mode) (tool-bar-mode -1))

; set right scrollbar instead of the default left
(set-scroll-bar-mode 'right)

; set indent to 4 spaces for python
(setq-default py-indent-offset 4)
