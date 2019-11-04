- Stein Asmul of [installdude.com](http://installdude.com) is probably the foremost guru on the Internet for helping people install software.
- Some of his StackOverflow answers are featured here

### Uninstalling an MSI from the Command Line (silently)

#### Stein Asmul's answer: https://stackoverflow.com/a/1055933/1040437
> > There are many ways to uninstall an MSI package. This is intended as a "reference".
> 
> In summary you can uninstall via: msiexec.exe, ARP, WMI, PowerShell, Deployment Systems such as SCCM, VBScript / COM Automation, DTF, or via hidden Windows cache folder, and a few other options presented below.
>
> [...]
> 
> ```powershell
> $packageToUninstall = $(get-wmiobject Win32_Product | Where-Object { $_.Name -ilike "SubscriberRTDAddin" } | Select-Object -First 1) 
> $packageToUninstall.Uninstall() 
> ```

#### Roger Lipscombe's answer: https://stackoverflow.com/a/450043/1040437
> If you look in the registry under `HKEY_CLASSES_ROOT\.msi`, 
> you'll see that .MSI files are associated with the `ProgID` "`Msi.Package`". 
> If you look in `HKEY_CLASSES_ROOT\Msi.Package\shell\Open\command`, 
> you'll see the command line that Windows actually uses when you "run" a .MSI file.

This answer is cool because it demonstrates the fact that MSI is basically a COM-based object model, by cluing you into exactly how its modeled in the registy as a ProgId.
