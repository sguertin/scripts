function New-GitCommit {
    [cmdletBinding()]
    param(
        [string]$Message,
        [switch]$All,
        [switch]$Push,
        [switch]$Force
    )
    if ($All) {
        & git commit -a -m "$Message";
    } else {
        & git commit -m "$Message";
    }
    if ($Push) {
        if ($Force) {
            & git push --force;
        } else {
            & git push;
        }
    } elseif ($Force) {
        Write-Warning "Force switch is not applicable without Push switch";
    }
}
Set-Alias -Name commit -Value New-GitCommit;