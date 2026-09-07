[CmdletBinding()]
param()

$ErrorActionPreference = "Stop"

$importFile = Join-Path -Path $PSScriptRoot -ChildPath "winget_import.json"
$wslSetupScript = Join-Path -Path $PSScriptRoot -ChildPath "wsl_setup.ps1"
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

if (-not (Test-Path -LiteralPath $importFile -PathType Leaf)) {
    throw "WinGet import file was not found: $importFile"
}

if (-not (Test-Path -LiteralPath $wslSetupScript -PathType Leaf)) {
    throw "WSL setup script was not found: $wslSetupScript"
}

$wslArguments = @(
    "-NoProfile"
    "-ExecutionPolicy"
    "Bypass"
    "-File"
    $wslSetupScript
)

Invoke-NativeCommand `
    -FilePath "powershell.exe" `
    -ArgumentList $wslArguments `
    -Description "Setting up WSL distributions"

Invoke-NativeCommand `
    -FilePath "winget.exe" `
    -ArgumentList @(
        "import",
        "--import-file",
        $importFile,
        "--accept-source-agreements",
        "--accept-package-agreements",
        "--disable-interactivity"
    ) `
    -Description "Importing WinGet packages"

if ($failures.Count -gt 0) {
    Write-Host "`nBootstrap completed with failures:" -ForegroundColor Red
    foreach ($failure in $failures) {
        Write-Host "- $failure" -ForegroundColor Red
    }
    exit 1
}

Write-Host "`nBootstrap completed successfully."
