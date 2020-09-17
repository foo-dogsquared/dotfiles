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
(setq org-directory "~/writings/orgnotes")

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
    ; Set the journal.
    org-journal-dir "~/writings/journal"
    org-journal-file-format "%F"

    org-capture-templates `(
      ("i" "inbox" entry (file ,(concat org-directory "/inbox.org"))
        ,(concat "* TODO %?\n"
          "entered on %<%F %T %:z>"))

      ("c" "org-protocol-capture" entry (file ,(concat org-directory "/inbox.org"))
        "* TODO [[%:link][%:description]]\n%x"
        :immediate-finish t))

    ; Set a custom time-stamp pattern.
    ; Even though, it's not recommended, most of the time, it is mainly for personal documents so it is safe.
    time-stamp-start "DATE_MODIFIED:[ 	]+\\\\?[\"<]+"

    ; Configure org-roam.
    org-roam-directory "~/writings/wiki"
    org-roam-capture-templates '(
      ("d" "default" plain (function org-roam--capture-get-point)
       "#+AUTHOR: \"%(user-full-name)\"
#+EMAIL: \"%(user-mail-address)\"
#+DATE: \"%<%Y-%m-%d %T %:z>\"
#+DATE_MODIFIED: \"%<%Y-%m-%d %T %:z>\"
#+LANGUAGE: en
#+OPTIONS: toc:t
#+PROPERTY: header-args  :exports both

%?"
       :file-name "%<%Y-%m-%d-%H-%M-%S>"
       :head "#+TITLE: ${title}\n"
       :unnarrowed t))))

(setq
  ; Modify the time-stamp with each save.
  time-stamp-format "%Y-%02m-%02d %02H:%02M:%02S %:z"

  ; Set file templates folder at $DOOMDIR/templates.
  +file-templates-dir (expand-file-name "templates/" doom-private-dir))

; Automate updating timestamps.
(add-hook 'before-save-hook 'time-stamp)

; Activate minimap for all program-based modes (e.g., web-mode, python-mode) and text-based modes (e.g., org-mode, markdown-mode).
(after! minimap
  (setq minimap-major-modes '(prog-mode text-mode org-mode)))

; Org-roam-bibtex is somehow a horrible name.
; I guess that's why they insist on calling it ORB.
(use-package! org-roam-bibtex
  :after-call org-mode
  :hook (org-roam-mode . org-roam-bibtex-mode))
