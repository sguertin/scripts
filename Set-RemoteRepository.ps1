function Set-RemoteRepository {
    [cmdletBinding()]
    param(
        [string]$ShortName = "origin",
        [string]$Url = (Read-Host -Prompt "Enter url for remote repository")
    )
    while ([String]::IsNullOrEmpty($Url))
    {
        $Url = Read-Host -Prompt "Seriously, enter the url for the remote repository";
    }
    Write-Host "git remote add $ShortName $Url";
    & git remote add $ShortName $Url;
}