;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!
(setq user-full-name "Gabriel Arazas"
      user-mail-address "foo.dogsquared@gmail.com")

(setq doom-font (font-spec :family "Iosevka" :size 16)
      doom-serif-font (font-spec :family "Source Serif Pro"))

(setq doom-theme 'doom-nord)

(setq org-directory "~/writings/orgnotes"
      org-roam-directory "~/writings/wiki"
      org-roam-dailies-directory (f-join org-roam-directory "daily"))

(setq global-display-line-numbers-mode t)
(setq display-line-numbers-type 'relative)
(setq projectile-project-search-path '("~/projects/software/" "~/writings/"))

(setq
 time-stamp-format "%Y-%02m-%02d %02H:%02M:%02S %:z"
 org-id-link-to-org-use-id t

 +file-templates-dir (expand-file-name "templates" doom-private-dir)
 +wiki-directory "~/writings/wiki"

 org-journal-dir "~/writings/journal"
 org-journal-file-format "%F"

 enable-local-variables "query")

(defvar my/wiki-asset-directory-name "assets")

(defun align-non-space (BEG END)
  "Align non-space columns in region BEG END."
  (interactive "r")
  (align-regexp BEG END "\\(\\s-*\\)\\S-+" 1 1 t))

(defun my/create-assets-folder ()
  "A quick convenient function to create an assets folder in the wiki folder."
  (interactive)
  (if (and (not (string= (f-base (buffer-file-name))
                         my/wiki-asset-directory-name))
           (f-descendant-of-p (buffer-file-name)
                              (expand-file-name +wiki-directory)))
      (f-mkdir my/wiki-asset-directory-name
               (f-join my/wiki-asset-directory-name (file-name-sans-extension (buffer-file-name))))
    (message "Not in the wiki directory.")))

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
 (:when (featurep! :tools wiki)
  :leader
  :prefix "nr"
  :desc "Create the asset folder" "m" #'my/create-assets-folder)

 (:when (featurep! :editor format)
  :n "g=" #'+format/buffer))

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
