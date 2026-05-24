(require 'package)
;; (add-to-list 'package-archives
;;             '("GNU"   . "https://elpa.gnu.org/packages/") t)
;; (add-to-list 'package-archives
;;             '("MELPA-STABLE" . "http://stable.melpa.org/packages/") t)
(add-to-list 'package-archives
             '("MELPA" . "https://melpa.org/packages/") t)
(package-initialize)
;; (package-refresh-contents)		

(setq url-proxy-services '(
	  ("http" . "127.0.0.1:7897")
	  ("https" . "127.0.0.1:7897")
	  ("socks5" . "127.0.0.1:7897")
	  ))

(setq custom-file "~/.emacs.d/custom.el")

;; keyboard
(setq mac-option-modifier 'super)
(setq mac-command-modifier 'meta)

;; 备份文件统一到 ~/.emacs.d/backups
(setq backup-directory-alist `(("." . ,(expand-file-name "backups" user-emacs-directory))))



;; common
(global-display-line-numbers-mode 1) ; 显示行号（注意，还可以调整显示方式）

(setq visible-bell t)				 ; 关闭声音
(setq inhibit-startup-message t)	 ; 关闭启动画面
(fset 'yes-or-no-p 'y-or-n-p)		 ; 简化问询单词
(setq-default tab-width 4)	 ; tab 宽度(menu-bar-mode 0)		        
(tool-bar-mode 0)					 ; 隐藏
(show-paren-mode 1)				; 括号高亮匹配 C-M-f 前跳 / C-M-b 后跳
(global-set-key (kbd "C-M-p") #'scroll-other-window-down) ; 其它窗口向下滚动好像并没有默认被绑定


;; 补全方案2 Vertico + 网格 （不会触发TAB二次补全）
;; 配合 marginalia 获得更多信息，但是会使排版错乱，未成高手前不打算用
(use-package vertico
  :init
  (vertico-mode 1)
  ;; (vertico-grid-mode 1)					; 开启多列/网格
  :custom
  ;; (vertico-grid-annotate 1)				; 注释打开
  ;; (vertico-grid-separator " | ")		; 列间距
  ;; (vertico-grid-max-columns 2)			; 最大列
  ;; (vertico-grid-lookahead 100)			; 网格预览数量
  (vertico-resize nil); 固定高度，更稳布局
)					
;; 固定 M-x 在右侧 60（宽度） 列
(vertico-buffer-mode 1)					;以独立buffer 是示
(setq vertico-buffer-display-action '(display-buffer-in-side-window . ((side . right) (window-width . 60))))

;; 补全方案增强 （加大空间利用率放置注释信息）
;; Marginalia（注释增强）
(use-package marginalia
  :init
  (marginalia-mode 1)
  ;; 可选：为 M-x 使用更详细的命令注释
  (setq marginalia-annotators
        '(marginalia-annotators-heavy  ; 包含命令 docstring/来源库等
          marginalia-annotators-light
		  marginalia-truncate 40
		  marginalia-separator " , "
		  marginalia-align 'right
          nil))
  :bind (:map minibuffer-local-map
			  ("M-A" . marginalia-cycle))
)

;; 更全面的文件路径查看
;; (setq frame-title-format
;;       '("" "%S: " (:eval (system-name)) " — "
;;         (:eval (if buffer-file-name
;;                    (abbreviate-file-name buffer-file-name)
;;                  "%b"))))
(setq frame-title-format
      '((:eval (if buffer-file-name
                   (abbreviate-file-name buffer-file-name)
                 "%b"))))



;; ;; 自动括号
(electric-pair-mode t)
;; 指定哪些字符参与自动配对
(setq electric-pair-pairs '((?\" . ?\")
                            (?\( . ?\))
                            (?\[ . ?\])
                            (?\{ . ?\})))
;; 在注释或字符串中是否配对
(setq electric-pair-inhibit-predicate
      (lambda (char)
        (or (electric-pair-default-inhibit char)
            (minibufferp))))  ;; 例：禁用在 minibuffer
;; (setq electric-indent-mode nil)		; 关闭各种括号影响缩进(我操)

;; 字体
(set-frame-font "JetBrainsMono Nerd Font Mono-16" nil t) ; 字体
(set-face-attribute 'default nil :font "JetBrainsMono Nerd Font Mono" :height 160) ;字体

;; theme
(load-file custom-file) 		; emacs 污染的文件地址
;; (load-theme 'catppuccin :no-confirm)	; 主题 
;; (setq catppuccin-flavor 'mocha)		; 主题模式
;; (load-theme 'ayu)						
(use-package ayu-theme
  :config (load-theme 'ayu-dark t))

(use-package doom-modeline
  :ensure t
  :init (doom-modeline-mode 1))


;; wgsl mode
(use-package wgsl-mode)
(use-package eglot
  :config
  (add-to-list 'eglot-server-programs
               '(wgsl-mode . ("wgsl_analyzer"))))

;; rust mode
(use-package rust-mode)

;; 弹窗补全
(use-package corfu
  :init
  (global-corfu-mode)              ;; 全局启用补全弹窗
  :custom
  (corfu-auto t)                   ;; 自动弹出
  (corfu-popupinfo-mode 1)		   ;; 泡泡说明？
  (corfu-auto-prefix 2)            ;; 2个字符后触发
  (corfu-auto-delay 0.02)          ;; 触发延迟
  (corfu-preview-current nil)      ;; 不预选虚影
  (corfu-scroll-margin 4))

;; 关闭覆盖模式，统一为插入模式
(overwrite-mode -1)

;; 解决 RET 选择项会吃掉后续字符的问题
(with-eval-after-load 'corfu
  (define-key corfu-map (kbd "TAB") #'corfu-insert)
  (define-key corfu-map (kbd "RET") #'corfu-insert))

;; (defun my/plist-del (plist key)
;;   (let (out) (while plist (let ((k (pop plist)) (v (pop plist)))
;;     (unless (eq k key) (setq out (cons v (cons k out))))))
;;     (nreverse out)))

;; (defun my/capf-insert-only (capf)
;;   (lambda ()
;;     (let ((r (funcall capf)))
;;       (when (consp r)
;;         (let* ((beg (nth 0 r)) (table (nth 2 r)) (props (nthcdr 3 r)))
;;           (setq props (my/plist-del props :exit-function))
;;           (append (list beg (point) table) props))))))

;; (with-eval-after-load 'eglot
;;   (add-hook 'eglot-managed-mode-hook
;;     (lambda ()
;;       (setq-local completion-at-point-functions
;;         (mapcar (lambda (f)
;;                   (if (eq f #'eglot-completion-at-point)
;;                       (my/capf-insert-only f) f))
;;                 completion-at-point-functions)))))


;; Eglot（LSP，提供语义补全/跳转/签名等）
(use-package eglot
  :hook ((rust-ts-mode . eglot-ensure)
         (rust-mode    . eglot-ensure))
  :config
  ;; 指定语言服务器（通常自动检测到 rust-analyzer）
  (add-to-list 'eglot-server-programs
               '(rust-ts-mode . ("rust-analyzer")))
  (add-to-list 'eglot-server-programs
               '(rust-mode    . ("rust-analyzer"))))

(setq rust-format-on-save t)
(add-hook 'rust-ts-mode-hook #'eglot-ensure)
(add-hook 'rust-ts-mode-hook
          (lambda ()
            (add-hook 'before-save-hook #'eglot-format-buffer -10 t)))

;; rust-dbg-wrap-or-unwrap
(with-eval-after-load 'rust-ts-mode
  (define-key rust-ts-mode-map (kbd "C-c C-c") #'rust-compile)
  (define-key rust-ts-mode-map (kbd "C-c C-t") #'rust-test)
  (define-key rust-ts-mode-map (kbd "C-c C-r") #'rust-run)
  (define-key rust-ts-mode-map (kbd "C-c C-k") #'rust-check)
  (define-key rust-ts-mode-map (kbd "C-c C-d") #'rust-dbg-wrap-or-unwrap))

;; 使 bevy 的 info/warn/error 宏颜色能在 emacs 的 shellbuffer（compilation-mode） 中正常显示
;; 内置方案，无外部依赖
(require 'ansi-color)
(add-hook 'compilation-filter-hook
          (lambda ()
            (ansi-color-apply-on-region compilation-filter-start (point))))
(add-hook 'compilation-mode-hook
          (lambda ()
            (setq-local compilation-environment
                        (append (list "TERM=xterm-256color"
                                      "CARGO_TERM_COLOR=always")
                                compilation-environment))))

;; 编译或运行时buffer滚动跟随输出
(add-hook 'compilation-mode-hook
          (lambda ()
            (setq-local compilation-scroll-output t)))


;; 签名提示与 Eldoc 文档
(setq eldoc-idle-delay 0.0
      eldoc-echo-area-use-multiline-p t)

;; 可选增强：文档浮窗（GUI/posframe 下效果更好）
;; (use-package eldoc-box
;;   :hook (eglot-managed-mode . eldoc-box-hover-at-point-mode))

;; 匹配风格（更易于模糊匹配），文件补全保持稳定
(setq completion-styles '(flex basic)
      completion-category-overrides '((file (styles . (partial-completion)))))

;; 当是GUI时设置窗体大小
(when (window-system)
  (set-frame-size nil 180 60)		; window size
  (scroll-bar-mode 0)			; 隐藏 scrollbar
  )

;; packages
;; treesit
;; M-x: treesit-auto-install-all
;; brew install tree-sitter 
;; brew install libstree* 
(use-package treesit-auto
  :init
  (setq treesit-auto-langs '(rust python javascript json c c++ go))
  :config
  ;; 启用自动映射与自动安装
  (global-treesit-auto-mode)
  ;; 一键安装所有需要的 grammar（首次配置时运行一次）
  ;; (treesit-auto-install-all)			
  )

;; markdown-mode 还是要的
(use-package markdown-mode
  :mode ("\\.md\\'" . markdown-mode)
  :init
  (setq markdown-command "multimarkdown"))  ;; 可选：渲染命令

;; 可选：自定义高亮和缩进等
(setq treesit-font-lock-level 4)    ;; 1-4，越大高亮越丰富

;; multiple cursor 多光标批量操作
(use-package multiple-cursors
  :bind (
	 ("M-n" . mc/mark-next-like-this)
	 ("M-p" . mc/mark-previous-like-this)
	 ("M-RET" . mc/mark-all-dwim)))

;; 扩展选择(选中当标当前单词，逐步向外延伸)
(use-package expand-region
  :bind
  ("C-'" . er/expand-region))

;;which-key
(use-package which-key
  :diminish
  :config
  (setq which-key-show-early-on-C-h t)
  (which-key-setup-side-window-right)
  (which-key-mode t))

;; 多点编辑
;; C-; 开启快速选取相同，再统一编辑与mc/mark不同
;; iedit一次全选
(use-package iedit)

;; 更快的 ripgrep
(use-package rg)

;; magit mode
(use-package magit)

;; avy
(use-package avy
  :config
  (defun my/avy-goto-char-2--beacon-blink (&rest _)
    (when (bound-and-true-p beacon-mode)
      (beacon-blink)))
  (advice-add 'avy-goto-char-2 :after #'my/avy-goto-char-2--beacon-blink)
  :bind (
		 ("C-." . avy-goto-char-2)
		 ("C-," . avy-goto-line)
		 ))

;; 目录浏览
(use-package dired-sidebar
  :bind (("C-x C-n" . dired-sidebar-toggle-sidebar))
  :commands (dired-sidebar-toggle-sidebar)
  :init
  (add-hook 'dired-sidebar-mode-hook
            (lambda ()
              (unless (file-remote-p default-directory)
                (auto-revert-mode))))
  :config
  (push 'toggle-window-split dired-sidebar-toggle-hidden-commands)
  (push 'rotate-windows dired-sidebar-toggle-hidden-commands)
  ;; (setq dired-sidebar-subtree-line-prefix "__")
  (setq dired-sidebar-theme 'ascii)
  (setq dired-sidebar-use-term-integration t)
  (setq dired-sidebar-use-custom-font t))

;; 快速插入时间
(add-hook 'markdown-mode-hook
  (lambda ()
    (local-set-key (kbd "C-c d") 'insert-date)))

(defun insert-date ()
  "插入当前日期时间"
  (interactive)
  (insert (format-time-string "%Y-%m-%d %H:%M:%S")))

;; 选中区域快速包裹 (用到再说)
;; (use-package wrap-region :ensure t)
;; (wrap-region-add-wrapper "`" "`")
;; (wrap-region-add-wrapper "*" "*")
;; (wrap-region-mode t)

;; ;; 仅量行居中
;; ;; 光标上下至少保留 N 行
;; (setq scroll-margin 30)
;; ;; 减少跳动
;; (setq scroll-conservatively 101)
;; (put 'narrow-to-region 'disabled nil)


;; eldoc-box
(use-package eldoc-box
  :ensure t
  :hook (eglot-managed-mode . eldoc-box-hover-mode)
  :custom
  (setq eldoc-message-function #'ignore)
  (eldoc-box-hover-delay 0.2)
  (eldoc-box-max-pixel-width 600)
  (eldoc-box-max-pixel-height 400))

;; 仅着色光标嵌套的括号
(use-package highlight-parentheses
  :ensure t)
(add-hook 'prog-mode-hook #'highlight-parentheses-mode)

;; Org-mode
(setq org-todo-keywords
	  '((sequence "TODO(t)" "NEXT(n)" "IMPORTANT(i)" "STARTED(s)" "BUG(b)" "REPORT(r)" "WAIT(w)" "|" "DONE(d!)" "DELETED(l!)" "CANCELED(c!)" "FIXED(f!)" "ARCHIVED(a!)")))
(setq org-todo-keyword-faces
	  '(("TODO" . "white")
		("NEXT" . "green4")
		("IMPORTANT" . "red")
		("STARTED" . "yellow")
		("BUG" . "yellow")
		("WAIT" . "magenta1")
		("REPORT" . "magenta4")
		("DONE" . (:foreground "cyan1" :weight bold :underline t))
		("DELETED" . "red")
		("CANCELED" . (:foreground org-warning :weight bold :strike-through t))
		("FIXED" . (:foreground org-warning :weight bold :strike-through t))
		("ARCHIVED" . (:foreground "unemphasizedSelectedTextBackgroundColor" :weight bold :underline t))
		))

;; 设置 todo 的 title 颜色
(setq org-fontify-todo-headline t)
(custom-set-faces
 '(org-headline-todo ((t (:foreground "gray50")))))

;; 设置 done 的 title 颜色
(setq org-fontify-done-headline t)
(custom-set-faces
 '(org-headline-done ((t (:foreground "gray30")))))

;; 默认就是LOGBOOK
;; (setq org-log-into-drawer "LOGBOOK")
;; (setq org-log-into-drawer t)
;; (setq org-log-state 'time)
;; (setq org-log-done 'time)

;; 新的 buffer(HELP类)自动获得焦点
(setq help-window-select t)

;; 快速调节窗体宽度
(global-set-key (kbd "s-[") #'enlarge-window-horizontally)
(global-set-key (kbd "s-]") #'shrink-window-horizontally)

;; 用 ibuffer 替换默认的 list-buffers（C-x C-b）
(global-set-key (kbd "C-x C-b") #'ibuffer)


;;
(use-package beacon)
(beacon-mode 1)

;; (use-package beacon
;;   :ensure t
;;   :init
;;   (beacon-mode 1))

;; 高亮行
;; (global-hl-line-mode t)			; 所在行高亮
;; (set-face-background 'hl-line "#032F2E") ; 使用十六进制颜色代码

;; 全局自动刷新
(global-auto-revert-mode t)

;; 禁用不需要行号的模式
(dolist (mode '(org-mode-hook
				shell-mode-hook))
  (add-hook mode (lambda () (display-line-numbers-mode 0))))
