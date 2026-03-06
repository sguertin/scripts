function Select-XmlValue {
    [cmdletBinding()]
    param(
        [xml]$Xml,
        [object]$Namespace,
        [string]$XPath
    )

    return (Select-Xml -Xml $Xml -Namespace $Namespace -XPath $XPath).Node.InnerXml;
}