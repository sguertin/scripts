function Convert-ToAz {
    param(
        [string]$ScriptFilePath
    )
    $Plan = New-AzUpgradeModulePlan -FromAzureRmVersion 6.13.1 -ToAzVersion 9.3.0 -FilePath $ScriptFilePath;
    if ($null -ne $Plan) {
        $Results = Invoke-AzUpgradeModulePlan -Plan $Plan -FileEditMode ModifyExistingFiles;
        Set-Content "$ScriptFilePath.UpgradePlan.txt" -Value $Results;
    } else {
        Write-Warning "No AzureRm commands to update";
    }
}