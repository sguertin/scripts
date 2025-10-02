function Get-RemoteChanges {
    [CmdletBinding()]
    param(
        [string]$BranchName = "",
        [switch]$Checkout
    )
    if ((Test-GitExecutable) -eq $false) {
        Write-Error "git executable not found!";
        return 1;
    }
    if ([System.String]::IsNullOrEmpty($BranchName)) {
        Write-Host "git pull;";
        git pull;
    } else {
        Write-Host "git fetch origin ${BranchName}:${BranchName};";
        git fetch origin "${BranchName}:${BranchName}";
        if ($Checkout) {
            git checkout $BranchName;
        }
    }
}
Set-Alias -Name pull -Value Get-RemoteChanges;