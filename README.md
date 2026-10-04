# brodyliao 的 Emacs 配置

基于 **Emacs 29+** 的个人配置，使用 **straight.el** + **package.el** 混合管理插件，以 **Evil**（Vim 模式）+ **Corfu**（补全）+ **Vertico 全家桶**（minibuffer 交互）为核心。

---

## 环境要求

- Emacs 29.4+（claude-code.el 模块需 Emacs 30+）
- macOS（配置中针对 darwin 做了按键映射；也兼容 Linux / Windows）
- 可执行文件路径：`/usr/local/bin`、`/opt/homebrew/bin`（启动时自动加入 `PATH`）

## 启动流程

```
init.el            入口：设置 PATH、load-path，加载以下文件
├── start.el       straight.el 引导、use-package、package archives
│                  （melpa / melpa-stable / org / gnu elpa）
├── init-early.el  按序加载 etc/core/ 下的所有模块
└── custom.el      M-x customize 的自定义设置（自动生成）
```

## 目录结构

```
~/.emacs.d/
├── init.el              入口文件
├── start.el             包管理引导（straight.el + package.el）
├── init-early.el        模块加载清单（增删模块在此修改）
├── custom.el            customize 自动生成的配置
├── etc/core/            各功能模块（见下表）
├── snippets/web-mode/   web-mode 代码模板（含 Vue3 模板）
├── straight/            straight.el 管理的插件
└── elpa/                package.el 安装的插件
```

### 功能模块（etc/core/）

| 模块 | 功能 | 状态 |
|---|---|---|
| `init-basic.el` | 基础设置：相对行号、全屏、GC 优化、UTF-8、禁用备份文件 | 启用 |
| `init-evil.el` | Vim 模式 + evil-collection + 注释插件 | 启用 |
| `init-general.el` | `SPC` leader key 前缀定义 | 启用 |
| `init-corfu.el` | 补全前端（全局启用，输入自动弹出） | 启用 |
| `init-vertico.el` | minibuffer 垂直补全 + 历史持久化 | 启用 |
| `init-orderless.el` | 模糊匹配（支持 `~flex`、`=literal` 等调度符） | 启用 |
| `init-marginalia.el` | minibuffer 候选项注解 | 启用 |
| `init-consult.el` | 增强版搜索/跳转（consult-line 等） | 启用 |
| `init-embark.el` | 上下文动作（minibuffer 中 `H-o` 导出） | 启用 |
| `init-undo-tree.el` | 可视化撤销树 | 启用 |
| `init-ace-window.el` | 窗口快速切换 | 启用 |
| `init-treemacs.el` | 文件树（含 git 集成） | 启用 |
| `init-web.el` | web-mode：HTML/Vue/TSX/CSS 等前端开发 | 启用 |
| `init-claude.el` | Claude Code 集成（`C-c c` 前缀，eat 终端后端，跨平台） | 启用 |
| `init-java.el` | Java 开发（lsp-java / Eclipse JDT.ls） | 启用 |
| `init-company.el` | company 补全前端 | 已注释（被 corfu 替代） |
| `init-lsp-mode.el` | LSP 智能补全/跳转/诊断（lsp-mode + lsp-ui，配合 corfu） | 启用 |
| `init-magit.el` | Magit | 未加载 |

---

## 常用快捷键

### 基础

| 按键 | 功能 |
|---|---|
| `Cmd` / `Option`（macOS） | `Cmd` = `Meta`（M-），`Option` = `Super`（s-） |
| `y` / `n` | 替代 yes/no 确认 |
| `ESC` | 取消一切（keyboard-escape-quit） |
| `TAB` | 智能补全（`tab-always-indent 'complete`） |

### Evil（Vim 模式）

| 按键 | 功能 |
|---|---|
| `j` / `k` | 按视觉行移动（自动换行友好） |
| `C-g`（insert 模式） | 返回 normal 模式 |
| `C-k` / `C-j`（normal 模式） | 粘贴历史 上一个/下一个 |
| `M-/` | 注释/取消注释当前行（normal/visual 均可） |
| `:q` | 关闭当前 buffer（不退出 Emacs） |
| `:wq` | 保存并关闭当前 buffer |
| 方向键 | **已禁用**（提示 "Arrow keys are Forbidden"） |

### 窗口 / 文件树

| 按键 | 功能 |
|---|---|
| `M-o` | ace-window 窗口切换（按 `a s d f...` 选择） |
| `C-0` | 跳到/打开 Treemacs 窗口 |
| `C-x t t` | 打开 Treemacs |
| `C-x t 1` | 仅保留 Treemacs |
| `C-x t f` | Treemacs 定位当前文件（`C-x t C-t`） |
| `C-x t B` / `C-x t M-t` | Treemacs 书签 / tag |

### 撤销

| 按键 | 功能 |
|---|---|
| `u` / `C-r` | 撤销 / 重做（evil + undo-tree） |
| `M-x undo-tree-visualize` | 可视化撤销树（带时间戳和 diff） |

### Minibuffer 补全（Vertico + Orderless）

| 输入 | 说明 |
|---|---|
| 空格分隔多个词 | 乱序模糊匹配（如 `fun hand` 匹配 `handle-function`） |
| `~foo~` | flex 匹配 |
| `=foo` | 精确字面量 |
| `` `foo `` | 首字母缩写匹配 |
| `!foo` | 排除包含 foo 的候选 |
| `H-o`（minibuffer 中） | Embark 导出候选列表 |

### Web 开发（web-mode）

自动应用于：`.html` `.vue` `.ts` `.tsx` `.jsx` `.css` `.scss` `.erb` 等。

- HTML 文件按 Django 模板引擎解析（`web-mode-engines-alist`）
- 缩进统一 2 空格；`typescript-indent-level` = 2
- CSS 颜色值直接高亮显示；当前元素/列高亮
- 标签自动闭合（`web-mode-tag-auto-close-style 2`）
- `snippets/web-mode/` 下有 Vue3 等代码模板可用

### Claude Code（`init-claude.el`）

在 Emacs 内与 Claude Code CLI 交互（需 Emacs 30+，并已安装 `claude` CLI）。

| 按键 | 功能 |
|---|---|
| `C-c c c` | 启动 Claude（项目根目录） |
| `C-c c m` | transient 命令菜单 |
| `C-c c t` | 显示/隐藏 Claude 窗口 |
| `C-c c s` | 从 minibuffer 发送命令 |
| `C-c c x` | 发送命令（附带文件名和行号上下文） |
| `C-c c r` | 发送选中 region（无选中则发送整个 buffer） |
| `C-c c o` | 发送当前 buffer 对应的文件 |
| `C-c c e` | 修复光标处 flymake/flycheck 错误 |
| `C-c c k` | 结束 Claude 进程并关闭窗口 |

- 终端后端为 **eat**（纯 Elisp，无需编译，Windows/Linux/macOS 通用）；如需更快可改 `claude-code-terminal-backend` 为 `vterm`（需编译原生模块，不支持 Windows）或 `ghostel`
- 完成任务后按平台自动发桌面通知（macOS: osascript / Linux: notify-send / Windows: PowerShell toast）
- 依赖：`inheritenv`、`eat`、`transient`（均由 straight.el 自动安装）

---

## 包管理与更新

本配置使用两套包管理器：

| 管理器 | 目录 | 管理的包 |
|---|---|---|
| straight.el | `straight/` | corfu、compat、use-package 等（`:straight` 声明） |
| package.el | `elpa/` | evil、treemacs、consult、embark 等大部分包（`:ensure t` 声明） |

### 更新全部插件

```bash
# 更新 straight 管理的包（拉取 + 重建）
emacs --batch -l ~/.emacs.d/init.el \
  --eval "(progn (straight-pull-all) (straight-rebuild-all))"

# 更新 package.el 管理的包
emacs --batch -l ~/.emacs.d/init.el \
  --eval "(progn (package-refresh-contents) (package-upgrade-all))"
```

### 启用/禁用模块

编辑 `init-early.el`，注释或取消注释对应的 `(require 'init-xxx)` 行。

---

## 已知注意事项

1. **启动时自动全屏**（`toggle-frame-fullscreen`），如不喜欢改为 `toggle-frame-maximized`（`init-basic.el:38-41`）。
3. 窗口透明度 90%，在 `init-basic.el:35` 调整。
4. 字号 16pt（`init-basic.el:108` 的 `:height 160`）。
5. 不自动保存、不生成备份和 lock 文件（`init-basic.el:77-83`），重要内容注意手动 `:w`。
6. macOS 终端启动若出现 `TSM ... CapsLockLED` / `IMKCFRunLoopWakeUp` 日志，属系统正常噪音，非配置错误。
