;;; -*- Mode: Lisp; Package: EDITOR -*-
;;;
;;; This file is part of xyzzy.
;;;

(provide "app-menu")

(in-package "editor")

(export '(*app-menu* *app-popup-menu* *menu-history-max*
	  *app-rectangle-popup-menu* *clipboard-char-encoding-popup-menu*
	  *dictionary-popup-menu* *paste-rectangle-popup-menu*
	  *command-bar-popup-menu*
	  make-char-encoding-popup-menu
	  add-file-history-to-menu *menu-display-length*
	  *init-app-menus-hook*))

(defvar *app-menu* nil)
(defvar *app-popup-menu* nil)
(defvar *app-rectangle-popup-menu* nil)
(defvar *clipboard-char-encoding-popup-menu* nil)
(defvar *dictionary-popup-menu* nil)
(defvar *paste-rectangle-popup-menu* nil)
(defvar *command-bar-popup-menu* nil)

(defvar *recent-file-popup-menu* nil)
(defvar *recent-session-popup-menu* nil)

(defvar *menu-history-max* 9)

(defvar *init-app-menus-hook* nil)

(defun init-app-menus ()

  (setq *clipboard-char-encoding-popup-menu*
	(make-char-encoding-popup-menu
	 #'(lambda (encoding)
	     (interactive)
	     (continue-pre-selection)
	     (setq *clipboard-char-encoding* encoding))
	 #'(lambda (encoding)
	     (and (eq *clipboard-char-encoding* encoding) :check))
	 *clipboard-char-encoding-list*))

  (setq *dictionary-popup-menu*
	(define-popup-menu ':dictionary-popup
	  (:item :tag-command "?a?p(&J)"
	   'lookup-j2e-dictionary-selection)
	  (:item :tag-command "?ǂ?(&R)"
	   'lookup-reading-dictionary-selection)
	  (:item :tag-command "?p?a(&E)"
	   'lookup-e2j-dictionary-selection)
	  (:item :tag-command "?n??(&I)"
	   'lookup-idiom-dictionary-selection)
	  (:sep :above-edict-mode)
	  (:item :tag-command "???????????[?h(&D)"
	   'edict-mode
	   #'(lambda () (if edict-mode :check)))))

  (setq *paste-rectangle-popup-menu*
	(define-popup-menu ':paste-rectangle-popup
	  (:item :tag-command "?}??(&I)"
	   'yank-rectangle
	   #'(lambda () (unless *rectangle-kill-buffer* :disable)))
	  (:item :tag-command "?㏑??(&O)"
	   'overwrite-rectangle
	   #'(lambda () (unless *rectangle-kill-buffer* :disable)))
	  (:item :tag-command "?s???֒ǉ?(&A)"
	   'append-rectangle
	   #'(lambda () (unless *rectangle-kill-buffer* :disable)))
	  (:item :tag-command "???????ɂ??đ}??(&R)"
	   'yank-rectangle-as-region
	   #'(lambda () (unless *rectangle-kill-buffer* :disable)))))

  (setq *app-popup-menu*
	(define-popup-menu
	  (:item :tag-command "?؂?????(&T)"
	   'kill-selection-to-clipboard :modify-any-selection)
	  (:item :tag-command "?R?s?[(&C)"
	   'copy-selection-to-clipboard :any-selection)
	  (:item :tag-command "?\???t??(&P)"
	   'paste-from-clipboard :clipboard)
	  (:item :tag-command "?\???t?? - ???`(&G)"
	   'paste-rectangle-from-clipboard :clipboard)
	  (:menu nil "?N???b?v?{?[?h?G???R?[?f?B???O(&E)"
	   *clipboard-char-encoding-popup-menu*)
	  (:item :tag-command "?폜(&D)"
	   'delete-selection :modify-any-selection)
	  (:item :tag-command "?S?Ă??I??(&A)"
	   'selection-whole-buffer)
	  (:sep :above-dictionary-popup-menu)
	  (:menu nil "????(&I)"
	   *dictionary-popup-menu*)
	  (:menu nil "???`?\???t??(&R)"
	   *paste-rectangle-popup-menu*)))

  (setq *app-rectangle-popup-menu*
	(define-popup-menu
	  (:item :tag-command "?؂?????(&T)"
	   'kill-rectangle-selection :modify-rectangle)
	  (:item :tag-command "?R?s?[(&C)"
	   'copy-rectangle-selection :rectangle)
	  (:menu nil "?\???t??(&P)"
	   *paste-rectangle-popup-menu*)
	  (:item :tag-command "?폜(&D)"
	   'delete-rectangle-selection :modify-rectangle)
	  (:item :tag-command "?N???A(&R)"
	   'clear-rectangle-selection :modify-rectangle)
	  (:item :tag-command "?󔒂??}??(&O)"
	   'open-rectangle-selection :modify-rectangle)
	  (:item :tag-command "???????Œu??????(&S)"
	   'string-rectangle-selection :modify-rectangle)))

  (or *command-bar-popup-menu*
      (setq *command-bar-popup-menu* (create-popup-menu ':command-bar-popup)))

  (or *recent-file-popup-menu*
      (setq *recent-file-popup-menu* (create-popup-menu ':recent-file-popup)))
  (or *recent-session-popup-menu*
      (setq *recent-session-popup-menu* (create-popup-menu ':recent-session-popup)))

  (setq *app-menu*
	(define-menu
	  (:popup 'file "?t?@?C??(&F)"
	   (:item :tag-command "?V?K?쐬(&N)"
	    'new-file)
	   (:item :tag-command "?J??(&O)..."
	    'open-file-dialog)
	   (:item :tag-command "????(&C)"
	    'close-selected-buffer
	    #'(lambda ()
		(if (= (count-buffers) 1) :disable)))
	   (:item :tag-command "?㏑???ۑ?(&S)"
	    'save-buffer-dialog :modified)
	   (:item :tag-command "???O???t???ĕۑ?(&A)..."
	    'save-as-dialog)
	   (:item :tag-command "?t?@?C???̑}??(&I)..."
	    'insert-file-dialog)
	   (:item :tag-command "???O?̕ύX(&R)..."
	    'rename-dialog)
	   (:item :tag-command "?S?ĕۑ?(&V)"
	    'save-all-buffers)
	   (:sep :above-session)
	   (:item :tag-command "?Z?b?V???????J??(&D)..."
	    'open-session-dialog)
	   (:item :tag-command "?Z?b?V?????̕ۑ?(&W)..."
	    'save-session-dialog)
	   (:item :tag-command "?Z?b?V?????̎????ۑ?(&T)"
	    'toggle-session-auto-save
	    'update-session-auto-save-ui)
	   (:item :tag-command "?Z?b?V??????????(&Y)"
	    'close-session-dialog)
	   (:sep :above-print)
	   (:item :tag-command "????(&P)..."
	    'print-selected-buffer-dialog)
	   (:sep :above-recent)
	   (:menu nil "?ŋߎg?????t?@?C??(&F)"
	    *recent-file-popup-menu*)
	   (:menu nil "?ŋߎg?????Z?b?V????(&L)"
	    *recent-session-popup-menu*)
	   (:sep :above-kill-xyzzy)
	   (:item :tag-command "?ۑ????ďI??(&E)"
	    'save-all-buffers-kill-xyzzy)
	   (:item :tag-command "?I??(&X)"
	    'kill-xyzzy))
	  (:popup 'edit "?ҏW(&E)"
	   (:item :tag-command "???ɖ߂?(&U)"
	    'undo :undo)
	   (:item :tag-command "?????ς茳?ɖ߂??Ȃ?(&R)"
	    'redo :redo)
	   (:sep :above-selection)
	   (:item :tag-command "?؂?????(&T)"
	    'kill-selection-to-clipboard :modify-any-selection)
	   (:item :tag-command "?R?s?[(&C)"
	    'copy-selection-to-clipboard :any-selection)
	   (:item :tag-command "?\???t??(&P)"
	    'paste-from-clipboard :clipboard)
	   (:item :tag-command "?\???t?? - ???`(&G)"
	    'paste-rectangle-from-clipboard :clipboard)
	   (:menu nil "?N???b?v?{?[?h?G???R?[?f?B???O(&E)"
	    *clipboard-char-encoding-popup-menu*)
	   (:item :tag-command "?폜(&L)"
	    'delete-selection :modify-any-selection)
	   (:item :tag-command "?S?Ă??I??(&S)"
	    'selection-whole-buffer)
	   (:sep :above-rectangle)
	   (:menu nil "???`(&N)"
	    *app-rectangle-popup-menu*)
	   (:popup :convert-popup "?ϊ?(&V)"
	    (:item :tag-command "?啶??(&U)"
	     'upcase-selection :selection)
	    (:item :tag-command "??????(&L)"
	     'downcase-selection :selection)
	    (:item :tag-command "?P???̐擪???啶??(&C)"
	     'capitalize-selection :selection)
	    (:sep :above-space-tab)
	    (:item :tag-command "?X?y?[?X -> ?^?u(&T)"
	     'tabify-selection :selection)
	    (:item :tag-command "?^?u -> ?X?y?[?X(&S)"
	     'untabify-selection :selection)
	    (:sep :above-full->half)
	    (:popup :full->half-popup "?S?p -> ???p(&H)"
	     (:item :tag-command "???ׂ?(&A)"
	      'map-all-to-half-width-selection :selection)
	     (:item :tag-command "?p???E?Ђ炪?ȁE?J?^?J?i(&S)"
	      'map-to-half-width-selection :selection)
	     (:item :tag-command "?p???E?Ђ炪??(&R)"
	      'map-ascii-and-hiragana-to-half-width-selection :selection)
	     (:item :tag-command "?p???E?J?^?J?i(&T)"
	      'map-ascii-and-katakana-to-half-width-selection :selection)
	     (:item :tag-command "?p??(&N)"
	      'map-ascii-to-half-width-selection :selection)
	     (:item :tag-command "?Ђ炪??(&H)"
	      'map-hiragana-to-half-width-selection :selection)
	     (:item :tag-command "?J?^?J?i(&K)"
	      'map-katakana-to-half-width-selection :selection)
	     (:item :tag-command "?M???V?A????(&G)"
	      'map-greek-to-half-width-selection :selection)
	     (:item :tag-command "?L????????(&C)"
	      'map-cyrillic-to-half-width-selection :selection))
	    (:popup :half->full-popup "???p -> ?S?p(&Z)"
	     (:item :tag-command "???ׂ?(?? -> ?Ђ炪??)(&A)"
	      'map-all-to-full-width-hiragana-selection :selection)
	     (:item :tag-command "???ׂ?(?? -> ?J?^?J?i)(&L)"
	      'map-all-to-full-width-katakana-selection :selection)
	     (:item :tag-command "?p???E??(?? -> ?Ђ炪??)(&R)"
	      'map-to-full-width-hiragana-selection :selection)
	     (:item :tag-command "?p???E??(?? -> ?J?^?J?i)(&T)"
	      'map-to-full-width-katakana-selection :selection)
	     (:item :tag-command "?p??(&N)"
	      'map-ascii-to-full-width-selection :selection)
	     (:item :tag-command "?? -> ?Ђ炪??(&H)"
	      'map-kana-to-full-width-hiragana-selection :selection)
	     (:item :tag-command "?? -> ?J?^?J?i(&K)"
	      'map-kana-to-full-width-katakana-selection :selection)
	     (:item :tag-command "?M???V?A????(&G)"
	      'map-greek-to-full-width-selection :selection)
	     (:item :tag-command "?L????????(&C)"
	      'map-cyrillic-to-full-width-selection :selection))
	    (:popup :char-encoding-popup "?????R?[?h(&K)"
	     (:item :tag-command "????????(&A)"
	      'map-char-encoding-selection :selection)
	     (:item :tag-command "JIS????(&J)"
	      'map-jis-selection :selection)
	     (:item :tag-command "EUC????(&E)"
	      'map-euc-selection :selection)))
	   (:popup :paragraph-popup "?i??(&H)"
	    (:item :tag-command "?O?̒i??(&B)"
	     'backward-paragraph)
	    (:item :tag-command "???̒i??(&F)"
	     'forward-paragraph)
	    (:item :tag-command "?I??(&S)"
	     'selection-paragraph)
	    (:item :tag-command "?폜(&L)"
	     'kill-paragraph)
	    (:item :tag-command "?????ւ?(&T)"
	     'transpose-paragraphs)
	    (:item :tag-command "?l?ߍ???(&I)"
	     'fill-paragraph))
	   (:sep :above-not-modified)
	   (:item :tag-command "?ύX?}?[?N??????(&M)"
	    'not-modified :modified)
	   (:item :tag-command "?ŏ????????蒼??(&O)"
	    'revert-buffer))
	  (:popup 'search "????(&S)"
	   (:item :tag-command "????(&F)..."
	    'search-dialog)
	   (:item :tag-command "????????(&N)"
	    'repeat-forward-search
	    #'(lambda () (or *last-search-p* :disable)))
	   (:item :tag-command "?O??????(&P)"
	    'repeat-backward-search
	    #'(lambda () (or *last-search-p* :disable)))
	   (:item :tag-command "?u??(&R)..."
	    'replace-dialog)
	   (:item :tag-command "???v???镶?????𐔂???(&C)..."
	    'count-matches-dialog)
	   (:sep :above-first-error)
	   (:item :tag-command "?ŏ??̃^?O(&I)"
	    'first-error)
	   (:item :tag-command "???̃^?O(&E)"
	    'next-error)
	   (:sep :above-goto-line)
	   (:item :tag-command "?w???s(&J)..."
	    'goto-line-dialog)
	   (:item :tag-command "?t?@?C???̐擪(&T)"
	    'beginning-of-buffer)
	   (:item :tag-command "?t?@?C???̍Ō?(&B)"
	    'end-of-buffer)
	   (:item :tag-command "?}?[?N(&M)..."
	    'mark-dialog-box)
	   (:item :tag-command "?֐??̐擪(&D)"
	    'beginning-of-defun)
	   (:item :tag-command "?֐??̍Ō?(&U)"
	    'end-of-defun)
	   (:sep :above-gresreg)
	   (:item :tag-command "Gresreg(&S)..."
	    'gresreg-dialog)
	   (:item :tag-command "Grep(&G)..."
	    'grep-dialog))
	  (:popup 'view "?\??(&V)"
	   (:item :tag-command "?܂??Ԃ??Ȃ?(&N)"
	    'set-buffer-fold-type-none
	    'set-buffer-fold-type-none-update)
	   (:item :tag-command "?w???ʒu?Ő܂??Ԃ?(&C)"
	    'set-buffer-fold-type-column
	    'set-buffer-fold-type-column-update)
	   (:item :tag-command "?E?B???h?E???Ő܂??Ԃ?(&W)"
	    'set-buffer-fold-type-window
	    'set-buffer-fold-type-window-update)
	   (:sep :above-command-bar)
	   (:menu nil "?c?[???o?[(&Q)" *command-bar-popup-menu*)
	   (:sep :above-font-size)
	   (:popup nil "?????̃T?C?Y(&X)"
	    (:item :tag-command "???????傫??(&I)"
	     'increase-text-font-size)
	    (:item :tag-command "????????????(&O)"
	     'decrease-text-font-size)
	    (:sep :above-set-text-font-x-large)
	    (:item :tag-command "?ő?(&G)"
	     #'(lambda () (interactive) (set-text-font-size :x-large))
	     #'(lambda () (if (eq (get-ascii-text-font-size) :x-large) :check)))
	    (:item :tag-command "??(&L)"
	     #'(lambda () (interactive) (set-text-font-size :large))
	     #'(lambda () (if (eq (get-ascii-text-font-size) :large) :check)))
	    (:item :tag-command "??(&M)"
	     #'(lambda () (interactive) (set-text-font-size :medium))
	     #'(lambda () (if (eq (get-ascii-text-font-size) :medium) :check)))
	    (:item :tag-command "??(&S)"
	     #'(lambda () (interactive) (set-text-font-size :small))
	     #'(lambda () (if (eq (get-ascii-text-font-size) :small) :check)))
	    (:item :tag-command "?ŏ?(&A)"
	     #'(lambda () (interactive) (set-text-font-size :x-small))
	     #'(lambda () (if (eq (get-ascii-text-font-size) :x-small) :check))))
	   (:sep :above-frame)
	   (:item :tag-command "?V?????t???[??(&F)"
	    'new-pseudo-frame 'new-pseudo-frame-menu-update)
	   (:item :tag-command "???݂̃t???[????????(&D)"
	    'delete-pseudo-frame 'pseudo-frame-menu-update)
	   (:item :tag-command "???̃t???[??(&T)"
	    'other-pseudo-frame 'pseudo-frame-menu-update)
	   (:item :tag-command "?O?̃t???[??(&R)"
	    'previous-pseudo-frame 'pseudo-frame-menu-update))
	  (:popup 'window "?E?B???h?E(&W)"
	   (:item :tag-command "???ɕ???(&S)"
	    'split-window 'split-window-menu-update)
	   (:item :tag-command "?c?ɕ???(&V)"
	    'split-window-vertically 'split-window-menu-update)
	   (:item :tag-command "???̃E?B???h?E??????(&O)"
	    'delete-other-windows 'close-window-menu-update)
	   (:item :tag-command "???݂̃E?B???h?E??????(&C)"
	    'delete-window 'close-window-menu-update)
	   (:item :tag-command "???̃E?B???h?E(&N)"
	    'other-window 'move-window-menu-update)
	   (:item :tag-command "?O?̃E?B???h?E(&P)"
	    'move-previous-window 'move-window-menu-update)
	   (:sep :above-next-xyzzy)
	   (:item :tag-command "????xyzzy(&X)"
	    'next-xyzzy-window
	    #'(lambda () (if (< (count-xyzzy-instance) 2) :disable)))
	   (:item :tag-command "?O??xyzzy(&Y)"
	    'previous-xyzzy-window
	    #'(lambda () (if (< (count-xyzzy-instance) 2) :disable)))
	   (:item :tag-command "xyzzy?I??(&Z)..."
	    'select-xyzzy
	    #'(lambda () (if (< (count-xyzzy-instance) 2) :disable)))
	   (:sep :above-select-buffer)
	   (:item :tag-command "?o?b?t?@?I??(&B)..."
	    'select-buffer))

	  (:popup 'tools "?c?[??(&T)"
	   (:item :tag-command "?R???\?[???v???O???????񓯊??Ŏ??s(&A)..."
	    'execute-subprocess-dialog)
	   (:item :tag-command "?񓯊??v???O?????????Ȃ?(&K)"
	    'kill-subprocess
	    #'(lambda ()
		(let ((proc (buffer-process (selected-buffer))))
		  (unless (and proc
			       (eq (process-status proc) :run))
		    :disable))))
	   (:item :tag-command "?R???\?[???v???O?????̎??s(&P)..."
	    'pipe-command-dialog)
	   (:item :tag-command "Windows?v???O?????̎??s(&W)..."
	    'launch-application-dialog)
	   (:item :tag-command (if (featurep :windows-nt)
				   "NT?v?????v?g(&D)"
				 "DOS?v?????v?g(&D)")
	    #'(lambda ()
		(interactive)
		(if (and (featurep :windows-vista)
			 (si:control-pressed)
			 (si:shift-pressed))
		    (run-admin-console)
		  (run-console))))
	   (:sep :above-kbd-macro)
	   (:item :tag-command "?L?[?{?[?h?}?N???L?^?J?n(&S)"
	    'start-kbd-macro)
	   (:item :tag-command "?L?[?{?[?h?}?N???L?^?I??(&E)"
	    'end-kbd-macro
	    :end-macro)
	   (:item :tag-command "?L?[?{?[?h?}?N?????s(&X)"
	    'call-last-kbd-macro
	    #'(lambda () (if (null *last-kbd-macro*) :disable)))
	   (:popup :kbd-macro-popup "?L?[?{?[?h?}?N?????܂?(&O)"
	    (:item :tag-command "?ۑ?(&V)..."
	     'save-last-kbd-macro
	     #'(lambda () (if (null *last-kbd-macro*) :disable)))
	    (:item :tag-command "?ǂݍ???(&L)..."
	     'load-kbd-macro)
	    (:item :tag-command "?t?@?C???֕ۑ?(&S)..."
	     'save-kbd-macro-to-file))
	   (:sep :above-property-sheet)
	   (:item :tag-command "???ʐݒ?(&C)..."
	    'option-property-sheet)
	   (:item :tag-command "???[?J???ݒ?(&L)..."
	    'local-option-property-sheet)
	   (:sep :above-box-drawings)
	   (:item :tag-command "?r?????[?h(&R)"
	    'box-drawings-mode
	    #'(lambda () (if *box-drawings-mode* :check)))
	   (:item :tag-command "?????r??(&T)"
	    'box-drawings-toggle-line-type
	    #'(lambda ()
		(values (unless *box-drawings-mode*
			  :disable)
			(if (eq *box-drawings-line-type* '*box-drawings-thick-line*)
			    :check))))
	   (:sep :above-insert-date)
	   (:item :tag-command "???t?Ǝ????̑}??(&M)..."
	    'insert-date-string)
	   (:item :tag-command "?V???[?g?J?b?g?̍쐬(&N)..."
	    'create-xyzzy-shortcut-dialog)
	   (:item :tag-command "?t?@?C??(&F)..."
	    'open-filer)
	   (:menu nil "????(&I)"
	    *dictionary-popup-menu*)
	   (:sep :above-make-tags)
	   (:item :tag-command "TAGS?t?@?C???̍쐬(&G)..."
	    'make-tags-file-dialog)
	   (:item :tag-command "?^?O?W?????v(&J)"
	    'jump-tag
	    #'(lambda () (unless (and tags-find-target tags-find-point) :disable)))
	   (:item :tag-command "?_?C???N?g?^?O?W?????v(&U)"
	    'direct-tag-jump
	    #'(lambda () (unless (and tags-find-target tags-find-point) :disable)))
	   (:item :tag-command "?o?b?N?^?O?W?????v(&B)"
	    'back-tag-jump
	    #'(lambda () (if (null *global-mark-list*) :disable)))
	   (:sep :|above-(>_<)|)
	   (:popup :|(>_<)-popup| "(>&_<)"
	    (:item :tag-command "?j?t?e?B?̃??O???ǂ?(&N)"
	     'view-nifty-log)
	    (:item :tag-command "?d??(&T)"
	     'calc)
	    (:item :tag-command "?J?????_?[(&A)"
	     'calendar)
	    (:item :tag-command "?n?m?C?̓?(&H)"
	     'hanoi)
	    (:item :tag-command "?ܖ?(&G)"
	     'gomoku)
	    (:item :tag-command "???C?t(&L)"
	     'life)
	    (:item :tag-command "C?Ȑ?(&C)"
	     'c-curve)
	    (:item :tag-command "?h???S???Ȑ?(&R)"
	     'dragon-curve)))
	  (:popup 'help "?w???v(&?)"
	   (:item :tag-command "?L?[???蓖?Ĉꗗ(&K)"
	    'describe-bindings)
	   (:item :tag-command "?ŋߓ??͂????L?[(&L)"
	    'view-lossage)
	   (:sep :above-about)
	   (:item :tag-command "?ɂ???(&A)..."
	    'about-dialog))))

  (setq *buffer-bar-context-menu*
	(define-popup-menu
	  (:item 'close "????(&C)"
	   #'(lambda ()
	       (interactive)
	       (kill-buffer *buffer-bar-context-menu-buffer*)))))

  (setq *pseudo-frame-bar-context-menu*
	(define-popup-menu
	  (:item 'close "????(&C)"
	   #'(lambda ()
	       (interactive)
	       (delete-pseudo-frame *pseudo-frame-bar-context-menu-frame*)))))

  (run-hooks '*init-app-menus-hook*)
  (set-menu *app-menu*)
  (add-file-history-to-menu)
  (add-session-history-to-menu))

(defun make-char-encoding-popup-menu (command &optional init (list *char-encoding-list*))
  (labels ((define-menu (list)
	     (let ((menu (create-popup-menu)))
	       (mapc #'(lambda (encoding)
			 (if (consp encoding)
			     (add-popup-menu menu
					     (define-menu (cdr encoding))
					     (car encoding))
			   (add-menu-item menu nil
					  (char-encoding-display-name encoding)
					  #'(lambda ()
					      (interactive)
					      (funcall command encoding))
					  (and init #'(lambda ()
							(funcall init encoding))))))
		     list)
	       menu)))
    (define-menu
      (if (eq list *char-encoding-list*)
	*char-encoding-tree*
	(labels ((make-tree (tree list)
		   (mapcan #'(lambda (encoding)
			       (if (consp encoding)
				   (let ((l (make-tree (cdr encoding) list)))
				     (and l (list (cons (car encoding) l))))
				 (and (find encoding list :test #'eq)
				      (list encoding))))
			   tree)))
	  (make-tree
	   *char-encoding-tree*
	   (mapcar #'(lambda (encoding)
		       (if (symbolp encoding) (symbol-value encoding) encoding))
	     list)))))))
#|
(defun menu-display-name (path maxlen)
  (when (<= (length path) maxlen)
    (return-from menu-display-name path))
  (let* ((unc )
	 (paths (split-string path #\/))
	 (dev (cond ((eql (string/= path "//") 2)
		     (prog1
			 (concat "//" (car paths) "/" (cadr paths))
		       (setq paths (cddr paths))))
		    (t
		     (pop paths))))
	 (name (progn
		 (setq paths (nreverse paths))
		 (pop paths)))
	 (len (+ (length dev) (length name) 5)))
    (unless name
      (return-from menu-display-name path))
    (when (> len maxlen)
      (return-from menu-display-name name))
    (do* ((npaths nil)
	  (l (length (car paths)) (length (car paths))))
	((> (setq len (+ len l 1)) maxlen)
	 (format nil "~A/.../~{~A/~}~A" dev npaths name))
      (push (pop paths) npaths))))
|#

(defvar *menu-display-length* 40)

(defun add-lru-menu (menu files fn)
  (when (menup menu)
    (while (delete-menu menu 0 t))
    (do ((file files (cdr file))
	 (count 1))
	((or (null file)
	     (> count *menu-history-max*))
	 t)
      (unless (wild-pathname-p (car file))
	(let ((filename (namestring (car file))))
	  (insert-menu-item menu (1- count) nil
			    (format nil "&~:(~35r~): ~a"
				    (rem count 36)
				    (quote-string
				     (abbreviate-display-string
				      filename *menu-display-length* t)
				     #\& #\&))
			    (funcall fn filename)))
	(incf count)))))

(defun add-file-history-to-menu ()
  (when (menup *app-menu*)
    (add-lru-menu *recent-file-popup-menu*
		  *minibuffer-file-name-history*
		  #'(lambda (filename)
		      #'(lambda ()
			  (interactive)
			  (find-file filename)
			  (add-history filename '*minibuffer-file-name-history*))))))
