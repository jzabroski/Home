1. https://help.duo.com/s/article/3814?language=en_US
```powershell
cmdkey /list | Where-Object { $_ -like "*Target:*target=MicrosoftOffice16_Data*" } | ForEach-Object { $_ -replace " ","" -replace "Target:","" } | ForEach-Object { cmdkey /delete:($_) }
```
