;; -*- no-byte-compile: t; -*-
;;; tools/wiki/packages.el

;; The main package for creating a wiki.
(package! org-roam
  :recipe (:host github :repo "org-roam/org-roam"))

(when (modulep! +biblio)
  (package! org-roam-bibtex
    :recipe (:host github :repo "org-roam/org-roam-bibtex")))

(when (modulep! +anki)
  (package! anki-editor
    :recipe (:host github
             :repo "louietan/anki-editor")
    :pin "546774a453ef4617b1bcb0d1626e415c67cc88df"))

(when (modulep! +markdown)
  (package! md-roam
    :recipe (:host github :repo "nobiot/md-roam" :branch "v2")))

(when (modulep! +graph)
  (package! simple-httpd)
  (package! websocket)
  (package! org-roam-ui
    :recipe (:host github :repo "org-roam/org-roam-ui")))

(when (modulep! +krita)
  (package! org-krita
    :recipe (:host github :repo "lepisma/org-krita" :files ("resources" "*.el"))))
