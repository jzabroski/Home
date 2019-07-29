# Failure to start

## Service failure to start
```powershell
Get-EventLog -LogName System -Source "Service Control Manager" | where eventid -cin @(7000, 7038)
```

If you get this error, and you are using Logon Type 5 (Log On as a Service), and the username has Log On As a Service rights in Local security policy, then the next thing to check is whether or not the service Log On value is correct.  The safest way to test this is to revert the logon to NT AUTHORITY\SYSTEM, click apply, then change it back to what you want using the Search dialog.

## Service start failure query
```powershell
Get-EventLog -LogName Application -Source MSSQLSERVER -After $(Get-Date '7/20/2019') -Before $(Get-Date '7/22/2019') |
  Where-Object { $_.EventID -eq 1 } |
  Format-Custom -Property Source,InstanceID,EventID,EntryType,Message,ReplacementStrings
```

```
class EventLogEntry#Application/MSSQLSERVER/1
{
  Source = MSSQLSERVER
  InstanceId = 1
  EventID = 1
  EntryType = Information
  Message = None
  ReplacementStrings =
    [
      SqlCeip started  pid: 3300 instance:  CPEFlag: True
    ]

}

class EventLogEntry#Application/MSSQLSERVER/1
{
  Source = MSSQLSERVER
  InstanceId = 1
  EventID = 1
  EntryType = Information
  Message = None
  ReplacementStrings =
    [
      Open failed with error number 2
    ]

}
```

## Login failure
```powershell
Get-EventLog -LogName Security  -After $(Get-Date '7/20/2019 09:15:00') -EntryType FailureAudit |
  Format-Custom -Property Source,InstanceID,Time,EntryType,Message
```

# SPN Configuration

```powershell
Get-EventLog -LogName Application -Source 'MSSQLSERVER' -After $(Get-Date '7/20/2019') -Before $(Get-Date '07/22/2019') |
  Where-Object { $_.EventID -eq 26067 } |
  Format-Custom -Property Source,InstanceID,EventID,EntryType,Message
```

should return something like the following:

> class EventLogEntry#Application/MSSQLSERVER/**InstanceID**<br/>
> {<br/>
>   Source = MSSQLSERVER<br/>
>   InstanceID = **InstanceID**<br/>
>   EventID = 26067<br/>
>   EntryType = Information<br/>
>   Message = The SQL Server Network Interface library could not register the Service Principal Name (SPN) [<br/>
>   MSSQLSvc/sqlserver.examle.com ] for the SQL Server service. Windows return code: 0x200b, state: 15. Failure to<br/>
>   register a SPN might cause integrated authentication to use NTLM instead of Kerberos. This is an informational<br/>
>   message. Further action is only required if Kerberos authentication is required by authentication policies and if<br/>
>   the SPN has not been manually registered.<br/>
> }<br/>
