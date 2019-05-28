;;;-----------------------Do Some Config For Packages BEGIN--------------------------
(require 'package)
(add-to-list 'package-archives
             '("melpa" . "http://melpa.org/packages/") t)

(package-initialize)

(when (not package-archive-contents)
  (package-refresh-contents))

(unless (package-installed-p 'use-package)
  (package-install 'use-package))

(require 'use-package)
(setq use-package-always-ensure t)

(add-to-list 'load-path "~/.emacs.d/custom")

(require 'setup-general)
(if (version< emacs-version "24.4")
    (require 'setup-ivy-counsel)
  (require 'setup-helm)
  (require 'setup-helm-gtags))
;; (require 'setup-ggtags)
(require 'setup-cedet)
(require 'setup-editing)

;;config for slime
(setq inferior-lisp-program "D:\\sbcl\\sbcl")
(setq slime-contrib '(slime-fancy))

;;config speed bar
(setq speedbar-show-unknown-files t)

;;set default ansi-term binary file
;;(setq explicit-shell-file-name "d:\\cmder\\vendor\\git-for-windows\\bin\\bash.exe")

;;Do not make backup files
(setq make-backup-files nil)
(put 'downcase-region 'disabled nil)
;;;-----------------------Do Some Config For Packages END--------------------------


;; function-args
;; (require 'function-args)
;; (fa-config-default)
;; (define-key c-mode-map  [(tab)] 'company-complete)
;; (define-key c++-mode-map  [(tab)] 'company-complete)
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(ansi-color-faces-vector
   [default default default italic underline success warning error])
 '(ansi-color-names-vector
   ["#2e3436" "#a40000" "#4e9a06" "#c4a000" "#204a87" "#5c3566" "#729fcf" "#eeeeec"])
 '(custom-enabled-themes (quote (wombat)))
 '(default-input-method "chinese-py")
 '(message-default-charset (quote iso-8859-1))
 '(org-agenda-files (quote ("~/Todo.org")))
 '(package-selected-packages
   (quote
    (paredit nofrils-acme-theme gotest racer flycheck-rust company-racer zenburn-theme cargo rust-mode cider markdown-mode md-readme protobuf-mode go-autocomplete exec-path-from-shell go-mode sr-speedbar magit expand-region evil neotree auto-complete-c-headers auto-complete yasnippet-snippets ggtags zygospore helm-gtags helm yasnippet ws-butler volatile-highlights use-package undo-tree iedit dtrt-indent counsel-projectile company clean-aindent-mode anzu))))



;;config for ggtags
(require 'ggtags)
(add-hook 'c-mode-common-hook
          (lambda ()
            (when (derived-mode-p 'c-mode 'c++-mode 'java-mode 'asm-mode)
              (ggtags-mode 1))))
(define-key ggtags-mode-map (kbd "C-c g s") 'ggtags-find-other-symbol)
(define-key ggtags-mode-map (kbd "C-c g h") 'ggtags-view-tag-history)
(define-key ggtags-mode-map (kbd "C-c g r") 'ggtags-find-reference)
(define-key ggtags-mode-map (kbd "C-c g f") 'ggtags-find-file)
(define-key ggtags-mode-map (kbd "C-c g c") 'ggtags-create-tags)
(define-key ggtags-mode-map (kbd "C-c g u") 'ggtags-update-tags)

;;config for helm, to use helm-gtags
(setq
 helm-gtags-ignore-case t
 helm-gtags-auto-update t
 helm-gtags-use-input-at-cursor t
 helm-gtags-pulse-at-cursor t
 helm-gtags-prefix-key "\C-cg"
 helm-gtags-suggested-key-mapping t)

(require 'helm-gtags)
;;enable helm-gtags-mode
(add-hook 'dired-mode-hook 'helm-gtags-mode)
(add-hook 'eshell-mode-hook 'helm-gtags-mode)
(add-hook 'c-mode-hook 'helm-gtags-mode)
(add-hook 'c++-mode-hook 'helm-gtags-mode)
(add-hook 'asm-mode-hook 'helm-gtags-mode)

(define-key helm-gtags-mode-map (kbd "C-c a") 'helm-gtags-tags-in-this-function)
(define-key helm-gtags-mode-map (kbd "C-j") 'helm-gtags-select)
(define-key helm-gtags-mode-map (kbd "M-.") 'helm-gtags-dwin)
(define-key helm-gtags-mode-map (kbd "M-,") 'helm-gtags-pop-stack)
(define-key helm-gtags-mode-map (kbd "C-c <") 'helm-gtags-previous-history)
(define-key helm-gtags-mode-map (kbd "C-c >") 'helm-gtags-next-history)

;;auto complete setting
(require 'auto-complete)
(require 'auto-complete-config)
(ac-config-default)

;;yasnippet setting
(require 'yasnippet)
(yas-global-mode 1)

;;c/c++ head files auto-complete
(defun my:ac-c-header-init()
  (require 'auto-complete-c-headers)
  (add-to-list 'ac-source 'ac-source-c-headers))

(add-hook 'c++-mode-hook 'my:ac-c-header-init)
(add-hook 'c-mode-hook 'my:ac-c-header-init)

;;disable emacs toolbar, menubar, scrollbar
(tool-bar-mode -1)

;;set auto-complete-mode one
(auto-complete-mode 1)

;;insert shell header
(defun shell-header ()
  "Insert header in shell script file."
  (interactive)
  (insert "#!/bin/bash"))

;;------------------------Rename file and buffer Begin---------------------
;;Rename file and buffer
(defun rename-file-and-buffer (new-name)
  "Rename both current buffer and file it's visting to NEW-NAME."
  (interactive "sNew name: ")
  (let ((bufname (buffer-name))
        (filename (buffer-file-name)))
    (if (not filename)
        (message "Buffer '%s' is not visiting a file!" bufname)
      (if (get-buffer new-name)
          (message "A buffer named '%s' already exists!" new-name)
        (progn
          (rename-file filename new-name 1)
          (rename-buffer new-name)
          (set-visited-file-name new-name)
          (set-buffer-modified-p nil))))))

(global-set-key (kbd "M-s r") 'rename-file-and-buffer)
;;------------------------Rename file and buffer End---------------------


;;;------------------Remap Some Command Begin-------------------
;;Remap set-mark-command, set to M-s s
(global-set-key (kbd "M-s s") 'set-mark-command)
(global-set-key (kbd "M-s n") 'neotree-toggle)

;;remap some key stroke for source code navigate
(global-set-key (kbd "M-s f") 'forward-sexp)
(global-set-key (kbd "M-s b") 'backward-sexp)
(global-set-key (kbd "M-s k") 'kill-sexp)
(global-set-key (kbd "M-s m") 'mark-sexp)
(global-set-key (kbd "M-s a") 'beginning-of-defun)
(global-set-key (kbd "M-s e") 'end-of-defun)

;;setting emacs-evil mode
(add-to-list 'load-path "~/.emacs.d/elpa/evil")
(require 'evil)
(global-set-key (kbd "C-x t") 'turn-on-evil-mode)
(global-set-key (kbd "C-x y") 'turn-off-evil-mode)

;;set emacs expand-region
(require 'expand-region)
(global-set-key (kbd "C-x =") 'er/expand-region)

;;set magit
(global-set-key (kbd "C-x g") 'magit-status)
;;;------------------Remap Some Command End-------------------

;;;----------Go path and GoDoc--------------------------------
(defun set-exec-path-from-shell-PATH ()
  (let ((path-from-shell (replace-regexp-in-string
                          "[ \t\n]*$"
                          ""
                          (shell-command-to-string "$SHELL --login -i -c 'echo $PATH'"))))
    (setenv "PATH" path-from-shell)
    (setq eshell-path-env path-from-shell) ; for eshell users
    (setq exec-path (split-string path-from-shell path-separator))))

(when window-system (set-exec-path-from-shell-PATH))
(setenv "GOPATH" "/home/hjiang/go")
;;;----------Go path and GoDoc--------------------------------

;;;----------Automatically call gofmt on save-----------------
(add-to-list 'exec-path "/usr/bin/go")
;;;----------Automatically call gofmt on save-----------------

;;;----------Godef, quick jump around the go code-------------
(defun my-go-mode-hook ()
  ; Call Gofmt before saving
  (add-hook 'before-save-hook 'gofmt-before-save)
  ; Customize compile command to run go build
  (if (not (string-match "go" compile-command))
      (set (make-local-variable 'compile-command)
           "go build -v && go test -v && go vet"))
  ; Godef jump key binding
  (local-set-key (kbd "M-.") 'godef-jump)
  (local-set-key (kbd "M-,") 'pop-tag-mark))
(add-hook 'go-mode-hook 'my-go-mode-hook)
;;;----------Godef, quick jump around the go code-------------

;;;----------Go autocomplete mode-----------------------------
(defun auto-complete-for-go ()
  (auto-complete-mode 1))
(add-hook 'go-mode-hook 'auto-complete-for-go)

(with-eval-after-load 'go-mode
  (require 'go-autocomplete)
  (require 'auto-complete-config)
  (ac-config-default))
;;;----------Go autocomplete mode-----------------------------
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(default ((t (:inherit nil :stipple nil :background "#3F3F3F" :foreground "#DCDCCC" :inverse-video nil :box nil :strike-through nil :overline nil :underline nil :slant normal :weight normal :height 140 :width normal :foundry "DAMA" :family "Ubuntu Mono")))))

;;;---------Reconfig sr-speedbar------------------------------
(use-package sr-speedbar
  :ensure t
  :defer t
  :init
  (setq sr-speedbar-right-side nil)
  (setq speedbar-show-unknown-files t)
  (setq sr-speedbar-width 30)
  (setq sr-speedbar-max-width 30)
  (setq speedbar-use-images t)
  (setq speedbar-initial-expansion-list-name "quick buffers")
  (sr-speedbar-open)
  (with-current-buffer sr-speedbar-buffer-name
    (setq window-size-fixed 'width))
  (define-key speedbar-mode-map "\M-p" nil))
(global-set-key (kbd "C-c b") 'sr-speedbar-toggle)
;;;---------Reconfig sr-speedbar------------------------------

;;;---------Line Mode-----------------------------------------
(add-hook 'find-file-hook (lambda () (linum-mode 1)))
(setq linum-format "%d ")
;;;---------Line Mode-----------------------------------------

;;;-------------------Rust Settings---------------------------
(add-hook 'rust-mode-hook 'cargo-minor-mode)

;;rustfmt
(add-hook 'rust-mode-hook
          (lambda ()
            (local-set-key (kbd "C-c <tab>") #'rust-format-buffer)))

;;racer
(setq racer-cmd "~/.cargo/bin/racer")
(setq racer-rust-src-path "/home/hjiang/.rustup/toolchains/stable-x86_64-unknown-linux-gnu/lib/rustlib/src/rust/src")
(add-hook 'rust-mode-hook #'racer-mode)
(add-hook 'racer-mode-hook #'eldoc-mode)
(add-hook 'racer-mode-hook #'company-mode)

;;fly check rust
(add-hook 'flycheck-mode-hook #'flycheck-rust-setup)
;;;-------------------Rust Settings---------------------------

;;;-------------------ZenBurn---------------------------------
(load-theme 'zenburn t)
;;;-------------------ZenBurn---------------------------------

;;;-------------------Org Mode--------------------------------
(global-set-key (kbd "C-c a") 'org-agenda)
;;;-------------------Org Mode--------------------------------

(global-set-key (kbd "C-x C-r") 'replace-string)
