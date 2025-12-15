function Format-XmlFile {
    <#
    .SYNOPSIS
    Formats an xml file
    
    .DESCRIPTION
    Formats an xml file and optionally saves it as a new file
    
    .PARAMETER FilePath
    The path to the xml file to be formatted
    
    .PARAMETER NewFilePath
    [OPTIONAL] The file path for the formatted version of the file, if empty, the file will be updated in place
    
    .PARAMETER Indent
    [OPTIONAL] The number of spaces to indent
    
    .EXAMPLE
    Format-XmlFile -FilePath "test.xml" -NewFilePath "test_formatted.xml"
    #>
    [cmdletBinding()]
    param(
        [string]$FilePath,
        [string]$NewFilePath = "",
        [int]$Indent = 2
    )
    if ([string]::IsNullOrEmpty($NewFilePath)) {
        $NewFilePath = $FilePath;
    }
    $xml = [xml](Get-Content $FilePath -Raw);

    $formattedXml = Format-Xml $xml -indent $Indent;
    
    Set-Content -Path $NewFilePath -Value $formattedXml;
}