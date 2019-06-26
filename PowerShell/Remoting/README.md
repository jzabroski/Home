# Two Approaches
1. WMI (Windows Management Infrastructure)
2. CIM (Common Information Management) via `CimCmdlets` module

As of PowerShell v3, CIM approach is preferred. The PowerShell CIM cmdlets do NOT require PowerShell to be present on the remote machines (only on the calling machine).  `CimCmdlets` uses WinRM, and talks to `Winmgmt` (Windows Management Instrumentation) service on Windows.


https://stackoverflow.com/questions/54495023/what-library-for-powershell-6-contains-the-get-wmiobject-command/54508009#54508009

## WMI

| Cmdlet | PowerShell v5.1 | PowerShell v6 |
| ------ | --------------- | ------------- |
| Get-WmiObject | [Microsoft.PowerShell.Management](https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.management/get-wmiobject?view=powershell-5.1) | superseded by `Get-CimInstance` |

## CIM

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
>
> [...]
> ## Exploring CIM Classes and Instances
> [...] two important parts: the CIM schema and the CIM infrastructure specification.

### CIM infrastructure specification
Defines the conceptual view of the managed environment and defines the standards for integrating multiple management models, using object-oriented constructs and design.  **It is not an API**.

### CIM Schema
Provides actual model descriptions.  It is a collection of classes with properties and methods.


_[Introduction to the CIMCmdlets PowerShell Module](https://devblogs.microsoft.com/scripting/introduction-to-the-cimcmdlets-powershell-module/)_ by Dr Scripto wrote (with my editorial pen):

> # Limitations
> The CIMCmdlets PowerShell module has several limitations compared the WMI cmdlets.
> 1. Most of the `CIMCmdlets` do not have a `-Credential` parameter. The only way to specify alternate credentials is to manually build a new CIM session object, and pass that into the `-CimSession` parameter on the other cmdlets.
> 2. Absence of a number of useful WMI system properties. When you use Get-WmiObject to retrieve a WMI class definition, or an instance of a class, there are several properties that are automatically added. The names of these system properties all start with two underscores (for example:  `__Derivation`). Depending on your Windows PowerShell development goals, you may find this metadata to be useful.
> 3. Lack of WMI methods on .NET objects. When `Get-WmiObject` was the new kid on the block, static or instance-level WMI methods would be dynamically bound to the .NET object. In `CIMCmdlets`, the objects retrieved from WMI are not “live,” so you cannot call methods on the .NET object directly. Instead, you must retrieve the CIM instance, and then pass it into the `Invoke-CimMethod` cmdlet.

