### [Managing the Windows Firewall with PowerShell](https://4sysops.com/archives/managing-the-windows-firewall-with-powershell/)

#### Displaying programs in rules ^
```powershell
Get-NetFirewallRule -Action Block -Enabled True | %{$_.Name; $_ | Get-NetFirewallApplicationFilter }
```
