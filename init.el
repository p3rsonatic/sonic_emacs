;;SONIC EMACS

;; RESPOSITORIES
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

;; EMACS UI
(fido-vertical-mode -1)
(global-visual-line-mode t) 
(setq display-line-numbers-type 'relative)
(global-display-line-numbers-mode 1)

;; Theme: TARDIS Blue / Deuteranopia dark
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

;; HELP, DISCOVERY AND COMPLETION
(use-package which-key
  :init (which-key-mode)
  :config (setq which-key-idle-delay 0.5))

;; Orderless: Allows "fuzzy" matching (e.g., "func my" matches "my func")
(use-package orderless
  :ensure t
  :custom
  (completion-styles '(orderless basic))
  (completion-category-overrides '((file (styles basic partial-completion)))))

;; Corfu: The popup UI for auto-completion
(use-package corfu
  :ensure t
  :custom
  (corfu-auto t)
  (corfu-auto-delay 0.1) 
  (corfu-auto-prefix 2) 
  (corfu-cycle t)
  (corfu-preselect 'prompt) 
  :init
  (global-corfu-mode 1))

;; Eglot: The built-in LSP client
(use-package eglot
  :ensure t
  :hook
  (prog-mode . eglot-ensure))

;; Cape: Extends completion backends
(use-package cape
  :ensure t
  :init
  (add-to-list 'completion-at-point-functions #'cape-dabbrev)
  (add-to-list 'completion-at-point-functions #'cape-file)
  (add-to-list 'completion-at-point-functions #'cape-elisp-block)
  (add-to-list 'completion-at-point-functions #'cape-keyword)
  :config
  (add-hook 'eglot-managed-mode-hook
            (lambda ()
              (setq-local completion-at-point-functions
                          (list (cape-capf-super
                                 #'eglot-completion-at-point
                                 #'cape-dabbrev
                                 #'cape-keyword))))))

;; VERTICO provides a vertical bar minibuffer for autocompleting commands

(use-package vertico
  :ensure t
  :custom
  (vertico-preselect 'prompt)
  (vertico-cycle t)
  :init
  (vertico-mode 1))

;; Emacs core completion settings
(use-package emacs
  :custom
  (tab-always-indent 'complete))

;; Snippets

(use-package yasnippet
  :config
  (yas-global-mode 1))

;;ORG MODE AND LITERATE PROGRAMMING

(use-package org
  :hook (org-mode . org-display-inline-images)
  :config
  (use-package org-bullets
    :config (add-hook 'org-mode-hook (lambda () (org-bullets-mode 1))))
    
  ;; Babel: Language Support
  (org-babel-do-load-languages
   'org-babel-load-languages
   '((emacs-lisp . t) (python . t) (C . t) (latex . t) (haskell . t))))

;; Literate Programming & Source Block Behavior
(with-eval-after-load 'org
  (require 'org-tempo) ;; Typing "<s" + TAB inserts code blocks
  (setq org-confirm-babel-evaluate nil)
  (setq org-src-fontify-natively t)
  (setq org-src-tab-acts-natively t))


(add-hook 'org-src-mode-hook #'eglot-ensure) 

(setq org-src-preserve-indentation t  
      org-src-tab-acts-natively t
      org-edit-src-content-indentation 0)

;; LATEX SUPPORT 
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
(setq org-latex-compiler "lualatex")

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

;; ORG ROAM 
(use-package org-roam
  :custom
  (org-roam-directory (file-truename "~/Documents/org-notes"))
  (org-roam-dailies-directory "daily/")
  :config
  (org-roam-db-autosync-mode))

;; SET FACES BOILERPLATE

(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

;; TREEMACS AND VTERM

(use-package treemacs
  :ensure t
  :defer t                           
  :commands (treemacs treemacs-toggle)
  :config
  (setq treemacs-width 30
        treemacs-is-never-other-window t
        treemacs-follow-after-init nil))

(use-package vterm
  :ensure t
  :defer t                           
  :commands vterm
  :config
)
