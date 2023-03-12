;;; tools/wiki/doctor.el -*- lexical-binding: t; -*-

(unless (executable-find "sqlite3")
  (warn! "Couldn't find SQLite executable."))

(unless (modulep! :lang org)
  (warn! "Doom module ':lang org' is not enabled. This is a pointless addition to your configuration WTF"))

(when (modulep! :lang org +roam)
  (warn! "org-roam v1 is installed. This module is primarily catered for org-roam v2."))

(when (modulep! +biblio)
  (unless (executable-find "anystyle")
    (warn! "Couldn't find AnyStyle CLI. The PDF scrapper from org-roam-bibtex will not work."))

  (unless (modulep! :tools biblio)
    (warn! "Doom module ':tools biblio' is not enabled. Completion functions will not work.")))
