- Stein Asmul of [installdude.com](http://installdude.com) is probably the foremost guru on the Internet for helping people install software.
- Some of his StackOverflow answers are featured here

### In Wix, where is the ProductCode located? https://stackoverflow.com/questions/10330534/in-wix-where-is-the-productcode-specified

Note: ProductCode is required to uninstall an MSI silently.

#### Bryan P. Johnston's answer: https://stackoverflow.com/users/1202501/bryanj

> The product code is the Id of the Product element.
> 
> Specifying a guid
> 
> ```xml
> <Product Id="INSERT_GUID_HERE" 
> ```
> 
> Specifying a '*' makes the GUID auto generate every time
> 
> ```xml
> <Product Id="*"
> ```

Bryan's twitter: https://twitter.com/bryanpjohnston

Bryan's website: http://bryanpjohnston.com/ 

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

My note: Win32_Product should really not be queried, as it is not a read-only operation. Apparently, querying Win32_Product has the side-effect of running a consistency check on every package and then proceeds with repair installations if any are found. THIS MIGHT BE VERY DANGEROUS ON A PRODUCTION SYSTEM.
1. https://sdmsoftware.com/group-policy-blog/wmi/why-win32_product-is-bad-news/
2. [KB974524](http://support.microsoft.com/kb/974524): Event log message indicates that the Windows Installer reconfigured all installed applications
   > Win32_product Class is not query optimized. Queries such as “select * from Win32_Product where (name like 'Sniffer%')” require WMI to use the MSI provider to enumerate all of the installed products and then parse the full list sequentially to handle the “where” clause. This process also initiates a consistency check of packages installed, verifying and repairing the install. With an account with only user privileges, as the user account may not have access to quite a few locations, may cause delay in application launch and an event 11708 stating an installation failure.
   > 
   > Win32reg_AddRemovePrograms is a much lighter and effective way to do this, which avoids the calls to do a resiliency check, especially in a locked down environment. So when using Win32reg_AddRemovePrograms we will not be calling on msiprov.dll and will not be initiating a resiliency check.

#### Roger Lipscombe's answer: https://stackoverflow.com/a/450043/1040437
> If you look in the registry under `HKEY_CLASSES_ROOT\.msi`, 
> you'll see that .MSI files are associated with the `ProgID` "`Msi.Package`". 
> If you look in `HKEY_CLASSES_ROOT\Msi.Package\shell\Open\command`, 
> you'll see the command line that Windows actually uses when you "run" a .MSI file.

This answer is cool because it demonstrates the fact that MSI is basically a COM-based object model, by cluing you into exactly how its modeled in the registy as a ProgId.

### How can I find the Product GUID of an installed MSI? https://stackoverflow.com/questions/29937568/how-can-i-find-the-product-guid-of-an-installed-msi-setup

#### Stein Asmul's answer: https://stackoverflow.com/a/29937569/1040437

Stein mentions several different approaches. My favorite is 

### What is the purpose of administrative installation initiated using msiexec /a? https://stackoverflow.com/questions/5564619/what-is-the-purpose-of-administrative-installation-initiated-using-msiexec-a

#### Answer

> In the real world, it doesn't have all that much value at all. MSI was designed back in a day when a computer typically had a 2-20gb hard drive. They came up with all these "run from source" advertisement scenarios which seemed really cool back then but never really caught on in the real world (except for large-scale corporate deployments).
> 
> Today, what /a does for me, a setup developer, is give me an easy way to "extract" an MSI and verify its contents. That's about it.
