function Get-CommandExt {
    [CmdletBinding()]
    param(
        [string]$Path,
        [switch]$ReturnObject
    )

    try {
        $result = Get-Command $Path -ErrorAction Stop;
        Write-Output $result.Source;
    } catch {
        return $null;
    }
}