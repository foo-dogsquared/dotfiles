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
      org-roam-directory "~/writings/wiki"
      org-roam-dailies-directory (f-join org-roam-directory "daily"))

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
                            (file ,(f-join org-directory "inbox.org"))
                            ,(concat "* TODO %?\n"
                                     "entered on %<%F %T %:z>"))

                           ("p" "project" entry
                            (file ,(f-join org-directory "projects.org"))
                            ,(concat "* PROJ %?\n"
                                     "- [ ] %?"))

                           ("c" "org-protocol-capture" entry
                            (file ,(f-join org-directory "inbox.org"))
                            "* TODO [[%:link][%:description]]\n%x"
                            :immediate-finish t))

                                        ; Configure org-roam.
   org-roam-capture-templates `(
                                ("p" "permanent" plain "%?"
                                 :if-new
                                 (file+head "%<%Y-%m-%d-%H-%M-%S>.org"
                                            "#+title: ${title}
#+date: \"%<%Y-%m-%d %T %:z>\"
#+date_modified: \"%<%Y-%m-%d %T %:z>\"
#+language: en")
                                 :unnarrowed t)

                                ("c" "cards" plain "%?"
                                 :if-new
                                 (file+head ,(f-join "cards" "${slug}.org") "#+title: Anki: ${title}
#+date: \"%<%Y-%m-%d %T %:z>\"
#+date_modified: \"%<%Y-%m-%d %T %:z>\"
#+language: en
#+property: anki_deck ${title}")
                                 :unnarrowed t)

                                ("l" "literature" plain "%?"
                                 :if-new
                                 (file+head ,(f-join "literature" "%<%Y-%m-%d-%H-%M-%S>")"#+title: ${title}
#+date: \"%<%Y-%m-%d %T %:z>\"
#+date_modified: \"%<%Y-%m-%d %T %:z>\"
#+language: en")
                                 :unnarrowed t))

   org-roam-dailies-capture-templates `(("d" "default" entry "* %?"
                                         :if-new
                                         (file+head ,(expand-file-name "%<%Y-%m-%d>.org" org-roam-dailies-directory) "#+title: %<%Y-%m-%d>\n")))

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
 org-id-link-to-org-use-id t

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

;; Add a capture hook.
(add-hook! 'org-capture-prepare-finalize-hook 'org-id-get-create)
(add-hook! 'org-roam-capture-new-node-hook 'org-id-get-create)

;;; config.el ends here
