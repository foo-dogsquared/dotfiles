;;; tools/wiki/config.el --- The configuration for foo-dogsquared's wiki as a module.
;;; -*- lexical-binding: t; -*-

;;; Commentary:
;; My custom configuration for setting up my personal wiki.
;; Also a good opportunity for training my Elisp-fu.
(require 'f)

;; Code
(defvar +wiki-directory "~/Documents/Writings/wiki")
(defvar +wiki-notebook-name "notebook")
(defvar +wiki-notebook-directory (f-join +wiki-directory +wiki-notebook-name))
(defvar +wiki-assets-directory-name "assets")

(defun +wiki-is-in-wiki-directory (&optional filename)
  "Return t if the file buffer is in the wiki directory."
  (unless filename (setq filename (buffer-file-name)))
  (if (and (not (string= (f-base filename)
                         +wiki-asset-directory-name))
           (f-descendant-of-p filename
                              (expand-file-name +wiki-directory)))
      t
    nil))

(defun +wiki-get-assets-folder (&optional filename)
  "Get the assets folder of the current Org mode document."
  (unless filename (setq filename (buffer-file-name)))
  (if (+wiki-is-in-wiki-directory filename)
      (f-join +wiki-asset-directory-name (f-base filename))
    nil))

(defun +wiki-concat-assets-folder (&rest args)
  "Concatenate PATH to the assets folder."
  (apply #'f-join (+wiki-get-assets-folder (buffer-file-name)) args))

(defun +wiki-create-assets-folder (&optional filename)
  "A quick convenient function to create the appropriate folder in the assets
folder with its buffer filename."
  (interactive)
  (unless filename (setq filename (buffer-file-name)))
  (if (+wiki-is-in-wiki-directory)
      (let* ((target (f-base filename))
             (target-dir (f-join +wiki-asset-directory-name target)))
        (apply #'f-mkdir (f-split target-dir))
        (message "Directory '%s' has been created." target-dir))
    (message "Not in the wiki directory.")))

;; Push new custom link types.
(defun +wiki-org-init-custom-links-h ()
  (pushnew! org-link-abbrev-alist
            '("sourcehut" . "https://sr.ht/%s")
            '("brave"     . "https://search.brave.com/search?q=")))

(add-hook! 'org-load-hook
           #'+wiki-org-init-custom-links-h)

(when (modulep! +sensible-config)
  ;; Overriding some of the options. Unfortunately, some of them have to be
  ;; overridden after org-roam has been loaded.
  (with-eval-after-load "org-roam"
    (cl-defmethod org-roam-node-slug :around ((node org-roam-node))
                  (string-replace "_" "-" (cl-call-next-method))))

  (setq org-directory +wiki-directory

        ;; Setting up org-roam.
        org-roam-v2-ack 't
        org-roam-directory +wiki-directory
        org-roam-dailies-directory (f-join org-roam-directory "daily")
        org-roam-db-location (f-join org-roam-directory "org-roam.db")
        org-agenda-files '(,(f-join org-roam-directory "inbox"))

        ;; Setting up the bibliography-related stuff for this notebook.
        citar-bibliography `(,(f-join +wiki-directory "references.bib"))
        citar-notes-paths `(,+wiki-directory)
        citar-library-paths '("~/library/references" "~/Zotero")
        citar-org-roam-capture-template-key "L"

        ;; Set up other org-mode settings that would be beneficial to add to our
        ;; personal wiki.
        org-export-coding-system 'utf-8
        org-id-link-to-org-use-id t
        org-startup-with-inline-images t
        image-use-external-converter t)

  ;; Automate updating timestamps on save.
  (add-hook! 'before-save-hook 'time-stamp))

;; New nodes should be considered draft and has to be explicitly removed to be
;; marked as completely. I don't have a good system for revisiting nodes, only
;; relying on good committing practice. Adding good tagging can double that
;; effectiveness (if there's any in the first place).
(add-hook! 'org-roam-capture-new-node-hook (org-roam-tag-add '("draft")))

(defun +org-roam-split-to-random-node ()
  "Open a split window sensibly for a random note."
  (interactive)
  (split-window-sensibly)
  (other-window 1)
  (org-roam-node-random))

(when (modulep! +anki)
  (defvar +wiki-anki-cards-directory-name "cards")
  (defvar +wiki-anki-cards-directory (f-join +wiki-directory +wiki-anki-cards-directory-name))

  (defun +anki-editor-push-all-notes-to-anki ()

    (interactive)
    (anki-editor-push-notes nil nil (directory-files-recursively +wiki-anki-cards-directory "\\.*org" nil)))

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
          +wiki-anki-cards-directory (f-join +wiki-directory +wiki-anki-cards-directory-name))))

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
