;;; tools/wiki/config.el --- The configuration for foo-dogsquared's wiki as a module.
;;; -*- lexical-binding: t; -*-

;;; Commentary:
;; My custom configuration for setting up my personal wiki.
;; Also a good opportunity for training my Elisp-fu.
(require 'f)

;; Code
(defvar +wiki-directory "~/wiki")

(defun +org-roam-split-to-random-node ()
  "Open a split window sensibly for a random note."
  ; TODO: Create a window, open a random note, and that's it.
  (interactive)
  (split-window-sensibly)
  (other-window 1)
  (org-roam-node-random))

(use-package! org-roam
  :hook (org-load . org-roam-mode)
  :commands
  (org-roam-buffer
   org-roam-setup
   org-roam-capture
   org-roam-node-find)
  :preface
  (defvar org-roam-directory nil)
  (defvar +wiki-directory nil)
  :init
  (map! :leader
        :after org
        :map org-roam-dailies-map
        (:prefix ("n r" . "org-roam")
                 :desc "Go to a random node" "r" #'org-roam-node-random
                 :desc "Go to a random node and split" "R" #'+org-roam-split-to-random-node
                 :desc "Find node" "f" #'org-roam-node-find
                 :desc "Org Roam capture" "c" #'org-roam-capture
                 :desc "Org Roam setup" "s" #'org-roam-setup
                 :desc "Org Roam teardown" "S" #'org-roam-teardown
                 :desc "Open backlinks buffer" "b" #'org-roam-buffer-toggle

                 (:prefix ("d" . "dailies")
                          :desc "Daily note for today" "t" #'org-roam-dailies-goto-today
                          :desc "Daily note for a specific date" "d" #'org-roam-dailies-goto-date
                          :desc "Daily note for yesterday" "y" #'org-roam-dailies-goto-yesterday
                          :desc "Next daily note" "n" #'org-roam-dailies-goto-next-note
                          :desc "Previous daily note" "N" #'org-roam-dailies-goto-previous-note)))

  :config
  (setq org-roam-completion-everywhere t
        org-roam-directory (file-name-as-directory
                            (file-truename
                             (expand-file-name +wiki-directory
                                               org-directory)))
        org-roam-dailies-directory (f-join +wiki-directory "daily"))
  (org-roam-setup))

(when (featurep! +biblio)
  (defvar +wiki-references-filename "references.bib")
  (defvar +wiki-bibliography-note-filename "references.org")
  (defvar +wiki-bibliography-file (f-join +wiki-directory +wiki-references-filename))
  (defvar +wiki-bibliography-note (f-join +wiki-directory +wiki-bibliography-note-filename))

  (defun +wiki/biblio-setup ()
    "Setup the variables for the wiki config."
    (setq +wiki-bibliography-file (f-join +wiki-directory +wiki-references-filename)
          +wiki-bibliography-note (f-join +wiki-directory +wiki-bibliography-note-filename)
          org-ref-default-bibliography +wiki-bibliography-file
          org-ref-bibliography-notes +wiki-bibliography-note
          bibtex-completion-bibliography +wiki-bibliography-file
          bibtex-completion-notes-path +wiki-directory))

  (use-package! org-roam-bibtex
    :after org-roam
    :preface
    :config
    (require 'org-ref)
    (+wiki/biblio-setup)))

(when (featurep! +anki)
  (defvar +anki-cards-directory-name "cards")
  (defvar +anki-cards-directory (f-join +wiki-directory +anki-cards-directory-name))
  (defun +anki-editor-push-all-notes-to-anki ()
    (interactive)
    (anki-editor-push-notes nil nil (directory-files-recursively +anki-cards-directory "\\.*org" nil)))
  (defun +anki-editor-reset-note ()
    "Reset the Anki note in point by deleting the note ID and the deck."
    (interactive)
    (org-entry-delete (point) anki-editor-prop-note-id)
    (org-entry-delete (point) anki-editor-prop-deck))
  (defun +anki-editor-reset-all-notes ()
    "Reset the Anki notes in the current buffer by deleting the note ID and the deck."
    (interactive)
    (anki-editor-map-note-entries #'+anki-editor-reset-note))

  (use-package! anki-editor
    :hook (org-mode . anki-editor-mode)
    :preface
    (defvar +wiki-directory nil)
    :init
    (map! :localleader
          :map org-mode-map
          (:prefix ("C" . "Anki cards")
           "p" #'anki-editor-push-notes
           "P" #'+anki-editor-push-all-notes-to-anki
           "r" #'anki-editor-retry-failure-notes
           "i" #'anki-editor-insert-note
           "I" #'anki-editor-cloze-region
           "e" #'anki-editor-export-subtree-to-html
           "d" #'+anki-editor-reset-note
           "D" #'+anki-editor-reset-all-notes))
    :config
    (setq anki-editor-create-decks 't
          +anki-cards-directory (f-join +wiki-directory +anki-cards-directory-name))))

(when (featurep! +dendron)
  (use-package! dendroam
    :after org-roam))

(when (featurep! +graph)
  (use-package! websocket
    :after org-roam)

  (use-package! org-roam-ui
    :after org-roam
    :hook (org-roam . org-roam-ui-mode)))

;;; config.el ends here
