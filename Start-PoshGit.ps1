function Start-PoshGit {
    [CmdletBinding()]
    param()

    Import-Module "$env:UserProfile\Modules\1.0.0\posh-git.psm1" -Force;
    $GitPromptSettings.DefaultPromptSuffix.Text = "`n>"
    $GitPromptSettings.DefaultPromptAbbreviateHomeDirectory = $false
}