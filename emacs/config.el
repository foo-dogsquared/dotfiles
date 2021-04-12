;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!


;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets.
(setq user-full-name "Gabriel Arazas"
      user-mail-address "foo.dogsquared@gmail.com")

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
(setq doom-font (font-spec :family "Iosevka" :size 16)
      doom-serif-font (font-spec :family "Source Serif Pro"))

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
(setq doom-theme 'doom-nord)

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq org-directory "~/writings/orgnotes"
      org-roam-directory "~/writings/wiki")

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq global-display-line-numbers-mode t)
(setq display-line-numbers-type 'relative)

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

;; Search the project path with Projectile.
(setq projectile-project-search-path '("~/projects/software/" "~/writings/"))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; CUSTOM PACKAGES CONFIGURATIONS ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; Set the TeX engine to LuaTeX.
(after! tex
  (TeX-engine-set "luatex")
  (add-to-list 'safe-local-variable-values
               '(TeX-command-extra-options . "-shell-escape")))

(after! org
  (setq
   time-stamp-start "date_modified:[ 	]+\\\\?[\"<]+"
   ; Set the capture
   org-capture-templates `(
     ("i" "inbox" entry
      (file ,(concat org-directory "/inbox.org"))
       ,(concat "* TODO %?\n"
         "entered on %<%F %T %:z>"))

     ("p" "project" entry
      (file ,(concat org-directory "/projects.org"))
       ,(concat "* PROJ %?\n"
         "- [ ] %?"))

     ("c" "org-protocol-capture" entry
      (file ,(concat org-directory "/inbox.org"))
       "* TODO [[%:link][%:description]]\n%x"
       :immediate-finish t))

    ; Configure org-roam.
    org-roam-capture-templates '(
      ("n" "notes" plain
       #'org-roam-capture--get-point
       "#+author: \"%(user-full-name)\"
#+email: \"%(user-mail-address)\"
#+date: \"%<%Y-%m-%d %T %:z>\"
#+date_modified: \"%<%Y-%m-%d %T %:z>\"
#+language: en
#+options: toc:t
#+property: header-args  :exports both

%?"
    :file-name "%<%Y-%m-%d-%H-%M-%S>"
    :head "#+title: ${title}\n"
    :unnarrowed t)

    ("d" "dailies" entry
     #'org-roam-capture--get-point
     "* %?"
     :file-name "daily/%<%Y-%m-%d>"
     :head "#+title %<%Y-%m-%d>"
     :olp ("Study notes" "Random")))

  ; Get the tags from vanilla and Roam-specific properties.
  org-roam-tag-sources '(prop vanilla))
  (add-to-list 'org-modules 'org-checklist))

(setq
  ; Modify the time-stamp with each save.
  time-stamp-format "%Y-%02m-%02d %02H:%02M:%02S %:z"

  ; Set file templates folder at $DOOMDIR/templates.
  +file-templates-dir (expand-file-name "templates/" doom-private-dir)

  ; Set the journal.
  org-journal-dir "~/writings/journal"
  org-journal-file-format "%F"
  )

; A workaround for electric-indent plugin.
; See https://github.com/hlissner/doom-emacs/issues/3172 for more details.
(add-hook 'org-mode-hook (lambda () (electric-indent-local-mode -1)))

; Automate updating timestamps on save.
(add-hook 'before-save-hook 'time-stamp)

;;; config.el ends here
