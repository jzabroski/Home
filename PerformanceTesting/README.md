https://blogs.msdn.microsoft.com/vancem/2012/12/20/how-many-samples-are-enough-when-using-a-sample-based-profiler-in-a-performance-investigation/

1. https://github.com/Microsoft/xunit-performance/issues/230#
2. And here: https://github.com/dotnet/coreclr/pull/16353#issuecomment-367117762
    > At some point I'd really like to see us get away from using mean and standard deviation and consistently use median and intra-quartile (or 5-95 quantile) ranges to summarize results -- these metrics are more relevant for non-normal distributions. For instance response time distribution is quite likely to be very left leaning and have a long right tail of stragglers. So average and standard deviation are misleading and noise prone as they pay too much attention to bad outliers. But we can sort that out later.
3. Here: https://github.com/dotnet/coreclr/pull/16353#issuecomment-367192130
    > Generally I have two pet peeves when it comes to summarizing data: assuming normality and using L2 (squared) distance metrics.
    >
    > The computation of confidence interval in MarginOfError95 does both: it assumes a normal distribution and uses squared errors. You have ample data here so you might want see how well it is described by a normal distribution. Maybe it is well described this way.
    > 
    > If you think L2 error bands are interesting you can use bootstrap resampling or some other non-parametric approach to compute them and not make any assumption at all about the distribution of the data. For response time this would give you asymmetric bands -- much larger on the right side than the left. Or you could try to parametrically fit some long tailed left leaning distribution. But that seems unnecessary as we don't have any particular theory as to what the exact shape should be.
    >
    > Fundamentally, I think L2 metrics are the wrong way to measure this stuff. IQR or quantiles use an L1 (absolute value) metric and so don't get as distracted by infrequent and unpredictable slow response times that are also likely to be uninteresting (eg GC kicked in or the machine decided it was time to do random thing X). Since we are going to use the results of these measurements to draw inferences it seems important that they reflect what we care about. There's no formula for L1 metrics like there is for L2, so you have to compute it by brute force, but it's not hard. Here you might still want to use bootstrap resampling to get some idea how stable the quantiles are, but generally quantiles are pretty stable things, provided you have a reasonable number of samples and don't have a pathologically bad distribution.
    >
    > All that being said, I'd much rather see us get a broader set of tests in place first, and only then refine and improve how we measure. So all this can wait.
4. https://github.com/dotnet/coreclr/pull/16353#issuecomment-367503160
    > > Just curious, although the true value of a sample may not be normally distributed, assuming ideally that all samples give a true value (minus all error), it seems like mean or median would not make a difference. However, the error that exists, isn't it likely that the error is normally distributed? Since the magnitude of error would (usually) dominate natural changes in the true value, wouldn't the mean/stderr be a representative summary of the true value (assuming the true value doesn't change much)?
    > >
    > > I have previously dealt with outliers by discarding samples outside a set confidence interval and that seemed to work quite well for a variety of similar applications (better than median/ranges). Perhaps there is something better that I'm not understanding, any pointers?
    >
    > If you know the thing you are measuring is normally distributed in your population then mean and standard deviation are fine. But much of the time the things we measure in the performance space are not distributed this way.
    > 
    > Run almost any benchmark and plot the resulting execution times and you'll see that there is a left-leaning distribution with a long tail to the right. And for those kinds of distributions the mean and standard deviation are not great summary metrics.
    > 
    > I think you would find using median and IQR or quartiles does more or less what you have been doing by manual inspection. They are naturally resistant to outliers in a way that mean/standard deviation are not and are well suited for skewed distributions.
    > 
    > I can't find a great writeup on this but will keep looking and update if I find one.

## Code Timing for Microbenchmarks:
https://blogs.msdn.microsoft.com/vancem/2006/09/21/measuring-managed-code-quickly-and-easiliy-codetimers/
https://github.com/Whathecode/Framework-Class-Library-Extension/blob/master/Whathecode.System/Diagnostics/RunTime.cs

https://blogs.msdn.microsoft.com/vancem/2006/10/01/drilling-into-net-runtime-microbenchmarks-typeof-optimizations/\
> Sandro Magi
> September 22, 2013 at 4:42 pm
> Your conclusions apply only to x86. x64 results are dramatically different. The conclusions also differ dramatically when you apply these tests to generic type parameters, instead of hard-coded types. See my recent post where I modified your benchmark suite:
> 
> higherlogics.blogspot.ca/…/clr-cost-of-dynamic-type-tests.html

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


https://www.baeldung.com/java-microbenchmark-harness - jmh. Java microbenchmark harness 