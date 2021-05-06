;;; tools/wiki/config.el -*- lexical-binding: t; -*-

;; My custom configuration for setting up my personal wiki.
;; Also a good opportunity for training my Elisp-fu.
(require 'f)

(defvar +anki-cards-directory nil
  "The location of the Anki cards")

(defvar +structured-notes-directory nil
  "The path of the structured notes used for the Dendron-like features.
The structured notes are considered separate to the org-roam notes.
Though, both notes are integrated in the mindset that org-roam is an extension of
the structured notes needed to create atmoic notes.")

(defun +anki-editor-reset-note ()
  "Reset the Anki note in point by deleting the note ID and the deck."
  (interactive)
  (org-entry-delete (point) anki-editor-prop-note-id)
  (org-entry-delete (point) anki-editor-prop-deck))

(defun +anki-editor-reset-all-notes ()
  "Reset the Anki notes in the current buffer by deleting the note ID and the deck."
  (interactive)
  (anki-editor-map-note-entries #'+anki-editor-reset-note))

(use-package! org-roam
  :hook (org-load . org-roam-mode)
  :commands
  (org-roam-buffer
   org-roam-setup
   org-roam-capture
   org-roam-node-find)
  :preface (defvar org-roam-directory nil)
  :init
  (map! :leader
        :after org
        :map org-roam-dailies-map
        (:prefix ("n r" . "org-roam")
                 :desc "Go to a random node" "R" #'org-roam-node-random
                 :desc "Find node" "f" #'org-roam-node-find
                 :desc "Org Roam capture" "c" #'org-roam-capture
                 :desc "Org Roam setup" "s" #'org-roam-setup
                 :desc "Org Roam teardown" "S" #'org-roam-teardown
                 :desc "Open backlinks buffer" "b" #'org-roam-buffer-toggle

                 (:prefix ("d" . "dailies")
                          :desc "Daily note for today" "t" #'org-roam-dailies-find-today
                          :desc "Daily note for a specific date" "d" #'org-roam-dailies-find-date
                          :desc "Daily note for yesterday" "y" #'org-roam-dailies-find-yesterday
                          :desc "Previous daily note" "Y" #'org-roam-dailies-find-previous-note)))

  :config
  (setq org-roam-completion-everywhere t
        org-roam-directory (file-name-as-directory
                             (file-truename
                               (expand-file-name (or org-roam-directory "roam")
                                                 org-directory)))
        org-roam-dailies-directory (f-join org-roam-directory "daily"))
  (org-roam-setup))

(use-package! anki-editor
  :hook (org-mode . anki-editor-mode)
  :config
  (setq anki-editor-create-decks 't
        +anki-cards-directory (f-join org-roam-directory "cards"))
  (map! :localleader
        :map org-mode-map
        (:prefix ("C" . "Anki cards")
         "p" #'anki-editor-push-notes
         "r" #'anki-editor-retry-failure-notes
         "i" #'anki-editor-insert-note
         "I" #'anki-editor-cloze-region
         "e" #'anki-editor-export-subtree-to-html
         "d" #'+anki-editor-reset-note
         "D" #'+anki-editor-reset-all-notes)))

(use-package! dendroam
  :after org-roam
  :config
  (setq +structured-notes-directory (f-join org-roam-directory "structured")))
