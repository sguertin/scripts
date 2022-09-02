function Set-Theme {
    param($Theme)
    $themes = Get-Themes;
    if ($themes -contains $Theme) {
        oh-my-posh init pwsh --config "$env:POSH_THEMES_PATH\$Theme.omp.json" | Invoke-Expression;
    } else {
        Write-Error "$Theme is not a known theme for oh-my-posh";
    }
    
}
