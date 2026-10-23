;;; init-early.el --- Load the full configuration -*- lexical-binding: t -*-
;;; Commentary:

;; This file bootstraps the configuration, which is divided into
;; a number of other files.

;;; Code:

;; Produce backtraces when errors occur: can be helpful to diagnose startup issues
;;(setq debug-on-error t)

;; Author: brodyliao

;; Windows 下 evil 的 C-h 帮助等依赖 shell，避免启动时报 w32-notify 相关问题
;; （如启动出错可临时打开 debug-on-error 定位）

(require 'init-functions)

(require 'init-basic)

;; 需要在其他包之前探测 Python 3（如 treemacs 依赖）
(require 'init-python)

;; (require 'init-company)

(require 'init-corfu)

(require 'init-evil)

(require 'init-general)

(require 'init-vertico)

(require 'init-orderless)

(require 'init-marginalia)

(require 'init-embark)

(require 'init-consult)

(require 'init-undo-tree)

(require 'init-ace-window)

(require 'init-treemacs)

(require 'init-web)

(require 'init-claude)

(require 'init-lsp-mode)

(require 'init-java)

;; JS/Electron 调试（dap-mode + js-debug 适配器）
(require 'init-dap-js)

(require 'init-magit)