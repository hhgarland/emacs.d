;; -*- lexical-binding: t; eval: (local-set-key (kbd "C-c i") #'consult-outline); outline-regexp: ";;;"; -*-

;;; startup
(setq gc-cons-threshold (* 100 1000 1000))
(add-hook 'emacs-startup-hook
	  #'(lambda ()
	      (message "Startup in %s sec with %d garbage collections"
		       (emacs-init-time "%.2f")
		       gcs-done)))

(require 'server)
(unless (server-running-p)
  (server-start))

;;; package repositories
(require 'package)
(setq package-enable-at-startup nil)
(setq package-archives '(("gnu"   . "http://elpa.gnu.org/packages/")
			 ("melpa" . "http://melpa.org/packages/")
			 ("org"   . "http://orgmode.org/elpa/")))
(package-initialize)

;;; use-package setup
;; bootstrap `use-package'
(unless (package-installed-p 'use-package)
  (package-install 'use-package))

(setq use-package-verbose t)
(setq use-package-always-ensure t)

(require 'use-package)

(use-package auto-compile
  :config (auto-compile-on-load-mode))
(setq load-prefer-newer t)

;;; display options
(tool-bar-mode -1)
(menu-bar-mode -1)
(toggle-scroll-bar -1)
(display-time-mode 1)
(setq inhibit-startup-message t)

;;; general editing
(show-paren-mode)

;;; font settings
(set-language-environment "UTF-8")
(set-default-coding-systems 'utf-8-unix)
(set-frame-font "JetBrains Mono-14")

;;; keep emacs custom-settings in separate file
(setq custom-file (expand-file-name "custom.el" user-emacs-directory))
(load custom-file)

;;; evil settings
(use-package evil
  :ensure t
  :init
  (setq evil-want-keybinding nil)
  :config
  (evil-mode 1))

(use-package evil-collection
  :ensure t
  :config
  (evil-collection-init
   (list 'magit 'dired 'buffer)))

(use-package evil-surround
  :ensure t
  :config
  (global-evil-surround-mode 1))

;;; modus themes
(use-package modus-themes
  :ensure t
  :config
  (load-theme 'modus-vivendi-deuteranopia t))

;;; lsp settings
(use-package lsp-mode
  :init
  ;; set prefix for lsp-command-keymap (few alternatives - "C-l", "C-c l")
  (setq lsp-keymap-prefix "C-c l")
  :hook (;; replace XXX-mode with concrete major-mode(e. g. python-mode)
         (XXX-mode . lsp)
         ;; if you want which-key integration
         (lsp-mode . lsp-enable-which-key-integration))
  :commands lsp)

;; lsp-ui
(use-package lsp-ui :commands lsp-ui-mode)

;; pyright
(use-package lsp-pyright
  :ensure t
  :hook (python-mode . (lambda ()
                          (require 'lsp-pyright)
                          (lsp))))  ; or lsp-deferred

;; which-key
(use-package which-key
    :config
    (which-key-mode))

;;; completion
;; company
(use-package company
  :ensure t
  :config
  (global-company-mode))

;; vertico
(use-package vertico
  :ensure t
  :config
  (vertico-mode 1))

;; marginalia
(use-package marginalia
  :ensure t
  :config
  (marginalia-mode 1))

;; orderless
(use-package orderless
  :ensure t
  :config
  (setq completion-styles '(orderless basic)
	read-buffer-completion-ignore-case t
	completion-category-defaults nil
	completion-category-overrides '((file (styles partial-completion)))))

;; consult
(use-package consult
  :ensure t)

;;; git
;; git gutter
(use-package git-gutter+
  :ensure t
  :init (global-git-gutter+-mode))

;; magit
(use-package magit
  :ensure t
  :bind (("C-x g" . magit-status)))

;;; other packages
;; markdown mode
(use-package markdown-mode
  :ensure t
  :commands (markdown-mode gfm-mode)
  :mode (("README\\.md\\'" . gfm-mode)
         ("\\.md\\'" . markdown-mode)
         ("\\.markdown\\'" . markdown-mode))
  :init (setq markdown-command "multimarkdown"))

;; rainbow mode
(use-package rainbow-mode
  :ensure t)

;; rainbow delimiters
(use-package rainbow-delimiters
  :ensure t
  :init
  (progn
    (add-hook 'prog-mode-hook 'rainbow-delimiters-mode)))

;; smartparens
(use-package smartparens
  :ensure t
  :diminish smartparens-mode
  :config
  (progn
    (require 'smartparens-config)
    (smartparens-global-mode 1)))

;; diminish
(use-package diminish
  :ensure t)

;; centered window mode
(use-package centered-window
  :ensure t)
