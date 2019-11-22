### [Managing the Windows Firewall with PowerShell](https://4sysops.com/archives/managing-the-windows-firewall-with-powershell/)

#### Displaying programs in rules ^
```powershell
Get-NetFirewallRule -Action Block -Enabled True | %{$_.Name; $_ | Get-NetFirewallApplicationFilter }
```

### [Is there anyway to see when a Windows firewall rule was created/enabled using PowerShell v2 or CMD?](https://superuser.com/questions/747184/is-there-anyway-to-see-when-a-windows-firewall-rule-was-created-enabled-using-po)

#### Displaying Windows Firewall EventLog EventID 2004 (A rule has been added to the firewall...)

```powershell
Get-WinEvent -LogName "Microsoft-Windows-Windows Firewall With Advanced Security/Firewall" | Where-Object {$_.ID -eq "2004"}
```

```powershell
Get-WinEvent -ErrorAction SilentlyContinue -FilterHashtable @{logname="Microsoft-Windows-Windows Firewall With Advanced Security/Firewall"; id=2004; StartTime=(Get-Date).AddMinutes(-5); EndTime=Get-Date}
```
