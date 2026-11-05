[CmdletBinding()]
param(
    [Parameter(Mandatory = $true, Position = 0)]
    [ValidatePattern("^[A-Za-z][A-Za-z0-9_-]*$")]
    [string]$Name,
    [string]$Destination,
    [switch]$NoBuild
)

$ErrorActionPreference = "Stop"
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
$scriptRoot = if ($PSScriptRoot) {
    $PSScriptRoot
} elseif ($MyInvocation.MyCommand.Path) {
    Split-Path -Parent $MyInvocation.MyCommand.Path
} else {
    (Get-Location).Path
}
if (-not $Destination) {
    $Destination = Split-Path -Parent $scriptRoot
}

$words = [regex]::Replace($Name, "([a-z0-9])([A-Z])", '$1 $2') -split "[^A-Za-z0-9]+" |
    Where-Object { $_ }
$snakeName = ($words | ForEach-Object { $_.ToLowerInvariant() }) -join "_"
$pascalName = ($words | ForEach-Object {
    $_.Substring(0, 1).ToUpperInvariant() + $_.Substring(1).ToLowerInvariant()
}) -join ""
$appStructName = if ($pascalName.EndsWith("App")) { $pascalName } else { "${pascalName}App" }

$Destination = [IO.Path]::GetFullPath($Destination)
if (-not (Test-Path -LiteralPath $Destination)) {
    New-Item -ItemType Directory -Path $Destination | Out-Null
}

$targetDir = Join-Path $Destination $Name
if (Test-Path -LiteralPath $targetDir) {
    throw "目标目录已存在，未覆盖：$targetDir"
}

New-Item -ItemType Directory -Path $targetDir | Out-Null

foreach ($item in @("Cargo.toml", "Cargo.lock", "build.rs", "gpui_ready.rc", "src", "icons")) {
    Copy-Item -LiteralPath (Join-Path $scriptRoot $item) -Destination $targetDir -Recurse
}

$textExtensions = @(".rs", ".toml", ".rc")
$utf8 = New-Object System.Text.UTF8Encoding($false)
Get-ChildItem -LiteralPath $targetDir -Recurse -File |
    Where-Object { $textExtensions -contains $_.Extension.ToLowerInvariant() } |
    ForEach-Object {
        $content = [IO.File]::ReadAllText($_.FullName)
        $content = $content.Replace('.child("maloo")', '.child("' + $pascalName + '")')
        $content = $content.Replace('set_window_title("maloo")', 'set_window_title("' + $pascalName + '")')
        $content = $content.Replace("MalooApp", $appStructName)
        $content = $content.Replace("gpui_ready.rc", "$snakeName.rc")
        $content = $content.Replace("Maloo", $pascalName).Replace("maloo", $snakeName)
        [IO.File]::WriteAllText($_.FullName, $content, $utf8)
    }

Rename-Item -LiteralPath (Join-Path $targetDir "gpui_ready.rc") -NewName "$snakeName.rc"

if (-not $NoBuild) {
    Push-Location $targetDir
    try {
        & cargo fmt
        if ($LASTEXITCODE -ne 0) { throw "cargo fmt 失败" }
        & cargo build
        if ($LASTEXITCODE -ne 0) { throw "cargo build 失败" }
    } finally {
        Pop-Location
    }
}

Write-Output "项目已创建：$targetDir"
Write-Output "包名：$snakeName"
Write-Output "应用结构体：$appStructName"
Write-Output "窗口标题：$pascalName"
if (-not $NoBuild) {
    Write-Output "运行：cargo run --manifest-path `"$targetDir\Cargo.toml`""
}
