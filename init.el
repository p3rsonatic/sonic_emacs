;;; init.el --- The "TARDIS" Workflow Config

;; --- PACKAGE SETUP ---
(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)
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
(menu-bar-mode -1)
(tool-bar-mode -1)
(scroll-bar-mode -1)
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

;;; init.el ends here
