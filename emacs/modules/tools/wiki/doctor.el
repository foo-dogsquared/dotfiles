;; -*- lexical-binding: t; no-byte-compile: t; -*-
;;; tools/wiki/doctor.el

(unless (executable-find "sqlite3")
  warn! "Couldn't find SQLite executable. org-roam will not work.")
