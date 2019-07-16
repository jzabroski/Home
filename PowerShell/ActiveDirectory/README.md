# Search for a SID

```powershell
$sid = "S-0-0-00-000000000-0000000000-000000000-0000"
Get-ADObject -Filter 'objectSID -LIKE "$sid"'
```
