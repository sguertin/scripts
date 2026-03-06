function Select-Dxf {
    [cmdletBinding()]
    param(
        [xml]$Xml,
        [string]$XPath,
        [string]$OsePrefix = "os",
        [PSObject]$Namespace = $null
    )
    if ($null -eq $Namespace) {
        $Namespace = @{ $OsePrefix = "http://www.oneshield.com/DragonSchema" };
    } 
    try {
        return Select-Xml -Xml $Xml -Namespace $Namespace -XPath $XPath -ErrorAction Stop;
    } catch {
        Write-Debug ("An exception of type " + $Error[0].Exception.GetType().FullName + " occurred!");
        Write-Debug $Error[0].Exception.Message;
        return $null
    }
    
}