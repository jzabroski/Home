1. Check that you don't have Fiddler2 or another proxy interception tool enabled.
2. https://help.duo.com/s/article/3814?language=en_US
```powershell
cmdkey /list | Where-Object { $_ -like "*Target:*target=MicrosoftOffice16_Data*" } | ForEach-Object { $_ -replace " ","" -replace "Target:","" } | ForEach-Object { cmdkey /delete:($_) }
```
