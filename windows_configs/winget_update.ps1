[CmdletBinding()]
param()

$ErrorActionPreference = "Stop"

$importFile = Join-Path -Path $PSScriptRoot -ChildPath "winget_import.json"
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

if (-not (Test-Path -LiteralPath $importFile -PathType Leaf)) {
    throw "WinGet import file was not found: $importFile"
}

Install-WinGetPackages -ImportFile $importFile

if ($failures.Count -gt 0 -or $wingetPackageFailures.Count -gt 0) {
    Write-Host "`nWinGet package setup completed with failures:" -ForegroundColor Red
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

Write-Host "`nWinGet package setup completed successfully."
