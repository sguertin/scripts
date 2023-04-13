function Invoke-XmlDocTransform {
    param(
        $SourceXmlPath,
        $TransformFilePath
    )
    if (!$SourceXmlPath -or !(Test-Path -path $SourceXmlPath -PathType Leaf)) {
        throw "File not found. $SourceXmlPath";
    }
    if (!$TransformFilePath -or !(Test-Path -path $TransformFilePath -PathType Leaf)) {
        throw "File not found. $TransformFilePath";
    }
    Add-Type -LiteralPath "C:\Program Files\Microsoft Visual Studio\2022\Enterprise\MSBuild\Microsoft\VisualStudio\v17.0\Web\Microsoft.Web.XmlTransform.dll"

    $xml = New-Object Microsoft.Web.XmlTransform.XmlTransformableDocument;
    $xml.PreserveWhitespace = $true
    $xml.Load($SourceXmlPath);

    $transf = New-Object Microsoft.Web.XmlTransform.XmlTransformation($TransformFilePath);
    if ($transf.Apply($xml) -eq $false)
    {
        throw "Transformation failed."
    }
    $xml.Save($SourceXmlPath);
}
Set-Alias xmlTransform -Value Invoke-XmlDocTransform;