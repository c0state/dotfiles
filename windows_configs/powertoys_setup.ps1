[CmdletBinding()]
param()

$ErrorActionPreference = "Stop"

$powerToysDscDocument = Join-Path -Path $PSScriptRoot -ChildPath "powertoys.dsc.yaml"

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

    $elevatedProcess = Start-Process `
        -FilePath $powershellPath `
        -Verb RunAs `
        -ArgumentList $elevatedArguments `
        -Wait `
        -PassThru
    exit $elevatedProcess.ExitCode
}

function Invoke-WinGetCommand {
    param(
        [Parameter(Mandatory = $true)]
        [string[]]$ArgumentList
    )

    $process = Start-Process `
        -FilePath "winget.exe" `
        -ArgumentList $ArgumentList `
        -NoNewWindow `
        -PassThru `
        -Wait

    if ($process.ExitCode -ne 0) {
        throw "winget.exe exited with code $($process.ExitCode)"
    }
}

function Set-PowerToysWindowHopper {
    $powerToysDirectory = Join-Path -Path $env:LOCALAPPDATA -ChildPath "Microsoft\PowerToys"
    $generalSettingsPath = Join-Path -Path $powerToysDirectory -ChildPath "settings.json"
    $windowHopperDirectory = Join-Path -Path $powerToysDirectory -ChildPath "AltWindowCycle"
    $windowHopperSettingsPath = Join-Path -Path $windowHopperDirectory -ChildPath "settings.json"

    if (-not (Test-Path -LiteralPath $generalSettingsPath -PathType Leaf)) {
        throw "PowerToys settings were not found: $generalSettingsPath"
    }

    $generalSettings = Get-Content -LiteralPath $generalSettingsPath -Raw | ConvertFrom-Json
    if ($null -eq $generalSettings.enabled) {
        $generalSettings | Add-Member -MemberType NoteProperty -Name "enabled" -Value ([pscustomobject]@{})
    }

    $generalSettings.enabled | Add-Member `
        -MemberType NoteProperty `
        -Name "AltWindowCycle" `
        -Value $true `
        -Force
    $generalSettings | ConvertTo-Json -Depth 100 | Set-Content -LiteralPath $generalSettingsPath -Encoding utf8

    New-Item -ItemType Directory -Path $windowHopperDirectory -Force | Out-Null

    $windowHopperSettings = [pscustomobject]@{
        name = "AltWindowCycle"
        version = "1.0"
        properties = [pscustomobject]@{
            next_window_shortcut = [pscustomobject]@{
                win = $false
                ctrl = $false
                alt = $true
                shift = $false
                code = 0xC0
                key = ""
            }
            previous_window_shortcut = [pscustomobject]@{
                win = $false
                ctrl = $false
                alt = $true
                shift = $true
                code = 0xC0
                key = ""
            }
        }
    }

    $windowHopperSettings | ConvertTo-Json -Depth 100 | Set-Content -LiteralPath $windowHopperSettingsPath -Encoding utf8
}

function Restart-PowerToys {
    $powerToys = Get-Process -Name "PowerToys" -ErrorAction SilentlyContinue
    if ($null -eq $powerToys) {
        return
    }

    $powerToysPath = Join-Path -Path $env:ProgramFiles -ChildPath "PowerToys\PowerToys.exe"
    if (-not (Test-Path -LiteralPath $powerToysPath -PathType Leaf)) {
        throw "PowerToys executable was not found: $powerToysPath"
    }

    $powerToys | Stop-Process -Force
    Start-Process -FilePath "explorer.exe" -ArgumentList "`"$powerToysPath`""
}

if (-not (Test-Path -LiteralPath $powerToysDscDocument -PathType Leaf)) {
    throw "PowerToys DSC document was not found: $powerToysDscDocument"
}

Invoke-WinGetCommand -ArgumentList @(
    "configure"
    "--file"
    $powerToysDscDocument
)

Invoke-WinGetCommand -ArgumentList @(
    "upgrade"
    "--id"
    "Microsoft.PowerToys"
    "--exact"
    "--source"
    "winget"
    "--silent"
    "--accept-package-agreements"
    "--accept-source-agreements"
)

Set-PowerToysWindowHopper
Restart-PowerToys
