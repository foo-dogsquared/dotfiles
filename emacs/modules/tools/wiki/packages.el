;; -*- no-byte-compile: t; -*-
;;; tools/wiki

;; The main package for creating a wiki.
(package! org-roam
  :recipe (:host github :repo "org-roam/org-roam" :branch "v2"))

(when (featurep! +anki)
  (package! anki-editor
    :recipe (:host github
             :repo "louietan/anki-editor")
    :pin "546774a453ef4617b1bcb0d1626e415c67cc88df"))

;;(when (featurep! +markdown)
;;  (package! md-roam
;;    :recipe (:host github :repo "nobiot/md-roam" :branch "v2")))
;;
;;(when (featurep! +dendron)
;;  (package! dendroam
;;    :recipe (:host github :repo "vicrdguez/dendroam")))