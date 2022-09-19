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
        $BranchName = Read-Host "What branch do you want to pull?";
    }
    Write-Host "git fetch origin ${BranchName}:${BranchName}";
    git fetch origin "${BranchName}:${BranchName}";
    if ($Checkout) {
        git checkout $BranchName;
    }
}
Set-Alias -Name fetch -Value Get-RemoteChanges;