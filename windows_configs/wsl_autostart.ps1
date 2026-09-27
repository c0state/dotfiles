[CmdletBinding()]
param()

$ErrorActionPreference = "Stop"

$taskName = "WSL Autostart"
$taskDescription = "Starts the WSL distribution at logon and keeps it running so systemd services stay up."
$wslDistribution = "Ubuntu"
$failures = [System.Collections.Generic.List[string]]::new()

if (-not (Get-Command -Name "wsl.exe" -ErrorAction SilentlyContinue)) {
    throw "wsl.exe was not found. Windows Subsystem for Linux is unavailable."
}

$installedDistributions = @(
    & wsl.exe --list --quiet 2>$null |
        ForEach-Object { $_.ToString() -replace "[\u0000\uFEFF]", "" } |
        ForEach-Object { $_.Trim() } |
        Where-Object { $_ }
)

$distributionPattern = "^{0}(?:[-.]|$)" -f [regex]::Escape($wslDistribution)
$distributionName = @(
    $installedDistributions |
        Where-Object { $_ -match $distributionPattern }
) | Select-Object -First 1

if (-not $distributionName) {
    throw "WSL distribution is not installed: $wslDistribution. Run wsl_setup.ps1 first."
}

$scheduledAction = New-ScheduledTaskAction `
    -Execute "wsl.exe" `
    -Argument "--distribution $distributionName --exec sleep infinity"

$user = "$env:USERDOMAIN\$env:USERNAME"
$trigger = New-ScheduledTaskTrigger -AtLogOn -User $user
$principal = New-ScheduledTaskPrincipal -UserId $user -LogonType Interactive
$settings = New-ScheduledTaskSettingsSet `
    -ExecutionTimeLimit ([TimeSpan]::Zero) `
    -AllowStartIfOnBatteries `
    -DontStopIfGoingOnBatteries

$existingTask = Get-ScheduledTask -TaskName $taskName -ErrorAction SilentlyContinue
if ($existingTask) {
    $existingAction = @($existingTask.Actions)[0]
    if ($existingAction.Execute -ieq "wsl.exe" -and $existingAction.Arguments -eq $scheduledAction.Arguments) {
        Write-Host "Scheduled task already configured: $taskName"
        exit 0
    }

    try {
        Unregister-ScheduledTask -TaskName $taskName -Confirm:$false
        Write-Host "Removed outdated scheduled task: $taskName"
    } catch {
        Write-Error "Failed to remove outdated scheduled task ${taskName}: $($_.Exception.Message)"
        exit 1
    }
}

try {
    Register-ScheduledTask `
        -TaskName $taskName `
        -Description $taskDescription `
        -Action $scheduledAction `
        -Trigger $trigger `
        -Principal $principal `
        -Settings $settings | Out-Null
    Write-Host "Registered scheduled task: $taskName"
} catch {
    Write-Error "Failed to register scheduled task ${taskName}: $($_.Exception.Message)"
    exit 1
}

try {
    Start-ScheduledTask -TaskName $taskName
    Write-Host "Started scheduled task: $taskName"
} catch {
    [void]$failures.Add("Failed to start scheduled task ${taskName}: $($_.Exception.Message)")
}

if ($failures.Count -gt 0) {
    Write-Host "`nWSL autostart setup completed with failures:" -ForegroundColor Red
    foreach ($failure in $failures) {
        Write-Host "- $failure" -ForegroundColor Red
    }
    exit 1
}

Write-Host "`nWSL autostart setup completed successfully."
