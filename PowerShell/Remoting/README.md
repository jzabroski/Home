# Two Approaches
1. WMI (Windows Management Infrastructure)
2. CIM (Common Information Management)

As of PowerShell v3, CIM approach is preferred. The PowerShell CIM cmdlets do NOT require PowerShell to be present on the remote machines (only on the calling machine).


https://stackoverflow.com/questions/54495023/what-library-for-powershell-6-contains-the-get-wmiobject-command/54508009#54508009

## WMI

| Cmdlet | PowerShell v5.1 | PowerShell v6 |
| ------ | --------------- | ------------- |
| Get-WmiObject | [Microsoft.PowerShell.Management](https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.management/get-wmiobject?view=powershell-5.1) | 
| superseded by `Get-CimInstance` |

## CMI

A possible starting point: PowerShell's conceptual help topic about CIM, about_CIMSession: https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_cimsession?view=powershell-6

A CIM session is not the same thing as a PowerShell session.

From _Windows PowerShell Desired State Configuration Revealed_ by Ravikanth Chaganti
> # Introduction to CIM Cmdlets
> The CIM cmdlets in PowerShell are a part of the `CimCmdlets` module.  No surprises there! We can use the `Get-Command` cmdlet to obtain a list of cmdlets available in this module.  A list of the CIM cmdlets is shown in Figure 2-18.
>
> ```powershell
> Get-Command -Module CimCmdlets
> 
> CommandType     Name                                               Version    Source
> -----------     ----                                               -------    ------
> Cmdlet          Get-CimAssociatedInstance                          6.1.0.0    CimCmdlets
> Cmdlet          Get-CimClass                                       6.1.0.0    CimCmdlets
> Cmdlet          Get-CimInstance                                    6.1.0.0    CimCmdlets
> Cmdlet          Get-CimSession                                     6.1.0.0    CimCmdlets
> Cmdlet          Invoke-CimMethod                                   6.1.0.0    CimCmdlets
> Cmdlet          New-CimInstance                                    6.1.0.0    CimCmdlets
> Cmdlet          New-CimSession                                     6.1.0.0    CimCmdlets
> Cmdlet          New-CimSessionOption                               6.1.0.0    CimCmdlets
> Cmdlet          Register-CimIndicationEvent                        6.1.0.0    CimCmdlets
> Cmdlet          Remove-CimInstance                                 6.1.0.0    CimCmdlets
> Cmdlet          Remove-CimSession                                  6.1.0.0    CimCmdlets
> Cmdlet          Set-CimInstance                                    6.1.0.0    CimCmdlets
> ```
