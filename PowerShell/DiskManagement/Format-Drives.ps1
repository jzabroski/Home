Import-Module Storage;
 
function Format-Drives
{
    # See https://stackoverflow.com/a/42621174/1040437 (Formatting a disk using PowerShell without prompting for confirmation)
    $currentconfirm = $ConfirmPreference
    $ConfirmPreference = 'none'
 
    Get-Disk | Where isOffline | Set-Disk -isOffline $false
    # The next line of this script is (almost) copy-pasted verbatim from: https://blogs.technet.microsoft.com/heyscriptingguy/2013/05/29/use-powershell-to-initialize-raw-disks-and-to-partition-and-format-volumes/
    Get-Disk | Where partitionstyle -eq 'raw' | Initialize-Disk -PartitionStyle MBR -Confirm:$false -PassThru | New-Partition -AssignDriveLetter -UseMaximumSize -IsActive | Format-Volume -FileSystem NTFS -AllocationUnitSize 64kb -Confirm:$false
 
    # See https://stackoverflow.com/a/42621174/1040437 (Formatting a disk using PowerShell without prompting for confirmation)
    $ConfirmPreference = $currentconfirm
}
 
Format-Drives
