```powershell
# Write-Callstack https://stackoverflow.com/a/15398687/1040437
function Write-CallStack([System.Management.Automation.ErrorRecord]$ErrorRecord=$null, [int]$Skip=1)
{
    Write-Host # blank line
    if ($ErrorRecord)
    {
        Write-Host -ForegroundColor Red "$ErrorRecord $($ErrorRecord.InvocationInfo.PositionMessage)"
        if ($ErrorRecord.Exception)
        {
            Write-Host -ForegroundColor Red $ErrorRecord.Exception
        }
        if ((Get-Member -InputObject $ErrorRecord -Name ScriptStackTrace) -ne $null)
        {
            #PS 3.0 has a stack trace on the ErrorRecord; if we have it, use it & skip the manual stack trace below
            Write-Host -ForegroundColor Red $ErrorRecord.ScriptStackTrace
            return
        }
    }
    Get-PSCallStack | Select -Skip $Skip | % {
        Write-Host -ForegroundColor Yellow -NoNewLine "! "
        Write-Host -ForegroundColor Red $_.Command $_.Location $(if ($_.Arguments.Length -le 80) { $_.Arguments })
    }
}
```
