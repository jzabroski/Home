
function Update-DriveLetter
{
  param ([char]$letter,[char]$newLetter)
  Get-CimInstance -Query "SELECT * FROM Win32_Volume WHERE driveletter='$letter`:'" | Set-CimInstance -Arguments @{DriveLetter="$newletter`:"}
}
