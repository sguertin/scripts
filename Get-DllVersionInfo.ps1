function Get-DllVersionInfo {
    [CmdletBinding()]
    param(
        [string]$Directory 
    )
    $dlls = Get-ChildItem $Directory -Filter "*dll"; 
    foreach($dll in $dlls) { 
        $fileVersion = [System.Diagnostics.FileVersionInfo]::GetVersionInfo($dll.FullName).FileVersion; 
        $fileName = $dll.Name; Write-Host "$fileName - $fileVersion"; 
    }
}