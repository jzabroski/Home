# "The process cannot access the file '<fullFilePath>' because it is being used by another process."
1. Use LockHunter `cinst -y lockhunter`
2. If LockHunter shows it is open by WMIPrvSE.exe, then see: [Is WMIprvse a real villain?](https://blogs.msdn.microsoft.com/wmi/2009/05/26/is-wmiprvse-a-real-villain/) for steps on enable logging to the WMI-Activity Trace log.
