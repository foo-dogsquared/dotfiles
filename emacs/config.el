;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!


;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets.
(setq user-full-name "Gabriel Arazas"
      user-mail-address "foo.dogsquared@gmail.com")

(setq doom-font (font-spec :family "Iosevka" :size 16)
      doom-serif-font (font-spec :family "Source Serif Pro"))

(setq doom-theme 'doom-nord)

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
                                ("p" "permanent" plain
                                 #'org-roam-capture--get-point "%?"
                                 :file-name "%<%Y-%m-%d-%H-%M-%S>"
                                 :head "#+title: ${title}
#+date: \"%<%Y-%m-%d %T %:z>\"
#+date_modified: \"%<%Y-%m-%d %T %:z>\"
#+language: en"
                                 :unnarrowed t)

                                ("c" "cards" plain
                                 #'org-roam-capture--get-point "%?"
                                 :head "#+title: Anki: ${title}
#+date: \"%<%Y-%m-%d %T %:z>\"
#+date_modified: \"%<%Y-%m-%d %T %:z>\"
#+language: en
#+property: anki_deck ${title}"
                                 :file-name "cards/${slug}"
                                 :unnarrowed t)

                                ("l" "literature" plain
                                 #'org-roam-capture--get-point "%?"
                                 :head "#+title: ${title}
#+date: \"%<%Y-%m-%d %T %:z>\"
#+date_modified: \"%<%Y-%m-%d %T %:z>\"
#+language: en"
                                 :file-name "literature/%<%Y-%m-%d-%H-%M-%S>"
                                 :unnarrowed t)

                                ("d" "dailies" entry
                                 #'org-roam-capture--get-point "%?"
                                 :file-name "daily/%<%Y-%m-%d>"
                                 :head "#+title %<%Y-%m-%d>"))

   ;; Get the tags from vanilla and Roam-specific properties.
   org-roam-tag-sources '(prop vanilla))
  (add-to-list 'org-modules 'org-checklist))

;; Custom keybindings
(map!
 (:when (featurep! :editor format)
  :n "g=" #'+format/buffer)

 (:when (featurep! :lang org +roam)
  (:map org-roam-mode-map
   :leader
   :prefix "nr"
   :desc "Find a random Org-roam note" "R" #'org-roam-random-note)))

(setq
 ;; Modify the time-stamp with each save.
 time-stamp-format "%Y-%02m-%02d %02H:%02M:%02S %:z"

 ;; Set file templates folder at $DOOMDIR/templates.
 +file-templates-dir (expand-file-name "templates/" doom-private-dir)

 ;; Set the journal.
 org-journal-dir "~/writings/journal"
 org-journal-file-format "%F"

 enable-local-variables "query"
 )

(defun align-non-space (BEG END)
  "Align non-space columns in region BEG END."
  (interactive "r")
  (align-regexp BEG END "\\(\\s-*\\)\\S-+" 1 1 t))

;; A workaround for electric-indent plugin.
;; See https://github.com/hlissner/doom-emacs/issues/3172 for more details.
(add-hook 'org-mode (lambda ()
                      (electric-indent-local-mode -1)))

;; Automate updating timestamps on save.
(add-hook! 'before-save-hook 'time-stamp)

;; Set up Anki editor
(use-package! anki-editor
  :hook (org-mode . anki-editor-mode)
  :config
  (setq anki-editor-create-decks 't)
  (map! :localleader
        :map org-mode-map
        (:prefix ("C" . "Anki cards")
         "p" #'anki-editor-push-notes
         "r" #'anki-editor-retry-failure-notes
         "i" #'anki-editor-insert-note
         "I" #'anki-editor-cloze-region
         "e" #'anki-editor-export-subtree-to-html)))

;;; config.el ends here
