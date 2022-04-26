function Get-FileVersion {
    [CmdletBinding()]
    param(
        [string]$Path
    )
    return [System.Diagnostics.FileVersionInfo]::GetVersionInfo($Path);    
}