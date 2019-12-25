```powershell
Set-ItemProperty -Path HKLM:\Software\Microsoft\Fusion -Name ForceLog         -Value 1               -Type DWord
Set-ItemProperty -Path HKLM:\Software\Microsoft\Fusion -Name LogFailures      -Value 1               -Type DWord
Set-ItemProperty -Path HKLM:\Software\Microsoft\Fusion -Name LogResourceBinds -Value 1               -Type DWord
Set-ItemProperty -Path HKLM:\Software\Microsoft\Fusion -Name LogPath          -Value 'C:\FusionLog\' -Type String
mkdir C:\FusionLog -Force
```
