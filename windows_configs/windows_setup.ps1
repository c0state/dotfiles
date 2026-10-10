[CmdletBinding()]
param(
    [switch]$SkipWinget,
    [string]$TranscriptPath
)

$ErrorActionPreference = "Stop"

$wingetUpdateScript = Join-Path -Path $PSScriptRoot -ChildPath "winget_update.ps1"
$wslSetupScript = Join-Path -Path $PSScriptRoot -ChildPath "wsl_setup.ps1"
$wslAutostartScript = Join-Path -Path $PSScriptRoot -ChildPath "wsl_autostart.ps1"
$profileSource = Join-Path -Path $PSScriptRoot -ChildPath "Microsoft.PowerShell_profile.ps1"
$powerToysSetupScript = Join-Path -Path $PSScriptRoot -ChildPath "powertoys_setup.ps1"
$dotfilesRoot = Split-Path -Path $PSScriptRoot -Parent
$failures = [System.Collections.Generic.List[string]]::new()

if ([string]::IsNullOrWhiteSpace($TranscriptPath)) {
    $TranscriptPath = Join-Path -Path $env:TEMP -ChildPath "windows-setup-$([guid]::NewGuid().ToString('N')).txt"
}

$transcriptDirectory = Split-Path -Path $TranscriptPath -Parent
if ($transcriptDirectory -and -not (Test-Path -LiteralPath $transcriptDirectory -PathType Container)) {
    New-Item -ItemType Directory -Path $transcriptDirectory -Force | Out-Null
}

function Test-IsAdministrator {
    $identity = [Security.Principal.WindowsIdentity]::GetCurrent()
    $principal = [Security.Principal.WindowsPrincipal]::new($identity)
    return $principal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
}

if (-not (Test-IsAdministrator)) {
    $powershellName = if ($PSVersionTable.PSEdition -eq "Core") {
        "pwsh.exe"
    } else {
        "powershell.exe"
    }

    $powershellPath = Join-Path -Path $PSHOME -ChildPath $powershellName
    $elevatedArguments = @(
        "-NoProfile"
        "-ExecutionPolicy"
        "Bypass"
        "-File"
        "`"$PSCommandPath`""
        "-TranscriptPath"
        "`"$TranscriptPath`""
    )
    if ($SkipWinget) {
        $elevatedArguments += "-SkipWinget"
    }

    try {
        $elevatedProcess = Start-Process `
            -FilePath $powershellPath `
            -Verb RunAs `
            -ArgumentList $elevatedArguments `
            -Wait `
            -PassThru
    } catch {
        Write-Error "Administrator elevation was canceled or failed: $($_.Exception.Message)"
        exit 1
    }

    if (Test-Path -LiteralPath $TranscriptPath -PathType Leaf) {
        Write-Host "`nElevated setup transcript: $TranscriptPath"
        Get-Content -LiteralPath $TranscriptPath
    }

    exit $elevatedProcess.ExitCode
}

Start-Transcript -Path $TranscriptPath -Force | Out-Null
Write-Host "Windows setup transcript: $TranscriptPath"

function Invoke-NativeCommand {
    param(
        [Parameter(Mandatory = $true)]
        [string]$FilePath,

        [Parameter(Mandatory = $true)]
        [string[]]$ArgumentList,

        [Parameter(Mandatory = $true)]
        [string]$Description
    )

    Write-Host "`n$Description"

    try {
        & $FilePath @ArgumentList
        $exitCode = $LASTEXITCODE
    } catch {
        [void]$failures.Add("${Description}: $($_.Exception.Message)")
        return
    }

    if ($exitCode -ne 0) {
        [void]$failures.Add("$Description exited with code $exitCode")
    }
}

function Link-PowerShellProfile {
    param(
        [Parameter(Mandatory = $true)]
        [string]$SourcePath
    )

    if (-not (Test-Path -LiteralPath $SourcePath -PathType Leaf)) {
        throw "PowerShell profile source was not found: $SourcePath"
    }

    $profilePath = $PROFILE
    $profileDirectory = Split-Path -Path $profilePath -Parent
    New-Item -ItemType Directory -Path $profileDirectory -Force | Out-Null
    New-Item -ItemType SymbolicLink -Path $profilePath -Target $SourcePath -Force | Out-Null
    Write-Host "Linked PowerShell profile: $profilePath"
}

function Link-CodexProfile {
    param(
        [Parameter(Mandatory = $true)]
        [string]$DotfilesRoot
    )

    $profileSource = Join-Path -Path $DotfilesRoot -ChildPath ".codex\windows.config.toml"
    if (-not (Test-Path -LiteralPath $profileSource -PathType Leaf)) {
        throw "Codex profile source was not found: $profileSource"
    }

    $profileDirectory = Join-Path -Path $HOME -ChildPath ".codex"
    New-Item -ItemType Directory -Path $profileDirectory -Force | Out-Null

    $profilePath = Join-Path -Path $profileDirectory -ChildPath "windows.config.toml"
    $backupPath = "$profilePath.local"
    $existingProfile = Get-Item -LiteralPath $profilePath -Force -ErrorAction SilentlyContinue
    if ($existingProfile) {
        if (
            $existingProfile.LinkType -eq "SymbolicLink" -and
            $existingProfile.Target -eq $profileSource
        ) {
            Write-Host "Codex profile already linked: $profilePath"
            return
        }

        $existingBackup = Get-Item -LiteralPath $backupPath -Force -ErrorAction SilentlyContinue
        if ($existingBackup) {
            throw "Cannot replace $profilePath: backup already exists at $backupPath"
        }

        Move-Item -LiteralPath $profilePath -Destination $backupPath
    }

    New-Item `
        -ItemType SymbolicLink `
        -Path $profilePath `
        -Target $profileSource `
        -Force | Out-Null
    Write-Host "Linked Codex profile: $profilePath"
}

function Link-GitConfig {
    param(
        [Parameter(Mandatory = $true)]
        [string]$DotfilesRoot
    )

    $gitConfigDirectory = Join-Path -Path $HOME -ChildPath ".config\git"
    New-Item -ItemType Directory -Path $gitConfigDirectory -Force | Out-Null

    $links = @(
        @{
            Path = Join-Path -Path $gitConfigDirectory -ChildPath "config"
            Target = Join-Path -Path $DotfilesRoot -ChildPath ".config\git\.gitconfig-windows"
        }
        @{
            Path = Join-Path -Path $gitConfigDirectory -ChildPath ".gitconfig-base"
            Target = Join-Path -Path $DotfilesRoot -ChildPath ".config\git\.gitconfig-base"
        }
    )

    foreach ($link in $links) {
        if (-not (Test-Path -LiteralPath $link.Target -PathType Leaf)) {
            throw "Git config source was not found: $($link.Target)"
        }

        $existingLink = Get-Item -LiteralPath $link.Path -Force -ErrorAction SilentlyContinue
        if ($existingLink) {
            if ($existingLink.PSIsContainer -and $existingLink.LinkType -ne "SymbolicLink") {
                throw "Cannot replace a directory with a Git config link: $($link.Path)"
            }

            Remove-Item -LiteralPath $link.Path -Force
        }

        New-Item `
            -ItemType SymbolicLink `
            -Path $link.Path `
            -Target $link.Target `
            -Force | Out-Null
        Write-Host "Linked Git config: $($link.Path)"
    }

    foreach ($legacyPath in @(
        (Join-Path -Path $HOME -ChildPath ".gitconfig")
        (Join-Path -Path $HOME -ChildPath ".gitconfig-base")
    )) {
        $legacyLink = Get-Item -LiteralPath $legacyPath -Force -ErrorAction SilentlyContinue
        if (
            $legacyLink -and
            $legacyLink.LinkType -eq "SymbolicLink" -and
            (Split-Path -Path $legacyLink.Target -Leaf) -in @(".gitconfig-windows", ".gitconfig-base")
        ) {
            Remove-Item -LiteralPath $legacyPath -Force
        }
    }
}

function Link-NeovimConfig {
    param(
        [Parameter(Mandatory = $true)]
        [string]$DotfilesRoot
    )

    $configSource = Join-Path -Path $DotfilesRoot -ChildPath ".config\nvim"
    $configPath = Join-Path -Path $env:LOCALAPPDATA -ChildPath "nvim"

    if (-not (Test-Path -LiteralPath $configSource -PathType Container)) {
        throw "Neovim config source was not found: $configSource"
    }

    $existingConfig = Get-Item -LiteralPath $configPath -Force -ErrorAction SilentlyContinue
    if ($existingConfig) {
        if (
            $existingConfig.LinkType -eq "SymbolicLink" -and
            $existingConfig.Target -eq $configSource
        ) {
            Write-Host "Neovim config already linked: $configPath"
            return
        }

        [void]$failures.Add("Neovim config was not linked because a path already exists: $configPath")
        return
    }

    New-Item `
        -ItemType SymbolicLink `
        -Path $configPath `
        -Target $configSource `
        -Force | Out-Null
    Write-Host "Linked Neovim config: $configPath"
}

function Install-WindowsTerminalFragment {
    param(
        [Parameter(Mandatory = $true)]
        [string]$SourcePath
    )

    if (-not (Test-Path -LiteralPath $SourcePath -PathType Leaf)) {
        throw "Windows Terminal fragment source was not found: $SourcePath"
    }

    # Windows Terminal merges (never rewrites) files in this directory into the
    # user's settings.json. This is the supported way to version-control
    # settings: https://learn.microsoft.com/windows/terminal/settings#settings-files
    $fragmentDirectory = Join-Path -Path $env:LOCALAPPDATA -ChildPath `
        "Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalSettings\settings\LocalSettings"
    New-Item -ItemType Directory -Path $fragmentDirectory -Force | Out-Null

    $fragmentPath = Join-Path -Path $fragmentDirectory -ChildPath (Split-Path -Path $SourcePath -Leaf)

    Copy-Item -LiteralPath $SourcePath -Destination $fragmentPath -Force
    Write-Host "Windows Terminal fragment installed: $fragmentPath"
}

function Set-ScancodeMap {
    param(
        [Parameter(Mandatory = $true)]
        [byte[]]$Value,

        [Parameter(Mandatory = $true)]
        [string]$Description
    )

    $registryPath = "HKLM:\SYSTEM\CurrentControlSet\Control\Keyboard Layout"
    $valueName = "Scancode Map"

    try {
        $existing = Get-ItemProperty -Path $registryPath -Name $valueName -ErrorAction SilentlyContinue
        if ($existing) {
            $current = $existing.PSObject.Properties[$valueName].Value
            if ($current -is [byte[]] -and ($current -join ",") -eq ($Value -join ",")) {
                Write-Host "Scancode map already configured: $Description"
                return
            }
        }

        Set-ItemProperty -Path $registryPath -Name $valueName -Value $Value -Type Binary
        Write-Host "Scancode map updated: $Description (a reboot is required for it to take effect)"
    } catch {
        [void]$failures.Add("${Description}: $($_.Exception.Message)")
    }
}

$requiredSources = @($wslSetupScript, $wslAutostartScript, $profileSource)
if (-not $SkipWinget) {
    $requiredSources += @($wingetUpdateScript, $powerToysSetupScript)
}

foreach ($path in $requiredSources) {
    if (-not (Test-Path -LiteralPath $path -PathType Leaf)) {
        throw "Windows setup source was not found: $path"
    }
}

$powershellName = if ($PSVersionTable.PSEdition -eq "Core") {
    "pwsh.exe"
} else {
    "powershell.exe"
}
$powershellPath = Join-Path -Path $PSHOME -ChildPath $powershellName

$wslArguments = @(
    "-NoProfile"
    "-ExecutionPolicy"
    "Bypass"
    "-File"
    $wslSetupScript
)

$wingetArguments = @(
    "-NoProfile"
    "-ExecutionPolicy"
    "Bypass"
    "-File"
    $wingetUpdateScript
)

Invoke-NativeCommand `
    -FilePath $powershellPath `
    -ArgumentList $wslArguments `
    -Description "Setting up WSL distributions"

$wslAutostartArguments = @(
    "-NoProfile"
    "-ExecutionPolicy"
    "Bypass"
    "-File"
    $wslAutostartScript
)

Invoke-NativeCommand `
    -FilePath $powershellPath `
    -ArgumentList $wslAutostartArguments `
    -Description "Registering WSL autostart scheduled task"

if ($SkipWinget) {
    Write-Host "`nSkipping WinGet package installation and PowerToys configuration"
} else {
    Invoke-NativeCommand `
        -FilePath $powershellPath `
        -ArgumentList $wingetArguments `
        -Description "Installing WinGet packages"
}

$env:Path = @(
    $env:Path
    [Environment]::GetEnvironmentVariable("Path", "Machine")
    [Environment]::GetEnvironmentVariable("Path", "User")
) -join ";"

if (-not $SkipWinget) {
    $powerToysArguments = @(
        "-NoProfile"
        "-ExecutionPolicy"
        "Bypass"
        "-File"
        $powerToysSetupScript
    )

    Invoke-NativeCommand `
        -FilePath $powershellPath `
        -ArgumentList $powerToysArguments `
        -Description "Applying PowerToys configuration"
}

Invoke-NativeCommand `
    -FilePath "npm.cmd" `
    -ArgumentList @(
        "install",
        "--global",
        "git-split-diffs@latest"
    ) `
    -Description "Installing/updating git-split-diffs"

Invoke-NativeCommand `
    -FilePath "npm.cmd" `
    -ArgumentList @(
        "install",
        "--global",
        "@google/gemini-cli@latest"
    ) `
    -Description "Installing/updating Gemini CLI"

Invoke-NativeCommand `
    -FilePath "npm.cmd" `
    -ArgumentList @(
        "install",
        "--global",
        "--ignore-scripts",
        "@earendil-works/pi-coding-agent@latest"
    ) `
    -Description "Installing/updating Pi coding harness"

if (-not (Get-Command -Name "muse" -ErrorAction SilentlyContinue)) {
    Write-Host "`nInstalling Muse Code"
    try {
        Invoke-RestMethod -Uri "https://dev.meta.ai/install.ps1" | Invoke-Expression
    } catch {
        [void]$failures.Add("Installing Muse Code: $($_.Exception.Message)")
    }
}

$capsLockToControl = [byte[]]@(
    0x00, 0x00, 0x00, 0x00,   # version
    0x00, 0x00, 0x00, 0x00,   # flags
    0x02, 0x00, 0x00, 0x00,   # mapping count, including terminator
    0x1D, 0x00, 0x3A, 0x00,   # new: Left Ctrl, old: Caps Lock
    0x00, 0x00, 0x00, 0x00    # terminator
)
Set-ScancodeMap -Value $capsLockToControl -Description "Caps Lock -> Left Ctrl"

$terminalFragmentSource = Join-Path -Path $PSScriptRoot -ChildPath "windows_terminal_config.json"

Link-PowerShellProfile -SourcePath $profileSource
Link-CodexProfile -DotfilesRoot $dotfilesRoot
Link-GitConfig -DotfilesRoot $dotfilesRoot
Link-NeovimConfig -DotfilesRoot $dotfilesRoot
Install-WindowsTerminalFragment -SourcePath $terminalFragmentSource

if ($failures.Count -gt 0) {
    Write-Host "`nWindows setup completed with failures:" -ForegroundColor Red
    foreach ($failure in $failures) {
        Write-Host "- $failure" -ForegroundColor Red
    }
    Stop-Transcript | Out-Null
    exit 1
}

Write-Host "`nWindows setup completed successfully."
Stop-Transcript | Out-Null
