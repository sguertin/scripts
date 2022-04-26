function Push-GitBranch {
    [cmdletBinding()]
    param(
        [string]$Path = $PWD
    )

    $isGitDirectory = Test-GitDirectory -Path $Path;
    if ($isGitDirectory -eq $false) {
        Write-Error "$Path is not part of a git repository!";
        return;
    }
    $hasRemote = $false;
    $currentBranch = & git branch --show-current;
    $Branches = & git branch -vv;
    foreach($branch in $branches) {
        if ($branch.Contains("[origin/$currentBranch]")) {
            $hasRemote = $true;
        }
    }
    Push-Location $Path;
    if ($hasRemote) { 
        Write-Host "git push";
        & git push;
    } else {
        Write-Host "git push --set-upstream origin $currentBranch";
        & git push --set-upstream origin $currentBranch;
    }    
    Pop-Location;
}
Set-Alias -Name push -Value Push-GitBranch;