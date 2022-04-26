function Get-Assembly {
    [CmdletBinding()]
    param(
        [string]$Path
    )
    if ([System.String]::IsNullOrEmpty($Path)) {
        Write-Error "No path provided!"
        return $False;
    }
    $assemblyStream = (Get-Item $Path).OpenRead();
    $assemblyBytes = New-Object byte[] $assemblyStream.Length;
    # Piping to Out-Null to eliminate pointless standard output spam
    $assemblyStream.Read($assemblyBytes, 0, $assemblyStream.Length) | Out-Null; 
    $assemblyStream.Close();
    # Piping to Out-Null to eliminate pointless standard output spam
    [Reflection.Assembly]::Load($assemblyBytes) | Out-Null;
}
Set-Alias -Name loadasm -Value Get-Assembly