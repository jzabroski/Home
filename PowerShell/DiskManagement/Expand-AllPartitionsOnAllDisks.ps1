# NOTE: This won't work on legacy drive types that are no longer supported by the Windows Storage Management APIs.
Import-Module Storage;

$disks = Get-Disk | Where FriendlyName -ne "Msft Virtual Disk";

foreach ($disk in $disks)
{
    $DiskNumber = $disk.DiskNumber;
    $Partition = Get-Partition -DiskNumber $disk.DiskNumber;

    $PartitionActualSize = $Partition.Size;
    $DriveLetter = $Partition.DriveLetter;
    $PartitionNumber = $Partition.PartitionNumber
    $PartitionSupportedSize = Get-PartitionSupportedSize -DiskNumber $DiskNumber -PartitionNumber $PartitionNumber;

    if ($disk.IsReadOnly)
    {
        Write-Host -ForegroundColor DarkYellow "Skipping drive letter [$DriveLetter] partition number [$PartitionNumber] on disk number [$DiskNumber] because the disk is read-only!";
        continue;
    }

    if ($PartitionActualSize -lt $PartitionSupportedSize.SizeMax) {
        # Actual Size will be greater than the partition supported size if the underlying Disk is "maxed out".
        # For example, on a 50GB Volume, if all the Disk is partitioned, the SizeMax on the partition will be 53684994048.
        # However, the full Size of the Disk, inclusive of unpartition space, will be 53687091200.
        # In other words, it will still be more than partition and unlikely to ever equal the partition's MaxSize.
        Write-Host -ForegroundColor Yellow "Resizing drive letter [$DriveLetter] partition number [$PartitionNumber] on disk number [$DiskNumber] because `$PartitionActualSize [$PartitionActualSize] is less than `$PartitionSupportedSize.SizeMax [$($PartitionSupportedSize.SizeMax)]"

        Resize-Partition -DiskNumber $DiskNumber -PartitionNumber $PartitionNumber -Size $PartitionSupportedSize.SizeMax -Confirm:$false -ErrorAction SilentlyContinue -ErrorVariable resizeError
        Write-Host -ForegroundColor Green $resizeError
    }
    else {
        Write-Host -ForegroundColor White "The partition is already the requested size, skipping...";
    }
}
