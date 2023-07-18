function New-GitCommit {
    [cmdletBinding()]
    param(
        [string]$Message,
        [switch]$All,
        [switch]$Push,
        [switch]$Force
    )
    if ($All) {
        Write-Host "git commit -a -m `"$Message`""
        & git commit -a -m "$Message";
    } else {
        Write-Host "git commit -m `"$Message`""
        & git commit -m "$Message";
    }
    if ($Push) {
        if ($Force) {
            Write-Host "git push --force"
            & git push --force;
        } else {
            Write-Host "git push"
            & git push;
        }
    } elseif ($Force) {
        Write-Warning "Force switch is not applicable without Push switch";
    }
}
Set-Alias -Name commit -Value New-GitCommit;