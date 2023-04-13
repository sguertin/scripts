function Get-ResourceUsage {
    [CmdletBinding()]
    param(
        [int]$NumberOfProcesses = 5,
        [switch]$Memory
    )
    if ($Memory -eq $True) {
        Get-Process |
            Sort-Object WorkingSet -descending |
            Select-Object -first $NumberOfProcesses -Property ID,ProcessName,CPU,TotalProcessorTime,@{Name='MemUsage (MB)';Expression={($_.WorkingSet/1MB)}} |
            Format-Table -AutoSize
    } else {
        Get-Process |
            Sort-Object CPU -descending |
            Select-Object -first $NumberOfProcesses -Property ID,ProcessName,CPU,TotalProcessorTime,@{Name='MemUsage (MB)';Expression={($_.WorkingSet/1MB)}} |
            Format-Table -AutoSize
    }
}