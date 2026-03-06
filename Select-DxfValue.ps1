function Select-DxfValue {
    [cmdletBinding()]
    param(
        [xml]$Xml,
        [string]$XPath,
        [string]$OsePrefix = "os",
        [object]$Namespace = $null
    )
    $result = Select-Dxf -Xml $Xml -Namespace $Namespace -XPath $XPath -OsePrefix $OsePrefix;
    if ($null -ne $result) {
        return $result.Node.InnerXml;
    }
    return $null;
}