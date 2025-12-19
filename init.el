;;; init.el --- The "TARDIS" Workflow Config

;; --- PACKAGE SETUP ---
(require 'package)
(setq package-archives '(("melpa" . "https://melpa.org/packages/")
                         ("elpa"  . "https://elpa.gnu.org/packages/")
                         ("nongnu" . "https://elpa.nongnu.org/nongnu/")))
(package-initialize)

(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))
(require 'use-package)
(setq use-package-always-ensure t)

;; --- 1. SMOOTH SAILING (Helpers) ---
(use-package which-key
  :init (which-key-mode)
  :config (setq which-key-idle-delay 0.5))

(fido-vertical-mode 1) ;; Better search menus

;; YASNIPPET (The "Missing Piece" for LaTeX/Anki)
;; Allows you to type "eq" + TAB to get an equation block
(use-package yasnippet
  :config
  (yas-global-mode 1))

;; --- 2. VISUALS & DASHBOARD ---
;; (menu-bar-mode -1)
;; (tool-bar-mode -1)
;; (scroll-bar-mode -1)
(load-theme 'modus-vivendi t)

(use-package dashboard
  :config
  (dashboard-setup-startup-hook)
  (setq dashboard-startup-banner (expand-file-name "~/tardis.png"))
  (setq dashboard-image-banner-max-height 300)
  (setq dashboard-center-content t)
  (setq dashboard-items '((recents  . 5)
                          (projects . 5))))

;; --- 3. ORG MODE (The Engine) ---
(use-package org
  :config
  ;; Make headings look nice (bullets instead of asterisks)
  (use-package org-bullets
    :config (add-hook 'org-mode-hook (lambda () (org-bullets-mode 1))))
  
  ;; LaTeX & Math Setup
  (require 'ox-latex)
  (setq org-format-latex-options (plist-put org-format-latex-options :scale 1.5))
  (add-to-list 'org-latex-packages-alist '("" "amsmath" t))
  (add-to-list 'org-latex-packages-alist '("" "amssymb" t))
  
  ;; Code Blocks
  (org-babel-do-load-languages
   'org-babel-load-languages
   '((emacs-lisp . t) (python . t))))

;; --- 4. ORG ROAM (The Brain) ---
(use-package org-roam
  :custom
  (org-roam-directory (file-truename "~/Documents/org-notes"))
  (org-roam-dailies-directory "daily/") ;; Folder for journals
  :config
  (org-roam-db-autosync-mode))

;; --- 5. ANKI (The Memory) ---
(use-package anki-editor)

;; --- 6. COMPLETION & LSP (The HUD) ---

(use-package orderless
  :custom
  (completion-styles '(orderless basic))
  (completion-category-overrides '((file (styles basic partial-completion)))))

(use-package corfu
  ;; Corfu is in GNU ELPA
  :init
  (global-corfu-mode)
  :custom
  (corfu-auto t)
  (corfu-cycle t)
  (corfu-quit-at-boundary 'separator))

;; Cape: Provides extra completion backends (required for better Eglot/Org integration)
(use-package cape
  :init
  (add-to-list 'completion-at-point-functions #'cape-file)
  (add-to-list 'completion-at-point-functions #'cape-dabbrev))

(use-package eglot
  :hook ((python-mode . eglot-ensure)
         (c-mode . eglot-ensure))
  :config
  (add-to-list 'eglot-server-programs '(python-mode . ("basedpyright"))))

;; --- 7. LITERATE PROGRAMMING (Babel & Tangling) ---
(with-eval-after-load 'org
  ;; Easier block insertion: Type "<s" followed by TAB
  (require 'org-tempo) 
  
  (setq org-confirm-babel-evaluate nil) ;; Don't ask for permission to run code
  (setq org-src-fontify-natively t)      ;; Syntax highlighting in blocks
  (setq org-src-tab-acts-natively t))    ;; Use language-specific TAB behavior

;;; init.el ends here
