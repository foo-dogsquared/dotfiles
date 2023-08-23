;;; tools/wiki/config.el --- The configuration for foo-dogsquared's wiki as a module.
;;; -*- lexical-binding: t; -*-

;;; Commentary:
;; My custom configuration for setting up my personal wiki.
;; Also a good opportunity for training my Elisp-fu.
(require 'f)

;; Code
(defvar +wiki-directory "~/wiki")

;; New nodes should be considered draft and has to be explicitly removed to be
;; marked as completely. I don't have a good system for revisiting nodes, only
;; relying on good committing practice. Adding good tagging can double that
;; effectiveness (if there's any in the first place).
(add-hook 'org-roam-capture-new-node-hook (lambda ()
                                            org-roam-tag-add '("draft")))

(defun +org-roam-split-to-random-node ()
  "Open a split window sensibly for a random note."
  (interactive)
  (split-window-sensibly)
  (other-window 1)
  (org-roam-node-random))

(when (modulep! +anki)
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
    (map! :map org-mode-map
          :localleader
          :prefix ("C" . "Anki cards")
          :desc "Push all cards in current document" :n "p" #'anki-editor-push-notes
          :desc "Push all cards in cards directory to Anki" :n "P" #'+anki-editor-push-all-notes-to-anki
          :desc "Retry to push failed cards" :n "r" #'anki-editor-retry-failure-notes
          :desc "Insert a card in current document" :n "i" #'anki-editor-insert-note
          :desc "Create a cloze region" :n "I" #'anki-editor-cloze-region
          :desc "Export the subtree as HTML" :n "e" #'anki-editor-export-subtree-to-html
          :desc "Remove all anki-editor-related properties in a card" :n "d" #'+anki-editor-reset-note
          :desc "Remove all properties in all notes" :n "D" #'+anki-editor-reset-all-notes)

    :config
    (setq anki-editor-create-decks 't
          +anki-cards-directory (f-join +wiki-directory +anki-cards-directory-name))))

(when (modulep! +graph)
  (use-package! websocket
    :after org-roam)

  (use-package! org-roam-ui
    :after org-roam
    :hook (org-roam . org-roam-ui-mode)
    :config
    (setq org-roam-ui-sync-theme t
          org-roam-ui-follow t)))

(when (modulep! +krita)
  (use-package! org-krita
    :after org-mode
    :hook (org-mode . org-krita-mode)))
;;; config.el ends here
