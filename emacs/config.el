;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!
(setq user-full-name "Gabriel Arazas"
      user-mail-address "foodogsquared@foodogsquared.one")

(setq doom-font (font-spec :family "Iosevka" :size 18))

(setq doom-theme 'doom-material-dark)

(setq org-directory "~/library/writings/wiki"
      org-id-link-to-org-use-id t
      +file-templates-dir (expand-file-name "templates" doom-private-dir)
      +wiki-directory "~/library/writings/wiki"
      org-export-coding-system 'utf-8

      image-use-external-converter t
      org-startup-with-inline-images t
      org-roam-node-display-template
      (format "${doom-hierarchy:*} %s %s %s"
              (propertize "${doom-type:12}" 'face 'font-lock-keyword-face)
              (propertize "${doom-tags:12}" 'face 'org-tag)
              (propertize "${file:30}" 'face 'font-lock-builtin-face))

      global-display-line-numbers-mode t
      display-line-numbers-type 'relative
      projectile-project-search-path '("~/library/projects/software"
                                       "~/library/projects/packages"
                                       "~/library/writings"
                                       "~/library/projects/learning"))

(add-to-list 'org-modules 'org-habit)
(add-to-list 'org-modules 'org-checklist)

(after! tex
  (TeX-engine-set "luatex")
  (add-to-list 'safe-local-variable-values
               '(TeX-command-extra-options . "-shell-escape")))

(after! org
  (setq
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
                            :immediate-finish t))))

;; Load a custom configuration for muh wiki.
(load-file (f-join +wiki-directory "config.el"))
;;; config.el ends here
