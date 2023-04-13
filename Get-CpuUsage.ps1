function Get-CpuUsage {
    [cmdletBinding()]
    param()
    $NumberOfLogicalProcessors=(Get-CimInstance -ClassName Win32_processor | Measure-Object -Sum NumberOfLogicalProcessors).Sum
    (Get-Counter '\Process(*)\% Processor Time').CounterSamples |
        Where-Object CookedValue -GT ($NumberOfLogicalProcessors*10) |
        Sort-Object CookedValue -Descending |
        Format-Table -a InstanceName, @{Name='CPU %';Expr={[Math]::Round($_.CookedValue / $NumberOfLogicalProcessors)}}
}