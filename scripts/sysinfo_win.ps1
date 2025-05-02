# Output path
$outputPath = "$env:USERPROFILE\Desktop\sysinfo_report.txt"

# Uptime
$uptime = New-TimeSpan -Start (Get-CimInstance Win32_OperatingSystem).LastBootUpTime -End (Get-Date)
$uptimeHours = "{0:N2}" -f $uptime.TotalHours

# Total memory
$totalMem = (Get-CimInstance Win32_ComputerSystem).TotalPhysicalMemory / 1GB
$totalMemFormatted = "{0:N2} GB" -f $totalMem

# IP addresses
$ipList = (Get-NetIPAddress -AddressFamily IPv4 | Where-Object { $_.InterfaceAlias -notlike "*Loopback*" -and $_.IPAddress -notlike "169.*" }).IPAddress -join ", "

# Logged-in users
$loggedInUsers = (query user) -join "`n"

@"
========== Windows System Information ==========
Hostname:            $(hostname)
Username:            $env:USERNAME
Model:               $((Get-CimInstance Win32_ComputerSystem).Model)
Serial Number:       $((Get-CimInstance Win32_BIOS).SerialNumber)
Windows Version:     $((Get-ItemProperty 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion').ProductName)
Uptime:              $uptimeHours hours

========== CPU Information ==========
Processor:           $((Get-CimInstance Win32_Processor).Name)
Cores:               $((Get-CimInstance Win32_Processor).NumberOfCores)
Logical Processors:  $((Get-CimInstance Win32_Processor).NumberOfLogicalProcessors)

========== Memory ==========
Total Memory:        $totalMemFormatted

========== Disk Usage ==========
$(Get-PSDrive -PSProvider 'FileSystem' | ForEach-Object {
    "Drive $($_.Name): $([math]::Round($_.Used/1GB,2)) GB used / $([math]::Round($_.Free/1GB,2)) GB free"
})

========== Network ==========
$ipList

========== Logged-in Users ==========
$loggedInUsers
"@ | Out-File -FilePath $outputPath -Encoding UTF8

exit