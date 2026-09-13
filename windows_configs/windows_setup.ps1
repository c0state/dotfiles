[CmdletBinding()]
param()

$ErrorActionPreference = "Stop"

$wingetUpdateScript = Join-Path -Path $PSScriptRoot -ChildPath "winget_update.ps1"
$wslSetupScript = Join-Path -Path $PSScriptRoot -ChildPath "wsl_setup.ps1"
$profileSource = Join-Path -Path $PSScriptRoot -ChildPath "Microsoft.PowerShell_profile.ps1"
$dotfilesRoot = Split-Path -Path $PSScriptRoot -Parent
$failures = [System.Collections.Generic.List[string]]::new()

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
    )

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

    exit $elevatedProcess.ExitCode
}

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

function Link-GitConfig {
    param(
        [Parameter(Mandatory = $true)]
        [string]$DotfilesRoot
    )

    $links = @(
        @{
            Path = Join-Path -Path $HOME -ChildPath ".gitconfig"
            Target = Join-Path -Path $DotfilesRoot -ChildPath ".gitconfig-windows"
        }
        @{
            Path = Join-Path -Path $HOME -ChildPath ".gitconfig-base"
            Target = Join-Path -Path $DotfilesRoot -ChildPath ".gitconfig-base"
        }
    )

    foreach ($link in $links) {
        if (-not (Test-Path -LiteralPath $link.Target -PathType Leaf)) {
            throw "Git config source was not found: $($link.Target)"
        }

        New-Item `
            -ItemType SymbolicLink `
            -Path $link.Path `
            -Target $link.Target `
            -Force | Out-Null
        Write-Host "Linked Git config: $($link.Path)"
    }
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

foreach ($path in @($wingetUpdateScript, $wslSetupScript, $profileSource)) {
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

Invoke-NativeCommand `
    -FilePath $powershellPath `
    -ArgumentList $wingetArguments `
    -Description "Installing WinGet packages"

$env:Path = @(
    $env:Path
    [Environment]::GetEnvironmentVariable("Path", "Machine")
    [Environment]::GetEnvironmentVariable("Path", "User")
) -join ";"

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

$capsLockToControl = [byte[]]@(
    0x00, 0x00, 0x00, 0x00,   # header
    0x1D, 0x00, 0x00, 0x00,   # send: Left Ctrl
    0x3A, 0x00, 0x00, 0x00,   # when: Caps Lock
    0x00, 0x00, 0x00, 0x00    # terminator
)
Set-ScancodeMap -Value $capsLockToControl -Description "Caps Lock -> Left Ctrl"

Link-PowerShellProfile -SourcePath $profileSource
Link-GitConfig -DotfilesRoot $dotfilesRoot

if ($failures.Count -gt 0) {
    Write-Host "`nWindows setup completed with failures:" -ForegroundColor Red
    foreach ($failure in $failures) {
        Write-Host "- $failure" -ForegroundColor Red
    }
    exit 1
}

Write-Host "`nWindows setup completed successfully."
