;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Emacs Initialization File (init.el)
;; A programming-focused configuration without LSP, focused on universal tools.
;;
;; This configuration uses use-package to manage packages, enabling features
;; like fuzzy finding (Vertico/Consult), fast searching (Ripgrep),
;; and integrated code checking (Flycheck).
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; -----------------------------------------------------------------------------
;; 1. Package Management Setup
;; -----------------------------------------------------------------------------

(require 'package)

;; Add MELPA repository to access popular community packages
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/"))

;; Initialize packages and install use-package if missing
(package-initialize)
(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))

(require 'use-package)

;; Ensure all packages specified with use-package are installed
(setq use-package-always-ensure t)


;; -----------------------------------------------------------------------------
;; 2. Basic Configuration & UI Tweaks
;; -----------------------------------------------------------------------------

;; Disable GUI elements for a cleaner, terminal-friendly look
(menu-bar-mode -1)
(tool-bar-mode -1)
(scroll-bar-mode -1)

;; Make startup faster by disabling initial messages
(setq inhibit-startup-message t)

;; Use spaces instead of tabs for indentation
(setq-default indent-tabs-mode nil)

;; Show column number in the mode line
(column-number-mode t)

;; Set the default font (change "Monospace" to a font you have installed, like "Fira Code" or "Inter")
;; (set-frame-font "JetBrainsMono Nerd Font" t t)

;; Enable line numbers globally
(global-display-line-numbers-mode t)

;; Set a slightly higher threshold for scrolling
(setq scroll-step 1
      scroll-margin 5)


;; -----------------------------------------------------------------------------
;; 3. Core Completion & Fuzzy Finding (Vertico, Consult, Embark)
;; This setup provides the powerful fuzzy file/buffer finding features you requested.
;; -----------------------------------------------------------------------------

;; VERTICO: Minibuffer completion UI. Turns the standard completion into a vertical list.
(use-package vertico
  :init
  (vertico-mode)
  ;; Use 'flex' for fuzzy matching across all completion categories
  (setq completion-styles '(flex)
        completion-category-defaults nil
        completion-category-overrides '((file (styles basic partial-path)))))

;; MARGINALIA: Annotate completion candidates (e.g., showing file sizes, function names)
(use-package marginalia
  :after vertico
  :init
  (marginalia-mode))

;; CONSULT: Collection of search and navigation commands (the core fuzzy engine)
(use-package consult
  :bind (;; Fuzzy find files (project or directory scope)
         ;; ("C-x C-f" . consult-find)
         ;; Fuzzy switch buffers
         ("C-x b" . consult-buffer)
         ;; Live grep using ripgrep (consult-ripgrep)
         ("C-c r g" . consult-ripgrep)
         ;; Jump to function/heading in current buffer (New feature)
         ("C-c i" . consult-imenu)
         ;; Fuzzy search Emacs commands (M-x)
         ;; ("M-x" . consult-apropos)
         ;; Jump to line/word in current buffer
         ("C-s" . consult-line))
  :config
  ;; Customize consult-ripgrep command for optimal results (uses 'rg')
  (setq consult-ripgrep-command
        "rg --ignore-case --type-not git --null --line-number --with-filename --no-heading --color always --colors 'match:fg:black' -e %(grep-regexp) %S")
  )

;; EMBARK: Action menus for things (e.g., running commands on a selected file/buffer)
(use-package embark
  :bind (("C-." . embark-act)         ; Universal action key
         ("C-;" . embark-dwim))       ; Context-aware action
  :config
  (setq prefix-help-command #'embark-prefix-help-command)
  )


;; -----------------------------------------------------------------------------
;; 4. Code Checking (Linting/Compiling)
;; Provides code checking and a good compile output experience.
;; -----------------------------------------------------------------------------

;; FLYCHECK: Modern on-the-fly syntax checking (linting)
(use-package flycheck
  :init
  (global-flycheck-mode)
  :config
  ;; Run flycheck when the buffer is saved
  (setq flycheck-check-syntax-automatically '(mode-enabled save)))

;; COMPILATION: Improve compiler output experience and navigation
(use-package compile
  :config
  ;; Hook for `compilation-mode` to make error navigation easier
  (add-hook 'compilation-mode-hook 'compilation-minor-mode)
  (add-hook 'compilation-mode-hook 'next-error-follow-minor-mode)
  
  ;; Define a convenient function to run 'make' in the project root
  (defun my-compile-project ()
    "Run the default 'compile' command, set to 'make'."
    (interactive)
    (compile "make"))
  
  ;; Bind a quick compile key
  (global-set-key (kbd "C-c C-c") 'my-compile-project)
  
  ;; Use M-g n and M-g p to navigate errors (next-error, previous-error)
  (global-set-key (kbd "M-g n") 'next-error)
  (global-set-key (kbd "M-g p") 'previous-error)
  )


;; -----------------------------------------------------------------------------
;; 5. Git Integration (Magit)
;; -----------------------------------------------------------------------------

;; MAGIT: The glorious Git interface
(use-package magit
  :bind (("C-x g" . magit-status))
  :config
  (setq magit-display-buffer-function 'magit-display-buffer-same-window-except-diff-v1)
  )

;; -----------------------------------------------------------------------------
;; 6. General Programming Modes & Quality of Life
;; -----------------------------------------------------------------------------

;; WHICH-KEY: Show available keybindings after a prefix key is pressed
(use-package which-key
  :init
  (which-key-mode))

;; RAINBOW-DELIMITERS: Colorize nested parentheses, brackets, and braces (New feature)
(use-package rainbow-delimiters
  :hook (prog-mode . rainbow-delimiters-mode)) ; Enable in all programming modes

;; Imenu is the default Emacs feature for navigation (used by consult-imenu)
(add-hook 'prog-mode-hook #'imenu-add-menubar-index)

;; Add hook to all programming modes to enable basic features
(add-hook 'prog-mode-hook #'show-paren-mode) ; Highlight matching parentheses
(add-hook 'prog-mode-hook #'electric-pair-mode) ; Auto-insert closing parentheses/quotes

;; Always end the file with a newline
(setq require-final-newline t)

;; Save session history
(savehist-mode 1)


;; -----------------------------------------------------------------------------
;; 7. Mode Line Enhancements
;; -----------------------------------------------------------------------------

;; DOOM-MODELINE: A clean, informative, and fast modeline
(use-package doom-modeline
  :init
  (doom-modeline-mode 1)
  :config
  ;; Customize the look and feel
  (setq doom-modeline-height 1) ; Adjust height to be compact
  ;; Show only the file name (not the full path) to save space
  (setq doom-modeline-buffer-file-name-style 'truncate-nil)
  ;; Disable icons for the major mode for a cleaner look
  (setq doom-modeline-major-mode-icon nil)
  )
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages nil))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

(set-default-coding-systems 'utf-8)
(prefer-coding-system 'utf-8)
(global-whitespace-mode 1)

(use-package gruvbox-theme
:ensure t
:config
(load-theme 'gruvbox-dark-soft t))
(setq make-backup-files nil) ;; Disable backup files
(setq auto-save-default nil) ;; Disable autosave files
