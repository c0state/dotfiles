[CmdletBinding()]
param()

$ErrorActionPreference = "Stop"
$wslDistributions = @(
    "Ubuntu"
)
$failures = [System.Collections.Generic.List[string]]::new()

function Invoke-NativeCommand {
    param(
        [Parameter(Mandatory = $true)]
        [string]$FilePath,

        [Parameter(Mandatory = $true)]
        [string[]]$ArgumentList,

        [Parameter(Mandatory = $true)]
        [string]$Description,

        [Parameter(Mandatory = $false)]
        [scriptblock]$AcceptFailure
    )

    Write-Host "`n$Description"

    try {
        & $FilePath @ArgumentList | ForEach-Object { Write-Host $_ }
        $exitCode = $LASTEXITCODE
    } catch {
        if ($AcceptFailure -and (& $AcceptFailure)) {
            return $true
        }

        [void]$failures.Add("${Description}: $($_.Exception.Message)")
        return $false
    }

    if ($exitCode -ne 0) {
        if ($AcceptFailure -and (& $AcceptFailure)) {
            return $true
        }

        [void]$failures.Add("$Description exited with code $exitCode")
        return $false
    }

    return $true
}

function Get-InstalledDistributionNames {
    $output = @(& wsl.exe --list --quiet 2>$null)
    $exitCode = $LASTEXITCODE
    $names = @(
        $output |
            ForEach-Object { $_.ToString() -replace "[\u0000\uFEFF]", "" } |
            ForEach-Object { $_.Trim() } |
            Where-Object { $_ }
    )

    [PSCustomObject]@{
        ExitCode = $exitCode
        Names    = $names
    }
}

function Test-DistributionInstalled {
    param(
        [Parameter(Mandatory = $true)]
        [string]$DistributionName,

        [Parameter(Mandatory = $true)]
        [System.Collections.Generic.List[string]]$InstalledDistributions
    )

    $distributionPattern = "^{0}(?:[-.]|$)" -f [regex]::Escape($DistributionName)
    $matchingDistributions = @($InstalledDistributions | Where-Object {
        $_ -match $distributionPattern
    })
    return $matchingDistributions.Count -gt 0
}

if (-not (Get-Command -Name "wsl.exe" -ErrorAction SilentlyContinue)) {
    throw "wsl.exe was not found. Windows Subsystem for Linux is unavailable."
}

$wslState = Get-InstalledDistributionNames
$installedDistributions = [System.Collections.Generic.List[string]]::new()
foreach ($name in $wslState.Names) {
    [void]$installedDistributions.Add($name)
}

if ($installedDistributions.Count -gt 0) {
    Invoke-NativeCommand `
        -FilePath "wsl.exe" `
        -ArgumentList @( "--update" ) `
        -Description "Updating WSL"
}

foreach ($requestedDistribution in $wslDistributions) {
    if (Test-DistributionInstalled `
        -DistributionName $requestedDistribution `
        -InstalledDistributions $installedDistributions) {
        Write-Host "WSL distribution already installed: $requestedDistribution"
        continue
    }

    $installed = Invoke-NativeCommand `
        -FilePath "wsl.exe" `
        -ArgumentList @(
            "--install"
            "--distribution"
            $requestedDistribution
            "--no-launch"
        ) `
        -Description "Installing WSL distribution: $requestedDistribution" `
        -AcceptFailure {
            $currentState = Get-InstalledDistributionNames
            $currentNames = [System.Collections.Generic.List[string]]::new()
            foreach ($name in $currentState.Names) {
                [void]$currentNames.Add($name)
            }

            if (Test-DistributionInstalled `
                -DistributionName $requestedDistribution `
                -InstalledDistributions $currentNames) {
                Write-Host "WSL distribution already installed: $requestedDistribution"
                return $true
            }

            return $false
        }

    if ($installed) {
        [void]$installedDistributions.Add($requestedDistribution)
    }
}

if ($failures.Count -gt 0) {
    Write-Host "`nWSL setup completed with failures:" -ForegroundColor Red
    foreach ($failure in $failures) {
        Write-Host "- $failure" -ForegroundColor Red
    }
    exit 1
}

Write-Host "`nWSL setup completed successfully."
