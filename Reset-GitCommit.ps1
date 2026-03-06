function Reset-GitCommit {
    [cmdletBinding()]
    param(
        [int]$Steps = 1
    )
    & git reset --soft HEAD~$Steps;
}