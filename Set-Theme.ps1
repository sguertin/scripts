function Set-Theme {
    param($Theme)
    
    oh-my-posh init pwsh --config "$env:POSH_THEMES_PATH\$Theme.omp.json" | Invoke-Expression;
}