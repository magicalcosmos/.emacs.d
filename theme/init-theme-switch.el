;; 设置日间主题和夜间主题
(setq day-theme nil)
(setq dark-theme nil)

;; 指示当前主题的类别：t 表示日间主题，nil 表示夜间主题
(setq is-day-theme nil)

;; 获取当前主题
(defun get-current-theme ()
  (nth 0 custom-enabled-themes))

;; 切换编辑器主题
(defun switch-theme (&optional target-theme)
  ;; 没传参数时直接获取当前主题
  (if (eq target-theme nil)
      (setq target-theme (get-current-theme)))
  ;; 只有设置了主题才能继续
  (if (not (eq target-theme nil))
      (progn
        ;; 如果当前主题不是 nil 就首先卸掉当前主题
        (setq current-theme (get-current-theme))
        (if (not (eq current-theme nil))
            (disable-theme (get-current-theme)))
        ;; 是明亮主题就切换为明亮主题；否则就反过来
        (if (eq target-theme day-theme)
            (progn
              (load-theme day-theme t)
              (setq is-day-theme t))
          (progn
            (load-theme dark-theme t)
            (setq is-day-theme nil))))))

;; 自动切换编辑器主题
(defun synchronize-theme ()
  ;; 获取是否处在白天
  (setq is-in-day nil)
  ;; 获取当前处于几点：24 小时制
  (setq hour (string-to-number (substring (current-time-string) 11 13)))
  ;; 判断当前是否处于白天：从早上 6 点开始到晚上过了 16 点
  (setq is-in-day (not (eq nil (member hour (number-sequence 6 16)))))
  ;; (setq is-in-day (eq 1 (mod (nth 2 (current-time)) 2)))
  ;; 获取当前主题
  (setq current-theme (get-current-theme))
  ;; 设置是否已经执行了主题切换
  (setq theme-changed nil)
  ;; 处于白天并且当前主题不是明亮主题时执行
  (if (and (eq is-in-day t) (not (eq current-theme day-theme)))
      (progn
        (switch-theme day-theme)
        (setq theme-changed t)))
  ;; 处于晚上并且当前主题不是暗黑主题时执行
  (if (and (eq is-in-day nil) (not (eq current-theme dark-theme)))
      (progn
        (switch-theme dark-theme)
        (setq theme-changed t))))
;; (if theme-changed
;;     (progn
;;       ;; 设置高亮列的背景色
;;       ;; (set-face-attribute 'col-highlight nil :inherit 'hl-line :background)
;;       ;; 重新编译 Spaceline
;;       (if (spaceline-compile)
;;           (spaceline-compile)))))

;; 当前主题检查循环是否正在运行
(setq is-theme-running nil)
;; 当前正在执行的 interval token，默认值为 nil，开始运行主题切换检查后置为 t
(setq token-of-interval nil)
;; 执行主题切换检查
(defun run-theme()
  (if (eq is-theme-running nil)
      (progn
        ;; 设置自动主题更换已经运行
        (setq is-theme-running t)
        ;; 加载 spaceline
        ;; (load-spaceline)
        ;; 设置启动后全屏
        (if (display-graphic-p)
            (run-with-timer 1 nil 'toggle-frame-fullscreen))
        ;; GUI 模式下才自动运行主题切换：每 10 分钟运行一次检查
        (if (display-graphic-p)
            (setq token-of-interval (run-with-timer 0 600 'synchronize-theme))
          ;; Terminal 下永久使用 dark-theme 主题
          (load-theme dark-theme t)))))

(use-package solarized-theme
  :defer t
  :init
  ;; 设置明亮主题
  (setq day-theme 'solarized-light)
  ;; 设置暗黑主题
  (setq dark-theme 'solarized-dark)
  ;; 当前活跃 frame 的数量，默认的数量是 0
  (setq current-frame-count 0)
  ;; 启动时不是 daemon 模式就执行主题设置
  (if (eq (daemonp) nil)
      (progn
        ;; 初始不是后台的方式启动，设置当前活跃的 frame 数量 +1
        (setq current-frame-count (+ current-frame-count 1))
        ;; 执行设置主题功能
        (run-theme)))
  (add-hook 'after-make-frame-functions
            (lambda (new-frame)
              (select-frame new-frame)
              ;; 每次新建 frame 设置当前活跃的 frame 数量 +1
              (setq current-frame-count (+ current-frame-count 1))
              ;; 执行设置主题功能
              (run-theme)))
  (add-hook 'after-delete-frame-functions
            (lambda (deleted-frame)
              ;; 每次销毁 frame 设置当前活跃的 frame 数量 -1
              (setq current-frame-count (- current-frame-count 1))
              ;; 销毁了全部的活跃 frame 后停止主题切换检查，同时复位 is-theme-running
              (if (= current-frame-count 0)
                  (progn
                    (setq is-theme-running nil)
                    (cancel-timer token-of-interval)
                    (setq token-of-interval nil))))))