function Find-CredentialsInConfig {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position = 1, ValueFromPipeline = $true)][System.IO.FileInfo]$Path
    )
    begin {
        $appSettingsXPath = "/configuration/appSettings/add"
        $encryptedSettingsXPath = "/configuration/appSettings/EncryptedData";
        $connectionStringsXPath = "/configuration/connectionStrings/add"
        $secretPattern = "passwd|password|Password|ApiKey|apikey|token|accessKey|bearer|credentials|salt|SALT|signature|secret";
    }
    process {
        $xmlContent = [xml](Get-Content -Path $Path.FullName -Raw);
        $settings = $null;
        try {            
            Select-Xml -Xml $xmlContent -XPath $encryptedSettingsXPath -ErrorAction Stop | Out-Null;
            $settings = @();
        } catch {
            Write-Warning ("'" + $Path.FullName + "' AppSettings are not encrypted ");            
        }
        if ($null -eq $settings) {
            try {            
                $settings = Select-Xml -Xml $xmlContent -XPath $appSettingsXPath -ErrorAction Stop;
            } catch {
                Write-Verbose ("No appSettings found in " + $Path.FullName)
                $settings = @();
            }
        }        
        $result = @();
        foreach ($setting in $settings) {
            $key = $setting.Node.key;
            $value = $setting.Node.value;
            Write-Verbose "key: $key value: $value";
            if ([string]::IsNullOrEmpty($value)) {
                Write-Verbose "Ignoring key as it has a placeholder value of $value";                
            } elseif ($key -match $secretPattern) {
                if ($value.StartsWith("#{") -and $value.EndsWith("}#")) {
                    Write-Verbose "Ignoring key as it has a placeholder value of $value";
                } else {
                    $result += "appSetting:$key" | Out-Null;
                }
            } else {
                Write-Verbose "key: '$key' does not match secrets pattern";
            }
        }
        $connectionStrings = Select-Xml -Path $Path.FullName -XPath $connectionStringsXPath;
        foreach ($connectionString in $connectionStrings) {
            $key = $connectionString.Node.name;
            $value = $connectionString.Node.connectionString;
            if ($value -match $secretPattern) {
                $result += "connectionString:$key" | Out-Null;
            } else {
                Write-Verbose "$value does not match pattern: $secretPattern";
            }        
        }
        if ($result.Count -gt 0) {
            Write-Output @{"File" = $Path.FullName; "Findings" = $result };
        }        
    }
} 