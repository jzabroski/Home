1. To determine if an application is a ClickOnce application, use `ApplicationDeployment.IsNetworkDeployed`
2. There is a bug in ClickOnce API where after 65536 calls to check for updates, an exception is thrown.
    1. See: https://social.msdn.microsoft.com/Forums/en-US/d9183f7e-f5c7-46d0-8bb4-411ad923976c
    2. See also bottom of this article for full response from Microsoft Support, provided by James Miles.
3. Therefore, recommendation is to cache the properties (`UpdateLocation` and `CurrentVersion`) from `ApplicationDeployment.CurrentDeployment` so its only called once per application run.
4. Then, manually check the ClickOnce manifest using the cached `UpdateLocation`.
    ```c#
    //Used to use the Clickonce API but we've uncovered a pretty serious bug which results in a COMException and the loss of ability
    //to check for updates. So until this is fixed, we're resorting to a very lo-fi way of checking for an update.
    var manifestFile = new WebClient().DownloadString(updateLocation);
    var xdoc = XDocument.Parse(manifestFile);
    XNamespace ns = "urn:schemas-microsoft-com:asm.v1";
    var versionString = xdoc.Descendants(ns + "assemblyIdentity").FirstOrDefault()?.Attribute("version")?.Value;
    var version = new Version(versionString);
    ```

#### Microsoft Support Response

> I have found the root cause of this issue.
> 
> When we call the `CheckForDetailedUpdate` function, it will create a new `DeploymentManager` internally and bind itself to some stored subscription states, like `CurrentBind`, `PreviousBind`, `IsolatedFilesystem`.
> 
> Every state will be get from internal store using the `GetDeploymentProperty` API and it will create a new instance of the internal data structure (`dfshim!_TSHANDLE_TYPE_DEFINITION_DESCRIPTION`). As there are many states stored internally, every call to the `GetDeploymentProperty` function will create many `dfshim!_TSHANDLE_TYPE_DEFINITION_DESCRIPTION` instances.
> 
> However, there is a limitation in the instance number of the `dfshim!_TSHANDLE_TYPE_DEFINITION_DESCRIPTION` data structure, which cannot be equal or larger than `0xffff` (65536 instances), and this is why we will encounter this issue after we call the `CheckForDetailedUpdate` function several hundred times. See the following information from the dump file:
> 
> ```
> dfshim!_TSHANDLE_TYPE_DEFINITION_DESCRIPTION
>    +0x000 Flags            : 0
>    +0x008 TypeName         : 0x00000000`00afe800  "IsolatedFilesystem"
>    +0x010 InstanceSize     : 8
>    +0x018 HeaderSize       : 0x28
>    +0x020 InstanceCount    : 0xfffe
>    +0x028 TypeContext      : (null)
>    +0x030 Allocator        : 0x00000642`ff538180     unsigned char  dfshim!tsh_DefaultTypeAllocator+0
>    +0x038 Deallocator      : 0x00000642`ff5381e0     void  dfshim!tsh_DefaultTypeDeallocator+0
>    +0x040 Constructor      : 0x00000642`ff4f3d80     unsigned char  dfshim!Windows::TypeSafeHandle::Provider::Rtl::CTsObject<Windows::Isolation::Fs::Private::CFsTraits>::Constructor+0
>    +0x048 Destructor       : 0x00000642`ff4f3e70     void  dfshim!Windows::TypeSafeHandle::Provider::Rtl::CTsObject<Windows::Isolation::Fs::Private::CFsTraits>::Destructor+0
>    +0x050 TypeId           : 5
>    +0x058 CriticalSection  : _RTL_CRITICAL_SECTION
>    +0x080 Objects          : BCL::CDeque<_TSHANDLE_INSTANCE_HEADER,8>
>    +0x0a8 Table            : 0x00000000`00b21cd2 Void
>    +0x0b0 MaxHandles       : 0xffff
>    +0x0b8 MaxInstances     : 0xffff
> ```
> 
> We can see the current `InstanceCount` is `0xfffe`, when we try to get the next property, the `InstanceCount` will add one and its value will be `0xffff` which equals to the `MaxInstances` (0xffff ) value here, and it will cause the issue.
> 
> As it is an internal code issue, I cannot provide a walk around at this time. I will report this issue to our product team and update you if I receive further information from them.
