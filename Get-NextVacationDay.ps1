function Get-NextVacationDay {
    [cmdletBinding()]
    param(
        [string]$FilePath = $null
    )

    if ([string]::IsNullOrEmpty($FilePath)) {
        $FilePath = Join-Path $env:USERPROFILE -ChildPath Documents -AdditionalChildPath @('vacationDays.json');
        Write-Debug "Defaulting file to $FilePath";
    }
    If (Test-Path $FilePath) {
        $Today = (Get-Date).ToString("yyyy-MM-dd");
        $VacationDays = Get-Content -Path $FilePath | ConvertFrom-Json;
        foreach ($day in $VacationDays) {
            Write-Debug "Comparing $Today to $day";
            $DaysRemaining = (New-TimeSpan -Start $Today -End $day).Days;
            if ($DaysRemaining -ge 1) {
                Write-Debug "Next upcoming vacation day found: $day";
                break;
            }
        }
        if ($DaysRemaining -ge 1) {
            if ($DaysRemaining -eq 1) {
                Write-Host "IT'S THE FINAL COUNTDOWN" -ForegroundColor Green;
            } else {
                Write-Host "$DaysRemaining days until your next vacation!" -ForegroundColor Green;
            }
        } else {
            Write-Host "No upcoming days off." -ForegroundColor Yellow;
        }
    } else {
        Write-Error "Could not find file at $FilePath";
    }
}
