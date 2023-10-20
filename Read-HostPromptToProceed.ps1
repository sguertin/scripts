function Read-HostPromptToProceed {
    param(
        $Prompt = "Are you sure you wish to proceed? Y/N"
    )
    [string]$Option = Read-Host -Prompt $Prompt;
        if ($Option.ToLower().Equals("n")) {
            Write-Host "Quitting...";
            return $false;
        } elseif ($Option.ToLower().Equals("y")) {
            Write-Warning "Continuing with Gallery Creation"
            return $true;
        } else {
            Write-Error "That's not 'Y' or 'N' so I'm quitting anyways";
            exit $false;
        }
}