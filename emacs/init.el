;;; init.el -*

;; This file controls what Doom modules are enabled and what order they load in.
;; Remember to run 'doom sync' after modifying it!

;; NOTE Press 'SPC h d h' (or 'C-h d h' for non-vim users) to access Doom's
;;      documentation. There you'll find information about all of Doom's modules
;;      and what flags they support.

;; NOTE Move your cursor over a module's name (or its flags) and press 'K' (or
;;      'C-c g k' for non-vim users) to view its documentation. This works on
;;      flags as well (those symbols that start with a plus).
;;
;;      Alternatively, press 'gd' (or 'C-c g d') on a module to browse its
;;      directory (for easy access to its source code).

(doom! :input
       chinese
       japanese

       :completion
       (company +childframe)
       (vertico +icons)

       :ui
       doom
       doom-dashboard
       doom-quit
       hl-todo
       indent-guides
       modeline
       ophints
       (popup +defaults)
       (ligatures +extra)
       unicode
       vc-gutter
       vi-tilde-fringe
       workspaces

       :editor
       (evil +everywhere)
       file-templates
       fold
       format
       lispy
       snippets
       word-wrap

       :emacs
       (dired +ranger)
       electric
       undo
       vc

       :term
       vterm

       :checkers
       syntax

       :tools
       biblio
       (debugger +lsp)
       direnv
       editorconfig
       (eval +overlay)
       (lookup
            +dictionary
            +offline)
       lsp
       magit
       pdf
       rgb
       upload

       :lang
       (cc +lsp)
       clojure
       common-lisp
       data
       (dart +flutter)
       emacs-lisp
       ess
       (gdscript +lsp)
       (latex +latexmk)
       lua
       markdown
       nix
       (org +gnuplot
         +dragndrop
         +hugo
         +journal
         +noter
         +pandoc
         +present
         +pretty
         +roam2)
       raku
       (python +lsp
               +pyright
               +cython)
       racket
       (ruby +rails)
       (rust +lsp)
       scheme
       sh
       web

       :config
       (default +bindings +smartparens)

       ;; My custom modules should be placed here.
       :tools
       (wiki +anki
             +biblio
             +graph))
