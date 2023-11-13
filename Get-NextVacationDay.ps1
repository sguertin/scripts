function Get-NextVacationDay {
    [cmdletBinding()]
    param(
        [string]$FilePath = $null
    )

    if ($FilePath -eq $null) {
        $FilePath = Join-Path $env:USERPROFILE -ChildPath Documents -AdditionalChildPath @('vacationDays.json');
    } else {
        Write-Warning "Could not find file at '$FilePath'";
    }
    If (Test-Path $FilePath) {
        $Today = (Get-Date).ToString("yyyy-MM-dd");
        $VacationDays = Get-Content -Path $FilePath | ConvertFrom-Json; #@('2023-09-02', '2023-10-09', '2023-10-13', '2023-11-10', '2023-11-23', '2023-12-25');
        foreach ($day in $VacationDays) {
            $DaysRemaining = (New-TimeSpan -Start $Today -End $day).Days;
            if ($DaysRemaining -ge 1) {
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
    }
}
