function Get-FileFromZip {

    [CmdletBinding()]
    param(
        [string]$SourceFile,
        [string]$FileName,
        [string]$Destination = $PWD
    )

    Add-Type -Assembly System.IO.Compression.FileSystem;
    $zip = [IO.Compression.ZipFile]::OpenRead("$pwd\$SourceFile");
    if ($FileName.Equals(""))
    {
        $files = $zip.Entries;
    } else
    {
        $files = $zip.Entries | Where-Object { $_.Name -like $FileName };
    }

    foreach ($file in $files) {
        [System.IO.Compression.ZipFileExtensions]::ExtractToFile($file, "$pwd\$file", $true);
    }
    $zip.Dispose();
}
Set-Alias -Name unzip -Value Get-FileFromZip