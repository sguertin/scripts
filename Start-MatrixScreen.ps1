function Start-MatrixScreen {
    param()
    Clear-Host;
    MatrixScreen.exe
    Clear-Host;
}
Set-Alias -Name matrix -Value Start-MatrixScreen