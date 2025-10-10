(menu-bar-mode -1)
(tool-bar-mode -1)
(scroll-bar-mode -1)
(setq inhibit-startup-message t)
(setq-default indent-tabs-mode nil)
(column-number-mode t)
(set-frame-font "JetBrainsMonoNL NF Thin" t t)
(global-display-line-numbers-mode t)
(global-font-lock-mode 0)
(setq scroll-step 1
      scroll-margin 5)

(set-default-coding-systems 'utf-8)
(prefer-coding-system 'utf-8)
(setq make-backup-files nil)
(setq auto-save-default nil)
(delete-selection-mode 1)
(savehist-mode 1)
(custom-set-variables
 '(custom-enabled-themes '(cyberpunk))
 '(custom-safe-themes
   '("e9d47d6d41e42a8313c81995a60b2af6588e9f01a1cf19ca42669a7ffd5c2fde"
     default))
 '(package-selected-packages '(cyberpunk-theme)))
(custom-set-faces)
