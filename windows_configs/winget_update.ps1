[CmdletBinding()]
param()

$ErrorActionPreference = "Stop"

$importFile = Join-Path -Path $PSScriptRoot -ChildPath "winget_import.json"
$wslSetupScript = Join-Path -Path $PSScriptRoot -ChildPath "wsl_setup.ps1"
$profileSource = Join-Path -Path $PSScriptRoot -ChildPath "Microsoft.PowerShell_profile.ps1"
$failures = [System.Collections.Generic.List[string]]::new()
$wingetPackageFailures = [System.Collections.Generic.List[psobject]]::new()

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

function Install-WinGetPackages {
    param(
        [Parameter(Mandatory = $true)]
        [string]$ImportFile
    )

    $import = Get-Content -LiteralPath $ImportFile -Raw | ConvertFrom-Json

    foreach ($source in $import.Sources) {
        $sourceName = $source.SourceDetails.Name
        if ([string]::IsNullOrWhiteSpace($sourceName)) {
            [void]$failures.Add("WinGet import source is missing a name")
            continue
        }

        foreach ($package in $source.Packages) {
            $packageIdentifier = $package.PackageIdentifier
            if ([string]::IsNullOrWhiteSpace($packageIdentifier)) {
                [void]$wingetPackageFailures.Add([pscustomobject]@{
                    PackageIdentifier = "<missing identifier>"
                    Source = $sourceName
                    ExitCode = $null
                    Error = "PackageIdentifier is required"
                })
                continue
            }

            Write-Host "`nInstalling WinGet package: $packageIdentifier (source: $sourceName)"

            try {
                & winget.exe install `
                    --id $packageIdentifier `
                    --exact `
                    --source $sourceName `
                    --accept-source-agreements `
                    --accept-package-agreements `
                    --disable-interactivity
                $exitCode = $LASTEXITCODE
            } catch {
                [void]$wingetPackageFailures.Add([pscustomobject]@{
                    PackageIdentifier = $packageIdentifier
                    Source = $sourceName
                    ExitCode = $null
                    Error = $_.Exception.Message
                })
                continue
            }

            if ($exitCode -ne 0) {
                [void]$wingetPackageFailures.Add([pscustomobject]@{
                    PackageIdentifier = $packageIdentifier
                    Source = $sourceName
                    ExitCode = $exitCode
                    Error = $null
                })
            }
        }
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

Install-WinGetPackages -ImportFile $importFile

$capsLockToControl = [byte[]]@(
    0x00, 0x00, 0x00, 0x00,   # header
    0x1D, 0x00, 0x00, 0x00,   # send: Left Ctrl
    0x3A, 0x00, 0x00, 0x00,   # when: Caps Lock
    0x00, 0x00, 0x00, 0x00    # terminator
)
Set-ScancodeMap -Value $capsLockToControl -Description "Caps Lock -> Left Ctrl"

Link-PowerShellProfile -SourcePath $profileSource

if ($failures.Count -gt 0 -or $wingetPackageFailures.Count -gt 0) {
    Write-Host "`nBootstrap completed with failures:" -ForegroundColor Red
    foreach ($failure in $failures) {
        Write-Host "- $failure" -ForegroundColor Red
    }

    if ($wingetPackageFailures.Count -gt 0) {
        Write-Host "`nWinGet packages that failed:" -ForegroundColor Red
        foreach ($packageFailure in $wingetPackageFailures) {
            if ($null -ne $packageFailure.ExitCode) {
                Write-Host "- $($packageFailure.PackageIdentifier) (source: $($packageFailure.Source)): exited with code $($packageFailure.ExitCode)" -ForegroundColor Red
            } else {
                Write-Host "- $($packageFailure.PackageIdentifier) (source: $($packageFailure.Source)): $($packageFailure.Error)" -ForegroundColor Red
            }
        }
    }

    exit 1
}

Write-Host "`nBootstrap completed successfully."
