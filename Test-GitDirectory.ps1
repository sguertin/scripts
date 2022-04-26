function Test-GitDirectory {
    <#
    .SYNOPSIS
        Returns true if current directory is within a git repository
    .DESCRIPTION
        This command recursively checks from the current directory up
        to see if their is a .git directory present. Returns True if
        the found, otherwise returns False
    #>
    [cmdletBinding()]
    param(
        # The path to begin recursively testing from, defaults to current working directory
        [string]$Path = $PWD
    )
    $gitDirectory = Join-Path -Path $Path -ChildPath '.git';
    if ([System.IO.Directory]::Exists($gitDirectory)) {
        return $true;
    }
    $splitPath = split-path $Path
    if ($splitPath) {
        Test-GitDirectory -Path $splitPath;
    }
    else {
        return $false;
    }
}