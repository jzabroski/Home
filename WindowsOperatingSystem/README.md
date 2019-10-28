# Gotchas

## Batch Scripting Gotchas

1. `title <Your Window Title>` does not work if you "Run In Hidden Window" ([CREATE_NO_WINDOW flag as part of the CreateProcess call](https://stackoverflow.com/a/780647/1040437)).
2. `taskkill.exe` is not _guaranteed_ to kill a process.  Some considerations:
    - If the process you are trying to kill is in a different desktop session from your own.
    - If the process was started in "session 0". As I understand, if anl application is running in Session-0, preventing the object from being closed by the script running in the user session
        - ex: runas /noprofile /user:DOMAIN\WHOEVER c:\Windows\Syswow64\cscript.exe c:\path\to\your\vbs\script.vbs
        - See also: [Session 0 Isolation](https://docs.microsoft.com/en-us/windows/win32/services/service-changes-for-windows-vista#SESSION_0_ISOLATION) changes made in Windows Vista that impact whether services run in Session-0 or not.
    - If the process you are trying to kill is in the foreground, but the process killing it is in the background using "Run In Hidden Window".
3. `tasklist.exe` can accept multiple filters by specifying `/fi "YourFilter eq YourValue"` multiple times:
    - `tasklist.exe /fi "WindowTitle eq Administrator*" /fi "ImageName eq powershell.exe"`
        - will return all PowerShell Classic instances with a WindowTitle that implies (but not guarantees) its running as administrator.
4. `tasklist.exe` has a `/v` which will tell you the WindowTitle
