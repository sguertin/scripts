function Format-XmlFile {
    <#
    .SYNOPSIS
    Formats an xml file   

    .DESCRIPTION
    Formats an xml file and optionally saves it as a new file    

    .PARAMETER File
    The FileInfo object piped to this command

    .PARAMETER Destination
    The directory to write formatted xml files to when piping files

    .PARAMETER FilePath
    The path to the xml file to be formatted    

    .PARAMETER NewFilePath
    [OPTIONAL] The file path for the formatted version of the file, if empty, the file will be updated in place    

    .PARAMETER Indent
    [OPTIONAL] The number of spaces to indent (Defaults to 2)

    .INPUTS
    FileInfo objects.

    .OUTPUTS
    File Info of formatted file
    
    .EXAMPLE
    Get-ChildItem -File -Filter "*.xml" | Format-XmlFile

    .EXAMPLE
    Get-ChildItem -File -Filter "*.xml" | Format-XmlFile -Destination "C:\Temp\FormattedFiles"
    
    .EXAMPLE
    Format-XmlFile "test.xml"
    
    .EXAMPLE
    Format-XmlFile -Path "test.xml"    

    .EXAMPLE
    Format-XmlFile -Path "test.xml" -NewFilePath "test_formatted.xml"

    .EXAMPLE
    Format-XmlFile -Path "test.xml" -Indent 4    

    .EXAMPLE
    Format-XmlFile -Path "test.xml" -NewFilePath "test_formatted.xml"  -Indent 4

    #>
    [CmdletBinding(DefaultParameterSetName = "Path")]
    param(
        [Parameter(Mandatory, ParameterSetName = "Pipe", ValueFromPipeline = $true)][System.IO.FileInfo]$File,
        [Parameter(ParameterSetName = "Pipe")][string]$Destination = $null,
        [Parameter(Mandatory, Position = 1, ParameterSetName = "Path")][string]$Path,
        [Parameter(ParameterSetName = "Path")][string]$NewFilePath = "",
        [int]$Indent = 2
        
    )    
    process {
        $stringWriter = New-Object System.IO.StringWriter;
        $xmlWriter = New-Object System.XMl.XmlTextWriter $stringWriter;
        $xmlWriter.Formatting = "indented";
        $xmlWriter.Indentation = $indent;
        if ($null -ne $File) {
            $Path = $File.FullName;
            Write-Debug ("File.FullName=" + $File.FullName);            
        }    
        if ([string]::IsNullOrEmpty($Destination) -eq $false) {
            Write-Debug "Destination=$Destination"
            if ((Test-Path $Destination) -eq $false) {
                Write-Debug "New-Item $Destination -ItemType Directory -Force;"
                New-Item $Destination -ItemType Directory -Force;
            }
            $NewFilePath = Join-Path $Destination -ChildPath $File.Name;
        } 
        if ([string]::IsNullOrEmpty($NewFilePath) -eq $true) {
            $NewFilePath = $Path;
        }
        Write-Debug "NewFilePath=$NewFilePath";       
        $xmlContent = [xml](Get-Content $Path -Raw);
        $xmlContent.WriteContentTo($xmlWriter);
        $xmlWriter.Flush();
        $stringWriter.Flush();        
        $formattedXml = $stringWriter.ToString();
        Write-Debug ("Formatted Content Length:" + $formattedXml.Length.ToString());
        Write-Debug "Set-Content -Path $NewFilePath -Value <XML_CONTENT> -Force;"
        Set-Content -Path $NewFilePath -Value $formattedXml -Force;
        return Get-Item "$NewFilePath";
    }
    
}