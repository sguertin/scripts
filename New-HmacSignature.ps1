function New-HmacSignature {
    [CmdletBinding()]
    param(
        [switch]$SHA512,
        [switch]$SHA256
    )
    if ($SHA256) {
        # Write-Host "Using 256 HMACSHA";
        $hmac = new-object -TypeName System.Security.Cryptography.HMACSHA256;    
    } elseif ($SHA512) {
        # Write-Host "Using 512 HMACSHA";
        $hmac = new-object -TypeName System.Security.Cryptography.HMACSHA512;
    } else {
        # Write-Host "Using Default (512) HMACSHA";
        $hmac = new-object -TypeName System.Security.Cryptography.HMACSHA512;
    }
    
    return [System.Convert]::ToBase64String($hmac.Key);
}