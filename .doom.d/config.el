;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!


;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets.
(setq user-full-name "Sebastian Claici"
      user-mail-address "sebastianclaici@gmail.com")

;; Doom exposes five (optional) variables for controlling fonts in Doom. Here
;; are the three important ones:
;;
;; + `doom-font'
;; + `doom-variable-pitch-font'
;; + `doom-big-font' -- used for `doom-big-font-mode'; use this for
;;   presentations or streaming.
;;
;; They all accept either a font-spec, font string ("Input Mono-12"), or xlfd
;; font string. You generally only need these two:
(setq doom-font (font-spec :family "Roboto Mono Light" :size 16)
      doom-variable-pitch-font (font-spec :family "EBGaramond" :size 20))

;; increase garbage collection size
(setq gc-cons-threshold 1000000000)

;; org-protocol
(server-start)
(require 'org-protocol)

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
(setq doom-theme 'doom-one-light)

;; Doom modeline display word count in org mode
(setq doom-modeline-major-mode-icon t)
(setq doom-modeline-continuous-word-count-modes '(markdown-mode gfm-mode org-mode))

;; Default dictionary is british
(setq ispell-dictionary "british")

;; Disable mouse focus
(setq focus-follows-mouse nil)
(setq mouse-autoselect-window nil)

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq org-directory "~/org/")

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type 'relative)

;; yasnippet triggers within snippet
(setq yas-triggers-in-field t)

;; auto save at regular intervals
(use-package! super-save
  :config
  (super-save-mode +1))

;; peep-dired key remap
(evil-define-key 'normal peep-dired-mode-map (kbd "<SPC>") 'peep-dired-scroll-page-down
                                             (kbd "C-<SPC>") 'peep-dired-scroll-page-up
                                             (kbd "<backspace>") 'peep-dired-scroll-page-up
                                             (kbd "j") 'peep-dired-next-file
                                             (kbd "k") 'peep-dired-prev-file)
(add-hook 'peep-dired-hook 'evil-normalize-keymaps)

;; Org visual configuration
(after! org
  (add-to-list 'org-modules 'org-habit t)
  (add-to-list 'org-modules 'org-drill t)

  (setq org-indirect-buffer-display 'other-window)
 
  (setq org-file-apps
        '((auto-mode . emacs)
          ("\\.x?html?\\'" . "firefox %s")
          ("\\.pdf\\(::[0-9]+\\)?\\'" . "zathura %s")
          ("\\.gif\\'" . "eog \"%s\"")
          ("\\.png\\'" . "sxiv %s")
          ("\\.jpg\\'" . "sxiv %s")
          ("\\.mp4\\'" . "vlc \"%s\"")
          ("\\.mkv" . "vlc \"%s\"")))

  (setq
   +org-capture-drill-file
   (expand-file-name "drills.org" org-directory)
   +org-capture-habits-file
   (expand-file-name "habits.org" org-directory)
   +org-capture-calendar-file
   (expand-file-name "calendar.org" org-directory))

  ;; Restricted list of agenda files
  (setq org-agenda-files
        (list (concat org-directory "notes.org")
              (concat org-directory "todo.org")
              (concat org-directory "blog/notes.org")
              (concat org-directory "papers/notes.org")
              (concat org-directory "habits.org")
              (concat org-directory "calendar.org")))

  (add-hook! org-mode #'turn-on-auto-fill)
  (add-hook! org-mode
    (setq doom-modeline-enable-word-count t))

  (setq org-startup-folded 'content)
  (setq org-hide-emphasis-markers t)
  (setq org-treat-insert-todo-heading-as-state-change t)
  (setq org-log-into-drawer t))

(after! ox-latex
  (add-to-list 'org-latex-classes
               '("koma-article" "\\documentclass{scrartcl}"
                 ("\\section{%s}" . "\\section*{%s}")
                 ("\\subsection{%s}" . "\\subsection*{%s}")
                 ("\\subsubsection{%s}" . "\\subsubsection*{%s}")
                 ("\\paragraph{%s}" . "\\paragraph*{%s}")
                 ("\\subparagraph{%s}" . "\\subparagraph*{%s}"))))

(after! org
  ;; org capture templates
  (setq
   org-capture-templates
   `(
     ;; Common templates for every day things
     ("t" "Todo" entry (file+headline +org-capture-todo-file "Tasks")
      "* TODO %?\n  %i\n  %a"
      :prepend t)
     ("n" "Notes" entry (file+headline +org-capture-notes-file "Notes")
      "* %?\n %i\n %a"
      :prepend t)
     ("l" "Web Links" entry (file+headline +org-capture-notes-file "Web Links")
      "* TODO '%:description'\n %a\n"
      :prepend t)

     ;; Web links
     ("d" "Drills")
     ("da" "Art" entry
      (file+headline +org-capture-drill-file "Art")
      ,(concat "* Item     :drill:"
               "\n:PROPERTIES:\n:DATE_ADDED: %u\n:END:"
               "\n\n%?\n** Answer\n%i\n"))
     ("dk" "Philosophy" entry
      (file+headline +org-capture-drill-file "Philosophy")
      ,(concat "* Item     :drill:"
               "\n:PROPERTIES:\n:DATE_ADDED: %u\n:END:"
               "\n\n%?\n** Answer\n%i\n"))
     ("dm" "Math" entry
      (file+headline +org-capture-drill-file "Mathematics")
      ,(concat "* Item     :drill:"
               "\n:PROPERTIES:\n:DATE_ADDED: %u\n:END:"
               "\n\n%?\n** Answer\n%i\n"))
     ("dh" "History" entry
      (file+headline +org-capture-drill-file "History")
      ,(concat "* Item     :drill:"
               "\n\n%?\n** Answer\n%i\n"))
     ("ds" "Music" entry
      (file+headline +org-capture-drill-file "Music")
      ,(concat "* Item     :drill:"
               "\n\n%?\n** Answer\n%i\n"))
     ("dw" "Capture web snippet" entry
      (file+headline +org-capture-drill-file "Uncategorised")
      ,(concat "* Fact: '%:description'      :drill:"
               "\n:PROPERTIES:\n:DATE_ADDED: %u\n:SOURCE_URL: %a\n"
               ":DRILL_CARD_TYPE: hide1cloze\n:END:\n\n%i\n%?\n"))

     ("w" "Vocabulary")
     ("wj" "Johnson's Dictionary" entry
      (file+headline +org-capture-drill-file "Johnson's Dictionary")
      ,(concat "* Item     :drill:"
               "\n:PROPERTIES:\n:DATE_ADDED: %u\n:DRILL_CARD_TYPE: twosided\n:END:"
               "\n\nDefine\n** Word\n\n** Definition\n%?\n"))
     ("we" "English" entry
      (file+headline +org-capture-drill-file "English")
      ,(concat "* Item     :drill:"
               "\n:PROPERTIES:\n:DATE_ADDED: %u\n:DRILL_CARD_TYPE: twosided\n:END:"
               "\n\nDefine\n** Word\n\n** Definition\n%?\n"))
     )))

;; async org babel blocks
(require 'ob-async)

;; Deft basic configuration
(use-package! deft
  :config
  (setq deft-extensions '("org"))
  (setq deft-directory org-directory))

;; org2blog configuration
(use-package! org2blog
  :config
  (setq org2blog/wp-blog-alist
        '(("myblog"
           :url "https://sebastianclaici.com/xmlrpc.php"
           :username "sebastianclaici"))
        org2blog/wp-show-post-in-browser 'show))

;; Navigation aids for org-mode
(defun org-advance ()
  (interactive)
  (when (buffer-narrowed-p)
  (beginning-of-buffer)
  (widen)
  (org-forward-heading-same-level 1))
    (org-narrow-to-subtree))

(defun org-retreat ()
  (interactive)
  (when (buffer-narrowed-p)
    (beginning-of-buffer)
    (widen)
   (org-backward-heading-same-level 1))
   (org-narrow-to-subtree))

(map! :map org-mode-map
      "M-]" 'org-advance
      "M-[" 'org-retreat)

;; org bullets
(use-package! org-bullets)

;; org-download screenshot method
(use-package! org-download
  :after org
  :config
  (setq org-download-screenshot-method "scrot -s %s")
  (setq org-download-method 'directory)
  (setq-default org-download-image-dir (concat org-directory "figures/misc")))

;; org-roam simple configuration and bindings
(use-package! org-roam
  :after org
  :init
  (setq org-roam-directory org-directory)
  (setq org-roam-capture-templates
        `(("d" "default" plain (function org-roam--capture-get-point)
           "%?"
           :file-name "%(format-time-string \"%Y-%m-%d--%H-%M-%SZ--${slug}\" (current-time) t)"
           :head ,(concat "#+TITLE: ${title}\n"
                          "#+OPTIONS: toc:t\n"
                          "#+OPTIONS: TeX:t LaTeX:t todo:t\n"
                          "#+LATEX_CLASS: koma-article\n"
                          "#+LATEX_HEADER: \\usepackage{ebgaramond}\n"
                          "#+LaTeX_HEADER: \\usepackage{mathtools}\n"
                          "#+LaTeX_HEADER: \\usepackage{amsmath}\n"
                          "#+LaTeX_HEADER: \\usepackage{amssymb}\n"
                          "#+LaTeX_HEADER: \\usepackage{fullpage}\n"
                          "#+LaTeX_HEADER: \\usepackage{graphicx}\n"
                          "#+LaTeX_HEADER: \\usepackage{natbib}\n"
                          "#+LaTeX_HEADER: \\usepackage{parskip}\n")
           :unnarrowed t)))
  (map! :leader
        (:desc "roam" :prefix ("r" . "roam")
         :desc "find file" "." #'org-roam-find-file
         :desc "backlinks" "r" #'org-roam
         :desc "insert link" "i" #'org-roam-insert))
  :config
  (setq +org-roam-open-buffer-on-find-file nil))

;; configuring org-ref
(use-package! org-ref
  :after org
  :config
  (setq reftex-default-bibliography
        (expand-file-name "references.bib" org-directory)
        org-ref-bibliography-notes
        (expand-file-name "paper-notes.org" org-directory)
        org-ref-default-bibliography
        (list
         (expand-file-name "references.bib" org-directory))))

;; Configure org-roam-bibtex
(use-package org-roam-bibtex
  :after org-roam
  :hook (org-mode . org-roam-bibtex-mode)
  :bind (:map org-mode-map
         (("C-c n a" . orb-note-actions)))
  :config
  (setq orb-preformat-keywords
        '(("citekey" . "=key=") "title" "url" "file" "author-or-editor" "keywords"))

  (setq orb-templates
        '(("r" "ref" plain (function org-roam-capture--get-point)
           ""
           :file-name "${slug}"
           :head
           "#+TITLE: ${citekey}: ${title}\n#+ROAM_KEY: ${ref}
#+AUTHOR: ${author-or-editor}

- tags ::
- keywords :: ${keywords}

* ${title}"))))

(defun formatted-citation-at-point ()
  "Kill the formatted citation for the reference at point using Pandoc."
  (interactive)
  (let* ((bibfile (expand-file-name (car (org-ref-find-bibliography))))
	 (cslfile (concat (file-name-directory bibfile) "chicago-author-date.csl")))
    (kill-new
     (shell-command-to-string
      (format
       "echo cite:%s | pandoc --filter=pandoc-citeproc --bibliography=%s --csl=%s -f org -t markdown_strict | tail -n +3"
       (org-ref-get-bibtex-key-under-cursor)
       bibfile
       cslfile)))))

(map! :leader
      :prefix "m"
      :desc "get formatted citation at point" "c" #'formatted-citation-at-point)

;; org-noter
(use-package! org-noter
  :after org
  :config
  (setq org-noter-auto-save-last-location 't)
  (setq org-noter-doc-split-fraction '(0.6 . 0.4)))

(add-hook 'org-noter-notes-mode-hook
          (lambda ()
            (set-fill-column 60)))

;; org-journal
(use-package! org-journal
  :after org
  :config
  (setq org-journal-file-type 'weekly))

;; org super agenda config
(use-package! org-super-agenda
  :after org
  :init
  (setq org-agenda-skip-scheduled-if-done t
      org-agenda-skip-deadline-if-done t
      org-agenda-include-deadlines t
      org-agenda-compact-blocks nil
      org-agenda-start-day nil ;; i.e. today
      org-agenda-span 1
      org-agenda-start-on-weekday nil)
  (setq org-super-agenda-groups
        '(;; Each group has an implicit boolean OR operator between its selectors.
          (:name "Important"
           ;; Single arguments given alone
           :priority "A"
           :order 1)
          (:name "Bills"
           :tag "banking"
           :order 1)
          (:name "Writing"
           :tag "writing"
           :order 1)
          (:name "Reading"
           :tag "reading"
           :order 2)
          (:name "Blog"
           :tag "blog"
           :order 2)
          (:name "Home"
           :tag "home"
           :order 2)
          (:name "Projects"
           :tag "projects"
           :order 2)
          (:name "Research"
           :tag "research"
           :order 2)
          (:name "Workout"
           :tag "workout"
           :order 2)
          (:name "Personal"
           :tag "personal"
           :order 2)
          (:name "Habits"
           :habit t
           :order 3)
          (:name "Meetings"
           :category "Talks"
           :order 4)
          ;; Set order of multiple groups at once
          ;; Groups supply their own section names when none are given
          (:todo "WAITING" :order 8)  ; Set order of this section
          (:priority<= "B"
           ;; Show this section after "Today" and "Important", because
           ;; their order is unspecified, defaulting to 0. Sections
           ;; are displayed lowest-number-first.
           :order 5)
          (:deadline t
           :order 6)
          ;; After the last group, the agenda will display items that didn't
          ;; match any of these groups, with the default order position of 99
          ))
  :config
  (org-super-agenda-mode))

;; org-books configuration
(setq org-books-file (concat org-directory "books.org"))

;; Writer aids
(setq writeroom-width 80)
(setq writeroom-border-width 80)
(setq writeroom-maximize-window t)

(add-hook 'writeroom-mode-hook
          (lambda ()
            (set-fill-column 120)))
(add-hook 'writeroom-mode-disable-hook
          (lambda ()
            (set-fill-column 80)))

;; disable line-numbers in writeroom mode
(add-hook 'writeroom-mode-hook 'menu-bar--display-line-numbers-mode-none)
(add-hook 'writeroom-mode-disable-hook 'menu-bar--display-line-numbers-mode-relative)

;; Configure org-reveal
(setq org-reveal-root "file:///home/sebii/bin/reveal.js")

;; Configure mathpix.el
(use-package! mathpix
  :init
  (map! :map org-mode-map
        :leader
        :prefix "m"
        :desc "mathpix grab" "a m" #'mathpix-screenshot)
  :config
  (setq mathpix-screenshot-method "scrot -s %s")
  (setq mathpix-app-id "sebastianclaici_gmail_com_4ea397"
        mathpix-app-key "ec17fadc20cc4b8697b8"))

;; Configure hledger-mode
(use-package! hledger-mode
  :init
  (map! :leader
        :prefix ("l" . "ledger")
        :desc "new entry" "e" #'hledger-jentry
        :desc "run command" "c" #'hledger-run-command)
  :config
  (setq hledger-currency-string "$")
  (add-to-list 'auto-mode-alist '("\\.journal\\'" . hledger-mode))
  (add-to-list 'company-backends 'hledger-company))

;; c++ hooks
(defun my-c++-mode-after-save-hook ()
  (when (eq major-mode 'c++-mode)
    #'lsp-format-buffer))

(add-hook 'after-save-hook #'my-c++-mode-after-save-hook)

(defun my-c++-mode-hook ()
  (setq-local indent-region-function #'lsp-format-region)
  (setq lsp-enable-on-type-formatting 't))
(add-hook 'c++-mode-hook 'my-c++-mode-hook)

;; lsp configuration
(map! :leader
      :prefix "c"
      :desc "UI imenu" "I" #'lsp-ui-imenu)

(setq lsp-enable-links nil)

;; Hotkeys
;; comment/uncomment region shortcut
(map! :desc "commen/uncomment region" "C-/" #'comment-or-uncomment-region)

;; Here are some additional functions/macros that could help you configure Doom:
;;
;; - `load!' for loading external *.el files relative to this one
;; - `use-package' for configuring packages
;; - `after!' for running code after a package has loaded
;; - `add-load-path!' for adding directories to the `load-path', relative to
;;   this file. Emacs searches the `load-path' when you load packages with
;;   `require' or `use-package'.
;; - `map!' for binding new keys
;;
;; To get information about any of these functions/macros, move the cursor over
;; the highlighted symbol at press 'K' (non-evil users must press 'C-c g k').
;; This will open documentation for it, including demos of how they are used.
;;
;; You can also try 'gd' (or 'C-c g d') to jump to their definition and see how
;; they are implemented.
