https://docs.microsoft.com/en-us/sql/relational-databases/native-client-odbc-how-to/profiling-odbc-driver-performance-data?view=sql-server-2017

```powershell
# DiskSpd: https://gallery.technet.microsoft.com/DiskSpd-a-robust-storage-6cd2f223
# https://blogs.technet.microsoft.com/josebda/2015/07/03/drive-performance-report-generator-powershell-script-using-diskspd-by-arnaud-torres/

# Drive performance Report Generator
# by Arnaud TORRES
# Microsoft provides script, macro, and other code examples for illustration only, without warranty either expressed or implied, including but not
# limited to the implied warranties of merchantability and/or fitness for a particular purpose. This script is provided 'as is' and Microsoft does not
# guarantee that the following script, macro, or code can be used in all situations.
# Script will stress your computer CPU and storage, be sure that no critical workload is running

# Clear screen

Clear

Write-Host "DRIVE PERFORMANCE REPORT GENERATOR" -ForegroundColor Green

Write-Host "Script will stress your computer CPU and storage layer (including network if applciable !), be sure that no critical workload is running" -foregroundcolor yellow

Write-Host "Microsoft provides script, macro, and other code examples for illustration only, without warranty either expressed or implied, including but not limited to the implied warranties of merchantability and/or fitness for a particular purpose. This script is provided 'as is' and Microsoft does not guarantee that the following script, macro, or code can be used in all situations." -foregroundcolor darkred

"   "

"Test will use all free space on drive minus 2 GB !"

"If there are less than 4 GB free test will stop"

# Disk to test

$Disk = Read-Host 'Which disk would you like to test ? (example : D:)'

# $Disk = "D:"

if ($disk.length -ne 2) {
  "Wrong drive letter format used, please specify the drive as D:"
  Exit
}


if ($disk.substring(1,1) -ne ":") {
  "Wrong drive letter format used, please specify the drive as D:"
  Exit
}

$disk = $disk.ToUpper()

# Reset test counter

$counter = 0

# Use 1 thread / core
$Thread = "-t"+(Get-WmiObject win32_processor).NumberofCores

# Set time in seconds for each run
# 10-120s is fine

$Time = "-d1"

# Outstanding IOs
# Should be 2 times the number of disks in the RAID
# Between  8 and 16 is generally fine

$OutstandingIO = "-o16"

# Disk preparation
# Delete testfile.dat if it exists
# The test will use all free space -2GB

$IsDir = test-path -path "$Disk\TestDiskSpd"
$isdir

if ($IsDir -like "False") {
  New-Item -ItemType Directory -Path "$Disk\TestDiskSpd\"
}

# Just a little security, in case we are working on a compressed drive ...

compact /u /s $Disk\TestDiskSpd\

$Cleaning = test-path -path "$Disk\TestDiskSpd\testfile.dat"

if ($Cleaning -eq "True") {
  "Removing current testfile.dat from drive"
  remove-item $Disk\TestDiskSpd\testfile.dat
}

$Disks = Get-WmiObject win32_logicaldisk

$LogicalDisk = $Disks | where {$_.DeviceID -eq $Disk}

$Freespace = $LogicalDisk.freespace

$FreespaceGB = [int]($Freespace / 1073741824)
$Capacity = $freespaceGB - 2
$CapacityParameter = "-c"+$Capacity+"G"
$CapacityO = $Capacity * 1073741824

if ($FreespaceGB -lt "4")
{
  "Not enough space on the Disk ! More than 4GB needed"
  Exit
}

write-host " "

$Continue = Read-Host "You are about to test $Disk which has $FreespaceGB GB free, do you wan't to continue ? (Y/N) "

if ($continue -ne "y" -or $continue -ne "Y") {
  "Test Cancelled !!"
  Exit
}

"   "

"Initialization can take some time, we are generating a $Capacity GB file..."

"  "

# Initialize outpout file

$date = get-date

# Add the tested disk and the date in the output file

"Disque $disk, $date" >> ./output.txt

# Add the headers to the output file

"Test N#, Drive, Operation, Access, Blocks, Run N#, IOPS, MB/sec, Latency ms, CPU %" >> ./output.txt

# Number of tests
# Multiply the number of loops to change this value
# By default there are : (4 blocks sizes) X (2 for read 100% and write 100%) X (2 for Sequential and Random) X (4 Runs of each)
$NumberOfTests = 64

"  "

Write-Host "TEST RESULTS (also logged in .\output.txt)" -ForegroundColor Yellow

# Begin Tests loops
# We will run the tests with 4K, 8K, 64K and 512K blocks

(4,8,64,512) | % { 
  $BlockParameter = ("-b"+$_+"K")
  $Blocks = ("Blocks "+$_+"K")
  # We will do Read tests and Write tests
  (0,100) | % {
    if ($_ -eq 0)
    {
      $IO = "Read"
    }


    if ($_ -eq 100)
    {
      $IO = "Write"
    }
    
    $WriteParameter = "-w"+$_

    # We will do random and sequential IO tests
    ("r","si") | % {
      if ($_ -eq "r")
      {
        $type = "Random"
      }

      if ($_ -eq "si")
      {
        $type = "Sequential"
      }

      $AccessParameter = "-"+$_

      # Each run will be done 4 times
      (1..4) | % {
        # The test itself (finally !!)
        $result = .\diskspd.exe $CapacityPArameter $Time $AccessParameter $WriteParameter $Thread $OutstandingIO $BlockParameter -h -L $Disk\TestDiskSpd\testfile.dat
        # Now we will break the very verbose output of DiskSpd in a single line with the most important values
        foreach ($line in $result)
        {
          if ($line -like "total:*")
          {
            $total=$line; break
          }
        }
        
        foreach ($line in $result)
        {
          if ($line -like "avg.*")
          {
            $avg=$line; break
          }
        }

        $mbps = $total.Split("|")[2].Trim()

        $iops = $total.Split("|")[3].Trim()

        $latency = $total.Split("|")[4].Trim()

        $cpu = $avg.Split("|")[1].Trim()

        $counter = $counter + 1

        # A progress bar, for the fun
        Write-Progress -Activity ".\diskspd.exe $CapacityPArameter $Time $AccessParameter $WriteParameter $Thread $OutstandingIO $BlockParameter -h -L $Disk\TestDiskSpd\testfile.dat" -status "Test in progress" -percentComplete ($counter / $NumberofTests * 100)

        # Remove comment to check command line ".\diskspd.exe $CapacityPArameter $Time $AccessParameter $WriteParameter $Thread -$OutstandingIO $BlockParameter -h -L $Disk\TestDiskSpd\testfile.dat"
        
        # We output the values to the text file
        "Test $Counter,$Disk,$IO,$type,$Blocks,Run $_,$iops,$mbps,$latency,$cpu"  >> ./output.txt

        # We output a verbose format on screen


        "Test $Counter, $Disk, $IO, $type, $Blocks, Run $_, $iops iops, $mbps MB/sec, $latency ms, $cpu CPU"
      }
    }
  }
}
```
