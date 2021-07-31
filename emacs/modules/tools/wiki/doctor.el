;;; tools/wiki/doctor.el -*- lexical-binding: t; -*-

(unless (executable-find "sqlite3")
  (warn! "Couldn't find SQLite executable."))

(when (featurep! +biblio)
  (unless (executable-find "anystyle")
    (warn! "Couldn't find AnyStyle CLI. The PDF scrapper from org-roam-bibtex will not work."))

  (unless (featurep! :tools biblio)
    (warn! "Doom module ':tools biblio' is not enabled. Completion functions will not work.")))
