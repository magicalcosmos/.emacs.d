;;; init-python.el --- 定位可用的 Python 3 解释器 -*- lexical-binding: t -*-
;;; Commentary:

;; Windows 上 `python3.exe' 可能命中 Microsoft Store 的「应用执行别名」存根
;; （%LOCALAPPDATA%\Microsoft\WindowsApps\python3.exe，实际指向
;; AppInstallerPythonRedirector.exe）。该存根只检查文件存在是找不到的，
;; 但一执行就会输出 "Python was not found; run without arguments to install
;; from the Microsoft Store..." 并以退出码 49 结束；冷启动还要约 2 秒才返回
;; （它会去尝试拉起 Store）。
;;
;; treemacs 自带的 `treemacs--find-python3' 只做存在性检查、不验证能否真正
;; 运行，于是把存根当成 Python 3 交给 `treemacs-python-executable'，
;; 结果 treemacs 的异步 git 状态刷新全线失败：
;;   [Treemacs] Update of node "..." failed with status "exited abnormally
;;   with code 49" and result
;;
;; 本模块负责挑出一个真正可用的 Python 3，判定分两级：
;;   1. 廉价启发式：Python 3.7+ 的安装目录里带有 `python3.dll' 兄弟文件，
;;      Python 2.7 与 Store 存根都没有，据此可完全免去 spawn 进程。
;;   2. 兜底验证：第一阶段找不到时才执行 `EXE -V'，要求退出码为 0 且输出
;;      以 "Python 3." 开头。
;;
;; 先做免进程的启发式扫描、再做需要 spawn 的兜底验证，是为了不拖慢启动：
;; 命中启发式时一个进程都不用起；Store 存根也永远不会被执行。

;;; Code:

(defgroup bl/python nil
  "Python 解释器探测。"
  :group 'tools)

(defvar bl/python--cached nil
  "缓存的 Python 3 解释器路径，nil 表示未探测到。")

(defvar bl/python--cached-p nil
  "非 nil 表示已经执行过探测，`bl/python--cached' 的 nil 值有效。")

(defcustom bl/python-executable nil
  "手动指定 Python 3 解释器路径，nil 表示自动探测。"
  :type '(choice (const :tag "自动探测" nil) string)
  :group 'bl/python
  :set (lambda (symbol value)
         (set symbol value)
         (setq bl/python--cached nil
               bl/python--cached-p nil)))

(defun bl/python--store-dir-p (path)
  "若 PATH 位于 Microsoft Store 的「应用执行别名」目录中则返回 t。
这些目录里的可执行文件是安装引导存根，运行必然失败且很慢。"
  (and (stringp path)
       (if (string-match-p
            "Microsoft[/\\\\]WindowsApps[/\\\\]"
            (or (file-name-directory path) ""))
           t
         nil)))

(defun bl/python--sibling-marker-p (exe)
  "若 EXE 所在目录带有 `python3.dll' 兄弟文件则返回 t。
这是 Python 3.7+ 安装目录的标志，比 spawn 一个进程验证便宜得多。"
  (and (stringp exe)
       (file-exists-p (expand-file-name "python3.dll"
                                        (file-name-directory exe)))))

(defun bl/python--version (exe)
  "若 EXE 是可用的 Python 3 解释器，返回其版本串，否则返回 nil。
实际执行 `EXE -V' 并要求退出码为 0、输出以 \"Python 3.\" 开头。"
  (when (and (stringp exe) (not (string-empty-p exe))
             (file-exists-p exe))
    (condition-case nil
        (with-temp-buffer
          (let ((status (call-process exe nil t nil "-V")))
            (when (zerop status)
              (let ((out (string-trim (buffer-string))))
                (when (string-match-p "\\`Python 3\\.[0-9]" out)
                  out)))))
      (error nil))))

(defun bl/python--path-candidates ()
  "返回 PATH 上的候选 Python 解释器路径列表，按优先级从高到低排列。
仅按路径推导，不执行任何进程。"
  (append
   (delq nil (list bl/python-executable (getenv "BL_PYTHON")))
   ;; 按 exec-path 顺序扫描，保留 PATH 上的优先级
   (apply #'append
          (mapcar
           (lambda (dir)
             (let ((p3 (expand-file-name "python3.exe" dir))
                   (py (expand-file-name "python.exe" dir)))
               (delq nil
                     (list (when (file-exists-p p3) p3)
                           (when (file-exists-p py) py)))))
           exec-path))
   (and (getenv "LOCALAPPDATA")
        (file-expand-wildcards
         (expand-file-name "Programs/Python/Python3*/python.exe"
                           (getenv "LOCALAPPDATA"))))))

(defun bl/python--launcher-target ()
  "解析 py 启动器默认指向的真实解释器路径，失败返回 nil。
treemacs 只接受单一可执行文件路径，无法给启动器传 \"-3\"，因此必须解析成
绝对路径。解析本身要 spawn 一次 py，故放在兜底阶段才调用。"
  (let ((launcher (executable-find "py")))
    (when launcher
      (with-temp-buffer
        (and (zerop (call-process launcher nil t nil "-3"
                                        "-c" "import sys; print(sys.executable)"))
             (let ((out (string-trim (buffer-string))))
               (and (not (string-empty-p out)) out)))))))

(defun bl/python--dedupe (candidates)
  "去掉 CANDIDATES 中的 nil、空串和重复项，保持原有顺序。"
  (let ((seen nil)
        (result nil))
    (dolist (candidate candidates)
      (when (and (stringp candidate)
                 (not (string-empty-p candidate))
                 (not (member candidate seen)))
        (push candidate seen)
        (push candidate result)))
    (nreverse result)))

(defun bl/find-python3 (&optional refresh)
  "返回一个确实可用的 Python 3 解释器路径，没有则返回 nil。
REFRESH 为非 nil 时忽略缓存重新探测。"
  (when (or refresh (not bl/python--cached-p))
    (let* ((paths (bl/python--dedupe (bl/python--path-candidates)))
           (result nil))
      ;; 第一阶段：免进程的启发式（安装目录带 python3.dll）
      ;; Store 目录不在此排除之列——真正装好的 Store 版 Python 同样带
      ;; python3.dll，而只有安装引导存根才没有。
      (dolist (candidate paths)
        (when (and (not result)
                   (bl/python--sibling-marker-p candidate))
          (setq result candidate)))
      ;; 第二阶段：兜底，实际执行 -V 验证。
      ;; 跳过 Store 目录：那里的引导存根必然失败，且冷启动要约 2 秒。
      (unless result
        (dolist (candidate paths)
          (when (and (not result)
                     (not (bl/python--store-dir-p candidate))
                     (bl/python--version candidate))
            (setq result candidate)))
        ;; 再试 py 启动器解析出的目标（Store 版 Python 也会被启动器发现）
        (unless result
          (let ((target (bl/python--launcher-target)))
            (when (and target
                       (not (bl/python--store-dir-p target))
                       (bl/python--version target))
              (setq result target)))))
      (setq bl/python--cached result
            bl/python--cached-p t)))
  bl/python--cached)

(provide 'init-python)

;;; init-python.el ends here
