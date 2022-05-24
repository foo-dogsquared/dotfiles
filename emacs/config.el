;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!
(setq user-full-name "Gabriel Arazas"
      user-mail-address "foo.dogsquared@gmail.com")

(setq doom-font (font-spec :family "Iosevka" :size 16))

(setq doom-theme 'doom-material-dark)

(setq org-directory "~/library/writings/wiki"
      org-roam-directory "~/library/writings/wiki"
      org-roam-db-location (f-join org-roam-directory "org-roam.db")
      org-agenda-files '("~/library/writings/wiki/inbox")
      org-roam-dailies-directory (f-join org-roam-directory "daily")
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
      projectile-project-search-path '("~/library/projects/software" "~/library/writings" "~/library/projects/learning"))

(add-to-list 'org-modules 'org-habit)
(add-to-list 'org-modules 'org-checklist)

(defvar my/wiki-asset-directory-name "assets")
(defvar my/wiki-exercises-directory "challenges")

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


;; Custom keybindings
(map!
 (:when (featurep! :tools wiki)
  :leader
  :prefix "nr" :desc "Create the asset folder" "m" #'my/create-assets-folder)

 (:when (featurep! :editor format)
  :n "g=" #'+format/buffer))

;; A workaround for electric-indent plugin.
;; See https://github.com/hlissner/doom-emacs/issues/3172 for more details.
(add-hook 'org-mode (lambda ()
                      (electric-indent-local-mode -1)))

;; Automate updating timestamps on save.
(add-hook! 'before-save-hook 'time-stamp)

;; Load a custom configuration for muh wiki.
(add-hook! 'counsel-projectile-mode-hook (lambda ()
                                                    (message (file-name-directory (buffer-file-name)))))
(load-file (f-join +wiki-directory "config.el"))

;;; config.el ends here
