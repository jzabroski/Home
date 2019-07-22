# SPN Configuration

```powershell
Get-EventLog -LogName Application -Source 'MSSQLSERVER' -After $(Get-Date '7/20/2019') -Before $(Get-Date '07/22/2019') |
  Where-Object { $_.EventID -eq 26067 } |
  Format-Custom -Property Source,InstanceID,EventID,EntryType,Message
```

should return something like the following:

> class EventLogEntry#Application/MSSQLSERVER/**InstanceID**
> {
>   Source = MSSQLSERVER
>   InstanceID = **InstanceID**
>   EventID = 26067
>   EntryType = Information
>   Message = The SQL Server Network Interface library could not register the Service Principal Name (SPN) [
>   MSSQLSvc/sqlserver.examle.com ] for the SQL Server service. Windows return code: 0x200b, state: 15. Failure to
>   register a SPN might cause integrated authentication to use NTLM instead of Kerberos. This is an informational
>   message. Further action is only required if Kerberos authentication is required by authentication policies and if
>   the SPN has not been manually registered.
> }
