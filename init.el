(menu-bar-mode -1)
(scroll-bar-mode -1)
(tool-bar-mode -1)
(setq inhibit-startup-screen t)
(global-display-line-numbers-mode 1)
(add-hook 'prog-mode-hook 'display-line-numbers-mode)
(setq display-line-numbers-type 'relative)
(setq font-lock-maximum-decoration t)