function Update-Item {
    param(
        [string]$FileName
    )
    if ([string]::IsNullOrEmpty($FileName)) {
        Write-Error "No value was provided";
        return;
    }
    if (Test-Path $FileName) {
        $file = Get-Item $FileName;
        $file.LastWriteTime = (Get-Date)
    } else {
        $null > $FileName;
    }
}
Set-Alias -Name touch -Value Update-Item;