Set-PSReadLineOption -EditMode Emacs

if (Get-Command -Name oh-my-posh -ErrorAction SilentlyContinue) {
    oh-my-posh init pwsh --strict | Invoke-Expression
}
