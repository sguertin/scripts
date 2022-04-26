function New-Guid {
    [CmdletBinding()]
    param()
    return [System.Guid]::NewGuid().Guid;
}