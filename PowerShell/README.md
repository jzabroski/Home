
# Get Start Time for Windows Process
Source: https://blogs.technet.microsoft.com/heyscriptingguy/2012/11/18/powertip-use-powershell-to-easily-see-process-start-time/
## All
Get-Process | select name,starttime

## w3wp
Get-Process w3wp | select name,starttime

## VisualCron
Get-Process VisualCronService | select name,starttime
