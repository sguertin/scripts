function New-GitCommit {
    <#
    .SYNOPSIS
    Creates a new git commit

    .DESCRIPTION
    Creates a new git commit and optionally allows it to be pushed to origin

    .PARAMETER Message
    Parameter Required: The message to include with the commit

    .PARAMETER StagedOnly
    Parameter Optional: Only commit files that are currently staged

    .PARAMETER Push
    Parameter Optional: After committing, push to origin

    .PARAMETER Force
    Parameter Optional: Includes the --force flag when pushing to origin

    .EXAMPLE
    New-GitCommit -Message "Updated project versions" -Push;

    .NOTES
    Aliased as commit
    #>
    [cmdletBinding()]
    param(
        [string]$Message,
        [switch]$StagedOnly,
        [switch]$Push,
        [switch]$Force
    )
    $commandText = "git commit"
    if ($StagedOnly -eq $false) {
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