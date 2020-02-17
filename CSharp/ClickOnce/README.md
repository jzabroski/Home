1. To determine if an application is a ClickOnce application, use `ApplicationDeployment.IsNetworkDeployed`
2. There is a bug in ClickOnce API where after 65536 calls to check for updates, an exception is thrown.
    1. See: https://social.msdn.microsoft.com/Forums/en-US/d9183f7e-f5c7-46d0-8bb4-411ad923976c
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
