function Remove-RemoteBranch {
    [CmdletBinding()]
    param(
        $BranchName
    )

    if ((Test-GitExecutable) -eq $false) {
        Write-Error "git executable not found!";
        return 1
    }

    if ([System.String]::IsNullOrEmpty($BranchName)) {
        $BranchName = Read-Host "What remote branch do you want to delete?";
    }
    Write-Host "git push origin --delete $BranchName"
    git push origin --delete $BranchName
}