function Get-FileSize {
    [cmdletBinding()]
    param(
        [string]$Path,
        # Only allow one size flag when using this script
        [Parameter(Mandatory=$false)][ValidateScript({-not ( $Kilobytes -or $Megabytes -or $Gigabytes )})][switch]$Bytes,
        [Parameter(Mandatory=$false)][ValidateScript({-not ( $Bytes -or $Megabytes -or $Gigabytes )})][switch]$Kilobytes,
        [Parameter(Mandatory=$false)][ValidateScript({-not ( $Bytes -or $Kilobytes -or $Gigabytes )})][switch]$Megabytes,
        [Parameter(Mandatory=$false)][ValidateScript({-not ( $Bytes -or $Kilobytes -or $Megabytes )})][switch]$Gigabytes,
        [switch]$Raw,
        [int]$Round = 0
    )
    if ((Test-Path -Path $Path) -eq $false) {
        Write-Error "'$Path' was not found!"
        return;
    }
    if ($Round -lt 0) {
        Write-Error "Round must be a positive integer!";
        return;
    }
    $byteSize = (Get-Item $Path).length;
    $kb = $byteSize/1KB;
    $mb = $byteSize/1MB;
    $gb = $byteSize/1GB;
    $result = $null;

    if ($Gigabytes -eq $true) {
        $result = $gb;
        $unit = "GB";
    } elseif ($Megabytes -eq $true) {
        $result = $mb;
        $unit = "MB";
    } elseif ($Kilobytes -eq $true) {
        $result = $kb;
        $unit = "KB";
    } elseif ($Bytes -eq $true) {
        $result = $byteSize;
        $unit = "B";
    }
    if ($null -eq $result) {
        if ($gb -gt 1) {
            $result = $gb;
            $unit = "GB";
        } elseif ($mb -gt 1) {
            $result = $mb;
            $unit = "MB";
        } elseif ($kb -gt 1) {
            $result = $kb;
            $unit = "KB";
        } else {
            $result = $byteSize;
            $unit = "B";
        }
    }
    if ($Round -gt 0) {
        $result = [math]::Round($result,$Round);
    }
    if ($Raw -eq $true) {
        return $result;
    } else {
        return "$result $unit";
    }
}