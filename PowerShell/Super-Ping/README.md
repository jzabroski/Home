Several approaches:

1. Boe Prox's [Test-ConnectionAsync](https://github.com/proxb/AsyncFunctions/blob/master/Test-ConnectionAsync.ps1)
    1. Uses [System.Net.NetworkInformation.Ping](https://docs.microsoft.com/en-us/dotnet/api/system.net.networkinformation.ping?view=netcore-2.2) class and the `SendPingAsync` method to leverage the Task Parallel Library (TPL) to maximize network throughput.
2. Warren's [Invoke-Ping](https://github.com/RamblingCookieMonster/PowerShell/blob/master/Invoke-Ping.ps1)
    1. Creates a bunch of PowerShell `RunSpace`s and then concatenates together the RunSpace outputs into a single output in the parent runspace.
    2. For information on using RunSpace for parallel processing, see: [Beginning parallel processing in PowerShell](https://hkeylocalmachine.com/?p=612)
3. Idera's [Test-OnlineFast](https://community.idera.com/database-tools/powershell/powertips/b/tips/posts/final-super-fast-ping-command)
    1. Composes a single WMI query with all machine names and executes that.  Ergo, porting to C# is trivial and does not require using TPL in order to make parallel.

On 206 computers, `Test-ConnectionAsync` was the fastest by far (3 seconds), followed by Invoke-Ping (17 seconds), followed by Test-OnlineFast (90 seconds).
