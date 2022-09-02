function Get-Themes {
    $themes = New-Object Collections.Generic.List[String];
    foreach ($theme in Get-ChildItem $env:POSH_THEMES_PATH) {
        $themes.Add($theme.Name.Replace(".omp.json", ""));
    }
    return $themes;
}
