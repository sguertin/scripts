function New-GitCommit {
    [cmdletBinding()]
    param(
        [string]$Message,
        [switch]$All,
        [switch]$Push,
        [switch]$Force
    )
    $commandText = "git commit"
    if ($All) {
        $commandText = "$commandText -a"
    }
    while ([string]::IsNullOrEmpty($Message)) {
        $Message = Read-Host -Prompt "Please provide a commit message";
    }
    $commandText = "$commandText -m `"$Message`""
    Write-Host $commandText
    Invoke-Expression $commandText;
    if ($Push) {
        $pushCommand = "git push";
        $branch = Get-CurrentBranch;
        $return = & git ls-remote --exit-code --heads origin $branch;
        if ([string]::IsNullOrEmpty($return)) {
            $pushCommand = "$pushCommand --set-upstream origin $branch";
        }
        if ($Force) {
            $pushCommand = "$pushCommand --force"
        }
        Write-Host $pushCommand;
        Invoke-Expression $pushCommand
    } elseif ($Force) {
        Write-Warning "-Force is not applicable without -Push, ignoring...";
    }
}
Set-Alias -Name commit -Value New-GitCommit;