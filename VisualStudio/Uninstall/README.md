Uninstalling Visual Studio can be a pain.  Here is what worked well for me, using PowerShell 7.0.3:

# Step 1 - Run InstallCleanup.exe -full
Note, this command can silently fail!  Make sure you don't have any open file handles to 
```powershell
 & 'C:\Program Files (x86)\Microsoft Visual Studio\Installer\resources\app\layout\InstallCleanup.exe' -full
```

# Step 2 - Forcibly Remove All Versions of Visual Studio
This step is required if you want to re-install Visual Studio, as Visual Studio 2019 Installer won't let you overwrite an existing install.

```powershell
rm -recurse -force "C:\Program Files (x86)\Microsoft Visual Studio\2019\Community"
rm -recurse -force "C:\Program Files (x86)\Microsoft Visual Studio\2019\Professional"
rm -recurse -force "C:\Program Files (x86)\Microsoft Visual Studio\2019\Enterprise"
```
