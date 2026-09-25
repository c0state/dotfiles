Set-PSReadLineOption -EditMode Emacs
Set-PSReadLineKeyHandler -Chord Tab -Function MenuComplete

if (Get-Command -Name gh -ErrorAction SilentlyContinue) {
    gh completion -s powershell | Out-String | Invoke-Expression
}

if (Get-Command -Name docker -ErrorAction SilentlyContinue) {
    docker completion powershell | Out-String | Invoke-Expression
}

if (Get-Command -Name kubectl -ErrorAction SilentlyContinue) {
    kubectl completion powershell | Out-String | Invoke-Expression
}

if (Get-Command -Name codex -ErrorAction SilentlyContinue) {
    codex completion powershell | Out-String | Invoke-Expression
}

if (Get-Command -Name oh-my-posh -ErrorAction SilentlyContinue) {
    oh-my-posh init pwsh --strict --config atomic | Invoke-Expression
}
