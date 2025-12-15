function Format-Xml {
    <#
    .SYNOPSIS
    Formats xml into a human readable format
    
    .DESCRIPTION
    Accepts an xml string and indentation amount (default is 2) and returns 
    
    .PARAMETER XmlContent
    The xml content to be formatted
    
    .PARAMETER Indent
    [OPTIONAL]The number of spaces to use for indentation, defaults to 2
    
    .EXAMPLE
    Format-Xml -XmlContent "<note><to>Tove</to><from>Jani</from><heading>Reminder</heading><body>Don't forget me this weekend!</body></note>" -Indent 4;
    
    #>
    param (
        [xml]$XmlContent,
        [int]$Indent = 2
    )
    $StringWriter = New-Object System.IO.StringWriter;
    $XmlWriter = New-Object System.XMl.XmlTextWriter $StringWriter;
    $XmlWriter.Formatting = "indented";
    $XmlWriter.Indentation = $indent;
    $XmlContent.WriteContentTo($XmlWriter);
    $XmlWriter.Flush();
    $StringWriter.Flush();
    
    return $StringWriter.ToString();
}