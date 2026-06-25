;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

(add-to-list 'load-path "/usr/share/emacs/site-lisp/mu4e")

(setq user-full-name "Sazid Mahmud"
      user-mail-address "sazidmahmud5@gmail.com")

(setq doom-font (font-spec :family "Iosevka Nerd Font Mono" :size 20 :weight 'medium)
      doom-variable-pitch-font (font-spec :family "Iosevka Nerd Font" :size 20))

(setq doom-theme 'gruber-darker)

(setq display-line-numbers-type 'relative)

(setq org-directory "~/org/")

(setq bookmark-save-flag 1)

;; use gofumpt
(after! lsp-mode
  (setq lsp-go-use-gofumpt t
        lsp-idle-delay 0.1
        lsp-completion-enable-additional-text-edit t
        lsp-modeline-code-actions-enable t
        lsp-go-analyses '((fieldalignment . t)
                          (nilness . t)
                          (shadow . t)
                          (unusedparams . t)
                          (unusedwrite . t)
                          (useany . t)
                          (unusedvariable . t))))

;; Keep your custom save-hook but cleanly isolated
(defun lsp-go-install-save-hooks ()
  (add-hook 'before-save-hook #'lsp-organize-imports t t))
(add-hook 'go-mode-hook #'lsp-go-install-save-hooks)

;; Clipboard integration for Wayland
(when (and (executable-find "wl-copy")
           (executable-find "wl-paste"))

  (defun my-wl-copy (text)
    "Copy text using wl-copy when running in a terminal."
    (if (display-graphic-p)
        (gui-select-text text)
      (let ((wl-copy-process
             (make-process :name "wl-copy"
                           :buffer nil
                           :command '("wl-copy" "--type" "text/plain")
                           :connection-type 'pipe)))
        (process-send-string wl-copy-process text)
        (process-send-eof wl-copy-process))))

  (defun my-wl-paste ()
    "Paste text using wl-paste when running in a terminal."
    (if (display-graphic-p)
        (gui-selection-value)
      (shell-command-to-string "wl-paste --no-newline --type text/plain")))

  ;; Bind the functions to Emacs' internal clipboard hooks
  (setq interprogram-cut-function #'my-wl-copy)
  (setq interprogram-paste-function #'my-wl-paste))

;; remove LSP delays
(after! flycheck (setq flycheck-idle-change-delay 0.3))
(after! lsp-mode
  (setq lsp-idle-delay 0.1)
  (setq lsp-completion-enable-additional-text-edit t)
  (setq lsp-modeline-code-actions-enable t)
  )

;; Debugging with Dape
(after! dape
  ;; Turn on global tuning features like inline variable hints
  (dape-breakpoint-global-mode 1)

  ;; Set the UI window layout arrangement
  (setq dape-buffer-window-arrangements dape-buffer-window-arrangement-vsplit))

;; rss
(setq rmh-elfeed-org-files (list (expand-file-name "elfeed.org" doom-private-dir)))

;; Personal Info
(setq user-mail-address "sazidmahmud5@gmail.com"
      user-full-name "Sazid Mahmud")

;; ==========================================
;; MAIL & ORG INTEGRATION (mu4e + gmail + org)
;; ==========================================

(after! mu4e
  (setq mu4e-mu-binary "/usr/bin/mu"
        mu4e-maildir "~/Mail"                     ; Must match your ~/.mbsyncrc Path
        mu4e-get-mail-command "mbsync -a"         ; Syncs all channels
        mu4e-update-interval (* 10 60)             ; Auto-sync every 5 minutes
        mu4e-change-filenames-when-moving t)      ; Keeps mbsync database happy

  ;; Folder navigation shortcuts
  (setq mu4e-maildir-shortcuts
        '((:maildir "/Inbox"             :key ?i)
          (:maildir "/[Gmail]/Sent Mail" :key ?s)
          (:maildir "/[Gmail]/Trash"     :key ?t)
          (:maildir "/[Gmail]/Drafts"    :key ?d)
          (:maildir "/[Gmail]/All Mail"    :key ?a)))

  ;; Gmail Context Configuration
  (setq mu4e-contexts
        (list
         (make-mu4e-context
          :name "Gmail"
          :match-func (lambda (msg) (when msg (string-match-p "^/Inbox\\|^/\\[Gmail\\]" (mu4e-message-field msg :maildir))))
          :vars '((user-mail-address   . "sazidmahmud5@gmail.com")
                  (user-full-name      . "Sazid Mahmud")
                  (mu4e-sent-folder    . "/[Gmail]/Sent Mail")
                  (mu4e-drafts-folder  . "/[Gmail]/Drafts")
                  (mu4e-trash-folder   . "/[Gmail]/Trash")
                  (mu4e-refile-folder  . "/[Gmail]/All Mail")))))

  ;; Outgoing SMTP via msmtp (More reliable than Emacs' built-in smtpmail with mbsync)
  (setq message-send-mail-function 'message-send-mail-with-sendmail
        sendmail-program (executable-find "msmtp")
	message-sendmail-extra-arguments '("-t")
        user-mail-address "sazidmahmud5@gmail.com"
        user-full-name "Sazid Mahmud")


  ;; --- ORG-MODE INTEGRATION ---
  ;; Allows you to store/capture hyper-links directly to a specific email
  (after! org
    (setq org-mu4e-link-query-in-headers-mode nil)))

;; Rich HTML email creation using Org-mode syntax
(use-package! org-msg
  :defer t
  :init
  (setq org-msg-options "html-postamble:nil H:5 num:nil ^:{} toc:nil author:nil email:nil"
        org-msg-startup "hidestars indent inlineimages"
        org-msg-greeting-fmt "Hi %s,\n\n"
        org-msg-recipient-msge-ids-blk nil)
  (add-hook 'mu4e-compose-pre-hook #'org-msg-mode))
