# Command Line Tricks

Type `> [console]::`, then <kbd>control</kbd>+<kbd>space</kbd> to see all public properties, fields and methods on a type.

# Better Command Line Experience?

[PowerLine](https://github.com/Jaykul/PowerLine)
which uses PANSIES, which has full RGB color support and renders faster.

# Better Auto-Completion?

[PROSE - Microsoft Program Synthesis using Examples SDK](https://microsoft.github.io/prose/)

dotnet-suggest

# PowerShell Profile
```powershell
notepad++.exe $PROFILE
```
## Map source directory
```powershell
Set-Location c:\source\
function cdHomeInner {set-location C:\source\Home}
set-alias cdHome cdHomeInner
```

# Get-Process with Main Windows Title 

```powershell
Get-Process | 
where-Object {$_.mainWindowTitle} | 
format-table id,name,mainwindowtitle –AutoSize
```

# Get Process with net stats
```powershell
get-nettcpconnection | select local*,remote*,state,@{Name="Process";Expression={(Get-Process -Id $_.OwningProcess).ProcessName}}
```

# Get Start Time for Windows Process
Source: https://blogs.technet.microsoft.com/heyscriptingguy/2012/11/18/powertip-use-powershell-to-easily-see-process-start-time/
## All
```powershell
Enter-PSSession -ComputerName .
Get-Process | select name,starttime
```
## w3wp
```powershell
Enter-PSSession -ComputerName .
Get-Process w3wp | select name,starttime
```
## VisualCron
```powershell
Enter-PSSession -ComputerName .
Get-Process VisualCronService | select name,starttime
```

## Reboot Messages
```powershell
Get-EventLog -LogName System -After $(Get-Date).AddMonths(-1) | Where { 6009,6005,6006 -contains $_.EventID}
```

# Get Monitor
```powershell
$Monitors = Get-WmiObject WmiMonitorID -Namespace root\wmi
$LogFile = "C:\monitors.txt"

"Manufacturer,Name,Serial" | Out-File $LogFile

ForEach ($Monitor in $Monitors)
{
	$Manufacturer = ($Monitor.ManufacturerName -notmatch 0 | ForEach{[char]$_}) -join ""
	$Name = ($Monitor.UserFriendlyName -notmatch 0 | ForEach{[char]$_}) -join ""
	$Serial = ($Monitor.SerialNumberID -notmatch 0 | ForEach{[char]$_}) -join ""
	
	"$Manufacturer,$Name,$Serial" | Out-File $LogFile -append
}
```

# Memory Diagnostics
```powershell
# From: https://www.petri.com/display-memory-usage-powershell
Function Test-MemoryUsage {
[cmdletbinding()]
Param()
 
$os = Get-Ciminstance Win32_OperatingSystem
$pctFree = [math]::Round(($os.FreePhysicalMemory/$os.TotalVisibleMemorySize)*100,2)
 
if ($pctFree -ge 45) {
$Status = "OK"
}
elseif ($pctFree -ge 15 ) {
$Status = "Warning"
}
else {
$Status = "Critical"
}
 
$os | Select @{Name = "Status";Expression = {$Status}},
@{Name = "PctFree"; Expression = {$pctFree}},
@{Name = "FreeGB";Expression = {[math]::Round($_.FreePhysicalMemory/1mb,2)}},
@{Name = "TotalGB";Expression = {[int]($_.TotalVisibleMemorySize/1mb)}}
 
}
```

# audit

https://github.com/EvotecIT/PSWinReporting
