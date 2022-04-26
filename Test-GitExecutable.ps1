function Test-GitExecutable {
    [cmdletBinding()]
    param()

    try {
        Get-Command git -ErrorAction Stop | Out-Null;
        return $true;
    } catch {
        return $false;
    }
}