;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

(blink-cursor-mode -1)

(setq doom-font (font-spec :family "JetBrainsMono Nerd Font" :size 22 :weight 'regular)
      doom-variable-pitch-font (font-spec :family "JetBrainsMono Nerd Font" :size 22)
      doom-symbol-font (font-spec :family "Symbols Nerd Font Mono" :size 22)

      ;; Visual padding for clean reading
      line-spacing 0.12)

;; Handle Bengali script native rendering
(defun my-setup-bangla-font ()
  "Set up a dedicated font for the Bengali script."
  (when (member "Noto Sans Bengali" (font-family-list))
    (set-fontset-font t 'bengali (font-spec :family "Noto Sans Bengali" :size 22))))

(add-hook 'after-setting-font-hook #'my-setup-bangla-font)

(defun +dashboard-draw-ascii-banner-fn ()
  (propertize
   (string-join
    '(" _____ __  __    _    ____ ____  "
      "| ____|  \\/  |  / \\  / ___/ ___| "
      "|  _| | |\\/| | / _ \\| |   \\___ \\ "
      "| |___| |  | |/ ___ \\ |___ ___) |"
      "|_____|_|  |_/_/   \\_\\____|____/ ")
    "\n")
   'face '+dashboard-banner))

;;  ██████╗  ███████╗  ██████╗ ██╗  ██╗ ██╗       █████╗  ███████╗ ███████╗ ██████╗
;; ██╔═══██╗ ██╔════╝ ██╔════╝ ██║  ██║ ██║      ██╔══██╗ ██╔════╝ ██╔════╝ ██╔══██╗
;; ██║██╗██║ ███████╗ ██║      ███████║ ██║      ███████║ █████╗   █████╗   ██████╔╝
;; ██║██║██║ ╚════██║ ██║      ██╔══██║ ██║      ██╔══██║ ██╔══╝   ██╔══╝   ██╔══██╗
;; ╚█║████╔╝ ███████║ ╚██████╗ ██║  ██║ ███████╗ ██║  ██║ ██║      ███████╗ ██║  ██║
;;  ╚╝╚═══╝  ╚══════╝  ╚═════╝ ╚═╝  ╚═╝ ╚══════╝ ╚═╝  ╚═╝ ╚═╝      ╚══════╝ ╚═╝  ╚═╝

;; (setq fancy-splash-image "~/.config/doom/splash-images/emacs-e.svg")

(setq doom-theme 'doom-tokyo-night)

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

;; Alt-o toggles buffer windows
(define-key global-map (kbd "M-o") 'other-window)

;; j-k navigation respects softwrap texts. 5-j/5-k does regular 5 line jumps as usual.
(after! evil
  (evil-define-motion my/evil-next-line (count)
    :type line
    (if count
        (evil-next-line count)
      (evil-next-visual-line 1)))

  (evil-define-motion my/evil-previous-line (count)
    :type line
    (if count
        (evil-previous-line count)
      (evil-previous-visual-line 1)))

  (map! :n "j" #'my/evil-next-line
        :n "k" #'my/evil-previous-line))

