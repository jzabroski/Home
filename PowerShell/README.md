
# Get Start Time for Windows Process
Source: https://blogs.technet.microsoft.com/heyscriptingguy/2012/11/18/powertip-use-powershell-to-easily-see-process-start-time/
## All
Enter-PSSession -ComputerName .
Get-Process | select name,starttime

## w3wp
Enter-PSSession -ComputerName .
Get-Process w3wp | select name,starttime

## VisualCron
Enter-PSSession -ComputerName .
Get-Process VisualCronService | select name,starttime
