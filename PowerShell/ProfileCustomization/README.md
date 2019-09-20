# PowerShell: Make numbers print with thousands grouping by default

Tags: output formatting, number formatting, numeric

Two approaches:
1. Via the PowerShell ETS (Extended Type System)
2. By overriding `Out-Default`

## Option A: Overriding the `.ToString()` method for numeric types:

Note: This approach is convenient, but has side effects: all code in the session will see the modified `.ToString()` output (but PowerShell's string interpolation is not affected.
That is, for instance, `(1000).ToString()` is affected, but `"$(1000)"` is not.

```
[int16], [int], [long], [double], [decimal], [bigint], [uint16], [uint], [uint64] | % {

  Update-TypeData -TypeName $_.FullName  -MemberType ScriptMethod -MemberName ToString -Value { 
    # Determine how many decimal places there are in the original representation.
    # Note: PowerShell's string interpolation uses the *invariant* culture, so '.'
    #       can reliably be assumed to be the decimal mark.
    $numDecimalPlaces = ("$this" -replace '^[^.]+(?:.(.+))?', '$1').Length
    # Format with thousands grouping and the same number of decimal places.
    # Note: This will create a culture-sensitive representation
    #       just like with the default output formatting.
    "{0:N$numDecimalPlaces}" -f $this.psobject.BaseObject
  } -Force

}
```

Put the above in your `$PROFILE` file, start a new session and run:

```powershell
PS> 1000; 1000.123
1,000
1,000.123
```

## Option B: Overriding the `Out-Default` cmdlet:

Note: This approach has no side effects, but is more elaborate.

Overriding the `Out-Default` cmdlet with a proxy (wrapper) function allows you to control the output formatting for all output.

```powershell
function Out-Default {
  <#
  .SYNOPSIS
  Wrapper command for the Out-Default cmdlet that outputs numbers with 
  thousands grouping.  
  #>
  [CmdletBinding()]
  param(
    [switch]
    ${Transcript},
  
    [Parameter(ValueFromPipeline = $true)]
    [psobject]
    ${InputObject})
  
  begin {
    try {
      $outBuffer = $null
      if ($PSBoundParameters.TryGetValue('OutBuffer', [ref]$outBuffer)) {
        $PSBoundParameters['OutBuffer'] = 1
      }
  
      $wrappedCmd = $ExecutionContext.InvokeCommand.GetCommand('Microsoft.PowerShell.Core\Out-Default', [System.Management.Automation.CommandTypes]::Cmdlet)
      $scriptCmd = { & $wrappedCmd @PSBoundParameters }
  
      $steppablePipeline = $scriptCmd.GetSteppablePipeline($myInvocation.CommandOrigin)
      $steppablePipeline.Begin($PSCmdlet)
    }
    catch {
      throw
    }
  }
  
  process {
    try {
      if ($_.GetType() -in [int16], [int], [long], [double], [decimal], [bigint], [uint16], [uint], [uint64]) {

        # Determine how many decimal places there are in the original representation.
        # Note: PowerShell's string interpolation uses the *invariant* culture, so '.'
        #       can reliably be assumed to be the decimal mark.
        $numDecimalPlaces = ("$_" -replace '^[^.]+(?:.(.+))?', '$1').Length
        # Format with thousands grouping and the same number of decimal places.
        # Note: This will create a culture-sensitive representation
        #       just like with the default output formatting.
        # & $wrappedCmd @PSBoundParameters -InputObject ()
        $steppablePipeline.Process("{0:N$numDecimalPlaces}" -f $_.psobject.BaseObject)

      }
      else {          
        $steppablePipeline.Process($_)
      }
    }
    catch {
      throw
    }
  }
  
  end {
    try {
      $steppablePipeline.End()
    }
    catch {
      throw
    }
  }
  
}
```

Put the above in your `$PROFILE` file, start a new session and run:

```powershell
PS> 1000; 1000.123
1,000
1,000.123
```
