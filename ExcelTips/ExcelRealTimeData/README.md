# Excel RTD Servers
1. [Kerry Kerr: Excel RTD Servers: Minimal C# Implementation](https://weblogs.asp.net/kennykerr/Rtd3)
2. [Kerry Kerr: Excel RTD Servers: Multiple Topics in C#](https://weblogs.asp.net/kennykerr/Rtd6)
3. [Kerry Kerr: Excel RTD Servers: C# without the Excel Assembly Reference](https://weblogs.asp.net/kennykerr/Rtd7)
4. [Kerry Kerr: Excel RTD Servers: How to use UpdateNotify Properly](https://weblogs.asp.net/kennykerr/Rtd8)
5. [Kerry Kerr: Excel RTD Servers: A Topic’s Initial Value](https://weblogs.asp.net/kennykerr/Rtd9)
6. [Answer to StackOverflow Question: How do I create a real-time Excel automation add-in in C# using RtdServer?
](https://stackoverflow.com/a/5697823/1040437)
    > (As an alternative to the approach described below you should consider using Excel-DNA. Excel-DNA allows you to build a registration-free RTD server. COM registration requires administrative privileges which may lead to installation headaches. That being said, the code below works fine.)
    > To create a real-time Excel automation add-in in C# using RtdServer:
7. [Excel-DNA/Samples/../RtdClocks](https://github.com/Excel-DNA/Samples/tree/master/RtdClocks)
8. [Excel-DNA/Samples/../RtdArrayTest](https://github.com/Excel-DNA/Samples/tree/master/RtdArrayTest)

# Excel Add-ins (In General)
There are 5 ways let VBA call C# code:
1. with COM Interop
    > Introduced in Excel 2000.
    > When you are working with COM Interop you need to define an interface and a class.
    > Both the interface and the class need to have additional attributes added to them.
    > Once the C# dll has been built it needs to be added to the registry using the RegAsm tool.
2. with COM Add-ins
    > Introduced in Excel 2000.
    > COM Add-ins must implement the Extensibility.IDTExtensibility2 interface.
    > If you want an add-in to appear in the COM Add-ins dialogs then it must implement this interface.
    > Once the C# dll has been built it needs to be added to the registry using the RegAsm tool.
    > In addition to the normal COM Interop registration the dll must also be registered with Microsoft Office.
    > This requires adding another registry key under HKEY_CURRENT_USER.
3. with Automation Add-ins
    > Introduced in Excel 2002.
    > Automation add-ins must implement the System.Runtime.InteropServices.UnmanagedType.IDispatch interface.
    > Automation add-ins are loaded by the mscoree.dll.
    > The IDispatch interface is derived from the basic IUnknown COM interface.
    > Once the C# dll has been built it needs to be added to the registry using the RegAsm tool.
    > In addition to the normal COM Interop registration an additional registry entry is needed to register the functions.
    > This requires adding two additional class methods with the corresponding ComRegisterFunction attributes.
    > Excel will only recognise a COM Add-in as an Automation Add-in when the "Programmable" subkey is in the registry.
4. with VSTO Add-ins
    > Introduced in Excel 2007.
    > VSTO Add-ins must implement the IStartup interface.
5. Register for COM Interop
    > Allows your managed .NET assembly to be accessible from an unmanaged COM library
    > This option will cause Visual Studio to automatically register your assembly as a COM component in the windows registry when the project is compiled.
    > Registering for COM Interop requires administrator permissions.
    > You must be running Visual Studio as an administrator
    >
    > If you don't check this option you can still generate a COM wrapper by using tlbexe.exe and register your library manually by using regasm.exe
    > You must also configure the Setup project to register the assembly for COM Interop when it is installed.
    > In the properties window for the primary output make sure that Register is set to vsdrpCOM.

See also: [Add or remove add-ins in Excel](https://support.office.com/en-us/article/add-or-remove-add-ins-in-excel-0af570c4-5cf3-4fa9-9b88-403625a0b460)

* Covers 3 approaches:
    1. Excel add-in (see: http://www.cpearson.com/excel/CreateAddIn.aspx)
    2. COM add-in
    3. Automation add-in (see: http://www.cpearson.com/excel/automationaddins.aspx for more information; it was introduced in Excel XP (2002))