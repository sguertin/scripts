function Get-PowerShellVersion {
    [cmdletBinding()]
    param()

    return Get-Host | Select-Object Version;
}