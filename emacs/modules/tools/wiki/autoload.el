;;; tools/wiki/autoload.el -*- lexical-binding: t; -*-

;;;autoload
(when (versionp! emacs-version >= "29")
  (use-package! emacsql-sqlite-builtin)
  (setq org-roam-database-connector 'sqlite-builtin))
