function Get-GitBranch {
    [cmdletBinding()]
    param(
        [string]$BranchName,
        [switch]$CreateBranch
    )
    if ([string]::IsNullOrEmpty($branchName)) {
        Write-Host "git branch -a";
        & git branch -a;
        return;
    }
    $branches = & git branch -a;
    $branchExists = $false;
    foreach ($branch in $branches) {
        $branchExists = $branch.ToLower().Contains($branchName.ToLower());
        if ($branchExists) {
            break;
        }
    }
    if ($branchExists) {
        Write-Host "git checkout $branchName";
        & git checkout $branchName;
    } else {        
        if ($CreateBranch -or ((Read-Host "Branch does not exist, create new branch? [Y/n]").ToString().ToLower() == "y")) {
            Write-Host "git checkout -b $branchName";
            & git checkout -b $branchName;
        }
    }    
}
Set-Alias -Name branch -Value Get-GitBranch;