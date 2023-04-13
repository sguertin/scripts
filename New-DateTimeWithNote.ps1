function New-DateTimeWithNote {
    [CmdletBinding()]
    param(
        [string]$Note,
        [string]$FilePath,
        [switch]$Utc
    )

    if ($Utc -eq $True) {
        $TimeStamp = [System.DateTime]::UtcNow;
    } else {
        $TimeStamp = [System.DateTime]::Now;
    }

    if ((Test-Path -Path $FilePath) -eq $False) {
        Set-Content $FilePath -Value "";
    }
    $message = "$TimeStamp - $Note";
    Write-Host $message;
    Add-Content -Path $FilePath -Value $message;
}