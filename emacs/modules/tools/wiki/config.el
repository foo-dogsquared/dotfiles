;;; tools/wiki/config.el -*- lexical-binding: t; -*-

;; My custom configuration for setting up my personal wiki.
;; Also a good opportunity for training my Elisp-fu.

(use-package! org-roam
  :hook (org-load . org-roam-mode)
  :commands
  (org-roam-buffer
   org-roam-setup
   org-roam-capture
   org-roam-node-find)
  :preface (defvar org-roam-directory nil)
  :config
  (setq org-roam-completion-everywhere t)
  (org-roam-setup)
  (map! :leader
        (:prefix ("n r" . "org-roam")
         :desc "Go to a random node in your Roam database" "R" #'org-roam-node-random
         :desc "Find node" "f" #'org-roam-node-find
         :desc "Org Roam capture" "c" #'org-roam-capture
         :desc "Org Roam setup" "s" #'org-roam-setup
         :desc "Org Roam teardown" "S" #'org-roam-teardown
         :desc "Open backlinks buffer" "b" #'org-roam-buffer-toggle

         (:prefix ("d" . "dailies")
          :desc "Dailies for today" "t" #'org-roam-dailies-find-today
          :desc "Dailies for a specific date" "d" #'org-roam-dailies-find-date
          :desc "Dailies for yesterday" "y" #'org-roam-dailies-find-yesterday))))

(use-package! anki-editor
  :hook (org-mode . anki-editor-mode)
  :config
  (setq anki-editor-create-decks 't)
  (map! :localleader
        :map org-mode-map
        (:prefix ("C" . "Anki cards")
         "p" #'anki-editor-push-notes
         "r" #'anki-editor-retry-failure-notes
         "i" #'anki-editor-insert-note
         "I" #'anki-editor-cloze-region
         "e" #'anki-editor-export-subtree-to-html)))
