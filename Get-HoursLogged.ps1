function Get-HoursLogged {
    [CmdletBinding()]
    param(
        [DateTime]$Date = [DateTime]::Now
    )

    return Get-Content "$env:USERPROFILE\TimeTracking\TimeTracking-$($Date.Year)-$($Date.Month)-$($Date.Day).log";
}