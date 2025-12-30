;;; init.el --- The "TARDIS" Workflow Config ;;;

;; ==========================================
;; 1. PACKAGE SYSTEM & REPOS
;; ==========================================

(require 'package)
(setq package-archives '(("melpa" . "https://melpa.org/packages/")
                         ("elpa"  . "https://elpa.gnu.org/packages/")
                         ("nongnu" . "https://elpa.nongnu.org/nongnu/")))
(package-initialize)

;; Bootstrap 'use-package'
(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))
(require 'use-package)
(setq use-package-always-ensure t)

;; ==========================================
;; 2. INTERFACE & VISUALS
;; ==========================================

;; Core Emacs UI behavior
(fido-vertical-mode 1)      ;; Better search menus for M-x and files
(global-visual-line-mode t) ;; Soft-wrap lines instead of cutting them off
(setq display-line-numbers-type 'relative) ;; Relative line numbering for faster jumping
(global-display-line-numbers-mode 1)

;; Theme: TARDIS Blue / Deuteranopia friendly
(use-package ef-themes
  :ensure t
  :config
  (load-theme 'ef-deuteranopia-dark t))

;; Startup Dashboard
(use-package dashboard
  :config
  (dashboard-setup-startup-hook)
  (setq dashboard-startup-banner (expand-file-name "~/tardis.png"))
  (setq dashboard-image-banner-max-height 300)
  (setq dashboard-center-content t)
  (setq dashboard-items '((recents  . 5)
                          (projects . 5))))

;; Help and discovery
(use-package which-key
  :init (which-key-mode)
  :config (setq which-key-idle-delay 0.5))

;; ==========================================
;; 3. COMPLETION STACK (The HUD)
;; ==========================================

;; Orderless: Allows "fuzzy" matching (e.g., "func my" matches "my_func")
(use-package orderless
  :custom
  (completion-styles '(orderless basic))
  (completion-category-overrides '((file (styles basic partial-completion)))))

;; Corfu: The popup UI for auto-completion
(use-package corfu
  :ensure t
  :custom
  (corfu-auto t)                 ;; Enable auto-completion
  (corfu-auto-delay 0.1)         ;; 0.1 seconds delay (as requested)
  (corfu-auto-prefix 2)          ;; 2 characters to trigger
  (corfu-cycle t)                ;; Enable cycling through candidates
  :init
  (global-corfu-mode))

;; Eglot: The built-in LSP client
(use-package eglot
  :ensure t
  :hook
  ;; Ensures eglot starts in any programming mode if a server is found
  (prog-mode . eglot-ensure))

;; Cape: Extends completion backends
(use-package cape
  :ensure t
  :init
  ;; Global fallbacks (dabbrev, files, keywords)
  (add-to-list 'completion-at-point-functions #'cape-dabbrev)
  (add-to-list 'completion-at-point-functions #'cape-file)
  (add-to-list 'completion-at-point-functions #'cape-elisp-block)
  (add-to-list 'completion-at-point-functions #'cape-keyword)
  :config
  ;; Merge LSP results with dabbrev/keywords in one list when Eglot is active
  (add-hook 'eglot-managed-mode-hook
            (lambda ()
              (setq-local completion-at-point-functions
                          (list (cape-capf-super
                                 #'eglot-completion-at-point
                                 #'cape-dabbrev
                                 #'cape-keyword))))))

;; Emacs core completion settings
(use-package emacs
  :custom
  (tab-always-indent 'complete)) ;; Tab first indents, then completes

;; ==========================================
;; 4. WRITING TOOLS (Snippets & Anki)
;; ==========================================

(use-package yasnippet
  :config
  (yas-global-mode 1))

(use-package anki-editor)

;; ==========================================
;; 5. ORG MODE & LITERATE PROGRAMMING
;; ==========================================

(use-package org
  :config
  ;; Visual Bullets
  (use-package org-bullets
    :config (add-hook 'org-mode-hook (lambda () (org-bullets-mode 1))))
    
  ;; Babel: Language Support
  (org-babel-do-load-languages
   'org-babel-load-languages
   '((emacs-lisp . t) (python . t))))

;; Literate Programming & Source Block Behavior
(with-eval-after-load 'org
  (require 'org-tempo) ;; Typing "<s" + TAB inserts code blocks
  (setq org-confirm-babel-evaluate nil) ;; No prompts to run code
  (setq org-src-fontify-natively t)      ;; Syntax highlighting in blocks
  (setq org-src-tab-acts-natively t))   ;; Lang-specific TAB behavior

;; IMPORTANT: Literacy Programming LSP Support
;; This forces Eglot to activate when you use C-c ' to edit a source block
(add-hook 'org-src-mode-hook #'eglot-ensure) 

(setq org-src-preserve-indentation t  ;; Keeps code formatting clean
      org-src-tab-acts-natively t     ;; Allows Tab to work like the real mode
      org-edit-src-content-indentation 0)

;; ==========================================
;; 6. LaTeX EXPORT CONFIGURATION
;; ==========================================
;; Add these to the beginning of the document:
;; #+TITLE: Your Title
;; #+AUTHOR: PBS
;; #+DATE: 2026
;; #+LATEX_CLASS: custom-book
;;
;; If you want to add native LaTeX you can for example do \newpage, but you can also do something like:
;;#+BEGIN_EXPORT latex
;;\begin{multicols}{2}
;;#+END_EXPORT

(require 'ox-latex)
(setq org-latex-compiler "xelatex")

;; Adjust Preview Scale
(setq org-format-latex-options (plist-put org-format-latex-options :scale 1.5))

;; Define the Custom Class
(add-to-list 'org-latex-classes
             '("custom-book"
               "\\documentclass{book}
\\usepackage{multicol}
\\usepackage{float}
\\usepackage{fontspec} % Required for XeLaTeX font selection
\\usepackage{graphicx}
\\usepackage{color}
\\usepackage[a4paper, total={8in, 10in}]{geometry}
\\usepackage{lmodern} % necessary for small font
\\usepackage{fix-cm} % necessary for small font
\\usepackage{enumitem} % removes whitespaces between lists and others
\\usepackage{parskip} %removes whitespaces between lines
\\usepackage{blindtext} % allows clearing double pages (I think)
[DEFAULT-PACKAGES]
[PACKAGES]
[EXTRA]
\\graphicspath{{images/}}
\\let\\cleardoublepage=\\clearpage"
               ("\\part{%s}" . "\\part*{%s}")
               ("\\chapter{%s}" . "\\chapter*{%s}")
               ("\\section{%s}" . "\\section*{%s}")
               ("\\subsection{%s}" . "\\subsection*{%s}")
               ("\\subsubsection{%s}" . "\\subsubsection*{%s}")))
  


;; ==========================================
;; 7. ORG ROAM (The Brain)
;; ==========================================

(use-package org-roam
  :custom
  (org-roam-directory (file-truename "~/Documents/org-notes"))
  (org-roam-dailies-directory "daily/")
  :config
  (org-roam-db-autosync-mode))

;; ==========================================
;; 8. SYSTEM GENERATED SETTINGS
;; ==========================================

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(org-babel-load-languages
   '((emacs-lisp . t) (python . t) (C . t) (latex . t) (haskell . t)))
 '(package-selected-packages nil))

(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

;;; init.el ends here
