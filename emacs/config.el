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

;;(use-package! ewal
;;    :init (setq ewal-json-file "~/.cache/wal/colors.json"
;;                ewal-use-built-in-always-p nil
;;                ewal-use-built-in-on-failure-p nil
;;                ewal-built-in-palette "sexy-material")
;;
;;    ;; This loading of theme is required in order for ewal to work.
;;    ;; See jjzmajic/ewal Issue #11 (https://gitlab.com/jjzmajic/ewal/-/issues/11).
;;    :init (load-theme 'doom-fds t))
