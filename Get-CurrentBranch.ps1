function Get-CurrentBranch {
    [cmdletBinding()]
    param(
        [string]$Path = $PWD
    )
    Write-Verbose "Push-Location $PATH"
    Push-Location $Path;
    Write-Verbose "& git branch --show-current"
    $result = & git branch --show-current;
    Write-Verbose "Pop-Location $PATH";
    Pop-Location;
        
    return $result;
}