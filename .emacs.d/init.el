
;; Added by Package.el.  This must come before configurations of
;; installed packages.  Don't delete this line.  If you don't want it,
;; just comment it out by adding a semicolon to the start of the line.
;; You may delete these explanatory comments.
(package-initialize)

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(ansi-color-faces-vector
   [default default default italic underline success warning error])
 '(browse-url-firefox-program "/opt/FirefoxQuantum/firefox")
 '(custom-enabled-themes (quote (nimbus)))
 '(custom-file nil)
 '(custom-safe-themes
   (quote
    ("c74e83f8aa4c78a121b52146eadb792c9facc5b1f02c917e3dbb454fca931223" "3c83b3676d796422704082049fc38b6966bcad960f896669dfc21a7a37a748fa" "d3a7eea7ebc9a82b42c47e49517f7a1454116487f6907cf2f5c2df4b09b50fc1" "b34636117b62837b3c0c149260dfebe12c5dad3d1177a758bb41c4b15259ed7e" "628278136f88aa1a151bb2d6c8a86bf2b7631fbea5f0f76cba2a0079cd910f7d" "bb08c73af94ee74453c90422485b29e5643b73b05e8de029a6909af6a3fb3f58" "82d2cac368ccdec2fcc7573f24c3f79654b78bf133096f9b40c20d97ec1d8016" "06f0b439b62164c6f8f84fdda32b62fb50b6d00e8b01c2208e55543a6337433a" "53f97243218e8be82ba035ae34c024fd2d2e4de29dc6923e026d5580c77ff702" "a24c5b3c12d147da6cef80938dca1223b7c7f70f2f382b26308eba014dc4833a" "585dca5436f6cda805fbd8c31618a4bd9e741c9e97ad5e06ebd066ce42af21fb" "fd24b2c570dbd976e17a63ba515967600acb7d2f9390793859cb82f6a2d5dacd" "c63a789fa2c6597da31f73d62b8e7fad52c9420784e6ec34701ae8e8f00071f6" "82fce2cada016f736dbcef237780516063a17c2436d1ee7f42e395e38a15793b" default)))
 '(dired-listing-switches "-alh --group-directories-first")
 '(ido-mode (quote both) nil (ido))
 '(image-dired-thumb-height 250)
 '(image-dired-thumb-width 250)
 '(menu-bar-mode nil)
 '(org-agenda-files
   (quote
    ("/home/alejandro/Documents/notes/installed_packages.org" "/home/alejandro/Documents/notes/lisp_notes.org" "/home/alejandro/Documents/notes/org_notes.org" "/home/alejandro/Documents/notes/todo.org")))
 '(org-indent-mode-turns-on-hiding-stars nil)
 '(org-log-done (quote time))
 '(package-selected-packages
   (quote
    (magit company smart-mode-line jazz-theme subatomic-theme color-theme-sanityinc-tomorrow monokai-theme material-theme nimbus-theme gruvbox-theme slime pdf-tools)))
 '(require-final-newline t)
 '(scroll-bar-mode nil)
 '(show-paren-mode t)
 '(tool-bar-mode nil))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(show-paren-match ((t (:inverse-video t)))))

(setq package-archives
      '(("gnu" . "https://elpa.gnu.org/packages/")
	("marmalade" . "https://marmalade-repo.org/packages/")
	("melpa" . "https://melpa.org/packages/")))

(setq dired-deletion-confirmer #'y-or-n-p)

;;;; theme and modeline
(set-face-inverse-video 'show-paren-match t)
(set-face-background 'mode-line "#008787")
(setq sml/theme 'respectful)
(sml/setup)

;;;; General modifications
(add-hook 'prog-mode-hook 'linum-mode)
(add-hook 'prog-mode-hook 'show-paren-mode)
(add-hook 'prog-mode-hook 'electric-pair-mode)
(add-hook 'prog-mode-hook 'company-mode)

(global-set-key [remap dabbrev-expand] 'hippie-expand)
(global-set-key (kbd "C-x C-b") 'ibuffer)
(global-set-key (kbd "C-!") 'shell)

;; Org mode changes
(add-hook 'org-mode-hook 'org-indent-mode)
(global-set-key "\C-ca" 'org-agenda)
(setq org-agenda-files
      '("~/Documents/notes/"))

;; Enable slime (Superior Lisp Interaction Mode) for Common Lisp
(setq inferior-lisp-program "/usr/bin/sbcl")
(setq slime-contribs '(slime-fancy))

