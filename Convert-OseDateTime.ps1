function Convert-OseDateTime { 
    [cmdletBinding()]param([string]$Date)

    $year = $Date.Substring(0, 4);
    $month = $Date.Substring(4, 2);
    $day = $Date.Substring(6, 2);
    return (Get-Date -Date "$year-$month-$day");
}