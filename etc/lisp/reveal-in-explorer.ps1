# 在资源管理器中打开 PATH 所在文件夹并选中该文件/目录。
# 由 init-treemacs.el 的 my/treemacs-reveal-in-explorer 调用：
#   powershell -NoProfile -ExecutionPolicy Bypass -File <this> -Path <path>
# 用 Shell.Application COM 而非 explorer /select,：后者对参数格式极其
# 挑剔（Emacs start-process 会转义引号、部分 Win11 场景直接忽略），
# COM SelectItem 是系统级 API，行为稳定。
param([string]$Path)
$ErrorActionPreference = 'Stop'
try {
    $full = (Resolve-Path -LiteralPath $Path).Path
    $dir = Split-Path -Parent $full
    $sh = New-Object -ComObject Shell.Application
    $null = $sh.Open($dir)
    Start-Sleep -Milliseconds 800
    # 优先找刚打开的那个文件夹窗口（LocationURL 为 file:/// URI）
    $win = $null
    foreach ($w in $sh.Windows()) {
        try {
            if ($w.LocationURL -and ($w.LocationURL -ieq ([System.Uri]$dir).AbsoluteUri)) { $win = $w }
        } catch {}
    }
    if (-not $win) { $win = $sh.Windows() | Select-Object -Last 1 }
    if ($win -and $win.Document) {
        $item = $win.Document.Folder.Items() | Where-Object { $_.Path -ieq $full } | Select-Object -First 1
        if ($item) {
            # 0x1D = 选中 | 取消其他选中 | 确保可见 | 聚焦
            $win.Document.SelectItem($item, 0x1D)
            Write-Output "SELECTED=$full"
        } else {
            Write-Output "ITEM_NOT_FOUND=$full"
        }
    } else {
        Write-Output "WINDOW_NOT_FOUND"
    }
} catch {
    Write-Output "ERROR=$_"
}
