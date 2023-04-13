function Get-SourceChanges {
    [CmdletBinding()]
    param(
        [string]$Commit = "head^1"
    )

    if ((Test-GitExecutable) -eq $false) {
        Write-Error "git executable not found!";
        return 1;
    }
    Write-Host "git diff head $Commit";
    git diff head $Commit
}
Set-Alias sdiff -Value Get-SourceChanges;