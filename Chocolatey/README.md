# Benchmarking Fast - Via Installing tools via Chocolatey

TIP: When benchmarking, it is a good idea to use several different benchmark programs, as some may have bugs. For example, CrystalDiskMark was great for mechanical hard drives, but NVMe SSDs have exposed potential bugs in its timing data. See also https://github.com/aerospike/act/blob/master/README.md

# Get List of All Packages Installed on a System

```powershell
choco.exe list --local-only --all-versions --include-programs
```

# Upgrading Chocolatey - RUN AS ADMINISTRATOR

```powershell
choco upgrade chocolatey -y
```

# Chocolatey Update-SessionEnvironment
https://chocolatey.org/docs/helpers-update-session-environment

```powershell
# Import-Module "$env:ChocolateyInstall\helpers\chocolateyInstaller.psm1" -Force;
Update-SessionEnvironment
```

If Update-SessionEnvironment doesn't work, try ensuring your PowerShell Profile loads the "Chocolatey Profile".  Another symptom of this problem is "[I can't get the PowerShell Tab Completion working](https://chocolatey.org/docs/troubleshooting#i-cant-get-the-powershell-tab-completion-working)".

```powershell
if (-not Test-Path $profile) { New-Item $profile -Force }

@'
# Chocolatey profile
$ChocolateyProfile = "$env:ChocolateyInstall\helpers\chocolateyProfile.psm1"
if (Test-Path($ChocolateyProfile)) {
  Import-Module "$ChocolateyProfile"
}
'@ >> $profile
```

# Chocolatey Package Authoring Extensions

In the Chocolatey Package Search, if you start your search with `id:` it will match the package ID. If you want to search for all extension packages, use [`id:.extension`](https://chocolatey.org/packages?q=id%3A.extension)

# bcurran3's Chocolatey GitHub projects

1. https://github.com/bcurran3/ChocolateyPackagingUtils - Utils/Scripts for updating misc Chocolatey package files
2. https://github.com/bcurran3/ChocolateyTemplates - My Chocolatey package templates
3. https://github.com/bcurran3/ChocolateyPackages - bcurran3's published Chocolatey packages


# List of Tools I Use
    # Messaging
    telegram.install 1.9.21 # NEVER USED. Cloud-based synchronized messaging app with a focus on speed and security
    
    # Bootstrap Chocolatey
    chocolatey 0.10.15
    chocolatey-core.extension 1.3.5.1 # These functions may be used in Chocolatey install/uninstall scripts by declaring this package a dependency in your package's nuspec.
    chocolatey-dotnetfx.extension 1.0.1 # Helper functions useful for developing packages for Microsoft .NET Framework runtime and Developer Pack.
    chocolatey-windowsupdate.extension 1.0.4 # Helper functions useful for developing packages for Windows updates (KBs).
    chocolatey-misc-helpers.extension 0.0.3.1 # Chocolatey Misc Helpers Extension is a collection of helper functions for package creators/maintainers.
    chocolatey-preinstaller-checks.extension 0.0.2.1 # Chocolatey Preinstaller Checks Extension is a Chocolatey extension that intercepts
                                                     # and runs checks before installing or uninstalling a program. This extension will
                                                     # start working automatically once installed and does NOT need to be implemented by
                                                     # package creators/maintainers. Chocolatey Preinstaller Checks Extension is meant to
                                                     # be installed and used directly by Chocolatey end users.

    
    # Archive / Compression Utilities
    7zip 19.0
    7zip.install 19.0
    PeaZip 7.1.1 # https://chocolatey.org/packages/peazip
    
    
    # Command Line Terminals
    clink 0.4.9 # https://github.com/mridgers/clink cmd.exe replacement, supports logging cmd.exe commands system wide
    ConEmu 19.10.12.0 # https://chocolatey.org/packages/ConEmu Console Emulator with panes, tabs, tasks, jump lists, quake style, handy text and block selection, handy paste of paths in either Unix or Windows notation, and much more.
    microsoft-windows-terminal 0.10.761.0 # Windows Terminal is a new, modern, feature-rich, productive terminal application for command-line users. 
    
    
    # System Administration Utilities
    cports 2.60 # https://www.nirsoft.net/utils/cports.html CurrPorts utility for tracing network ports.  Powerful incremental filter.
    jdupes 1.13.2  # A powerful duplicate file finder and an enhanced fork of 'fdupes'.
    lockhunter 3.3.4 # LockHunter is a foolproof file unlocker
    rsat 2.1809.0.20190205 # Remote Server Administration Tools (aka aduc) - active directory users and computers
    sysinternals 2019.12.19 #  https://chocolatey.org/packages/sysinternals
    sysexp 1.75  # https://chocolatey.org/packages/sysexp - SysExporter - Grab data from list-view, tree-view, combo box, WebBrowser control, and text-box. 
    lessmsi 1.6.91  # LessMSI - Easily extract the contents of an MSI
    terminals 4.0.1   # Terminals multitab remote control client. See https://github.com/Terminals-Origin/Terminals 
    putty.install 0.73  # PuTTY is a free implementation of Telnet and SSH for Windows and Unix platforms, along with an xterm terminal emulator.
    winscp 5.17.2.20200316 # WinSCP is an open source free SFTP client, SCP client, FTPS client and FTP client for Windows. Its main function is file transfer between a local and a remote computer. Beyond this, WinSCP offers scripting and basic file manager functionality.


        
    # Document Reader
    adobereader 2020.006.20042 # Adobe Acrobat Reader DC 2020.006.20042 - 290 million downloads


    # FTP Utilities
    cyberduck.install 6.4.6.27773  # FTP / CloudStorage / WebDAV client
    filezilla 3.47.2.1             # FileZilla
    
    
    # Performance Management
    cpu-z.install 1.91         # CPU tester
    diskmarkstream 1.1.2       # Disk I/O
    iometer 1.1.0.20161009     # Disk I/O
    crystaldiskmark 6.0.2      # Disk I/O
    k6 0.26.1                  # Web Load Testing Tool
    whysoslow 1.00             # Analyzes existing crash dumps and tries to determine and state the root cause in easy to understand language.


    # Web Browers
    firefox  74.0                 #  Mozilla Firefox 74.0
    googlechrome 80.0.3987.149    # Google Chrome 80.0.3987.149
    
    
    # Password Managers
    dashlane 6.2007.0.32704 # Slightly behind official latest version
    dashlane-chrome 1.0.0 # Version number is not correct + install doesnt work.


    # .NET Development Stack
    DotNet4.5.2  4.5.2.20140902 # .NET Framework 4.5.2
    netfx-4.8-devpack 4.8.0.20190930 # .NET Framework 4.8 Developer Pack
    netfx-4.8 4.8.0.20190930 # .NET Framwork 4.8 Runtime
    dotnetcore-sdk 3.1.200
    docker-desktop 2.2.0.4
    linqpad (linqpad5.install) 5.41
    resharper-ultimate-all 2019.3.4  # Not the official version by JetBrains, but slightly more actively maintained.
    vcredist2010 10.0.40219.2 # Microsoft Visual C++ 2010 Redistributable Package 10.0.40219.2
    vcredist2015 14.0.24215.20170201 # Microsoft Visual C++ Redistributable for Visual Studio 2015 Update 3 (with hotfix 2016-09-14) 14.0.24215.20170201
    visualstudio2017buildtools 15.9.11.0 https://chocolatey.org/packages/visualstudio2017buildtools
    choco install visualstudio2019community 16.5.0.0 # Visual Studio 2019 Community Edition
    visualstudio2019professional            16.5.0.0 # Visual Studio 2019 Professional Edition
    visualstudio2019buildtools              16.5.0.0 # Visual Studio 2019 Build Tools
    windows-sdk-10.1                    10.1.18362.1 # Microsoft Windows SDK for Windows 10 and .NET Framework 4.7 10.1.18362.1
    vscode 1.43.1   
    postman 7.20.1 # Postman for Windows 7.20.1
    papercut 5.1.44  # Papercut SMTP Proxy (for testing)


    # SQL 
    ssms                   15.0.18206.0  # SQL Server Management Studio 18.4 15.0.18206.0
    azure-data-studio      1.16.0        # Azure Data Studio
    azure-data-studio-sql-server-admin-pack 0.0.1 # Admin Pack for SQL Server for Azure Data Studio
    vscode-mssql           1.6.0         # Develop Microsoft SQL Server, Azure SQL Database and SQL Data Warehouse everywhere

    # RedGate SQL Tools
    dotnetdeveloperbundle  2020.03.16  # .NET Developer Bundle 2020.03.16
    sqltoolbelt            2020.03.18  # SQL Toolbelt 2020.03.18
    sqlsearch              2019.12.19  # SQL Search 2019.12.19


    # Git / Subversion
    github-desktop 2.3.1 https://chocolatey.org/packages/github-desktop
    gitkraken 6.5.1
    tortoisesvn 1.13.1.28686
    
    
    # Java 
    jdk8 8.0.211
    jre8 8.0.231   # This package is more actively maintained than javaruntime package


    # Editors
    notepadplusplus 7.8.5
    notepadplusplus.install 7.8.5
 
 
    # Screenshot / Picture Editing
    paint.net 4.2.10
 
 
    # Continuous Deployment / Deliver
    OctopusTools 7.3.0
    nsis 3.5.0.20200106   # Nullsoft Scriptable Install System
    
    # PowerShell
    powershell-core 7.0.0 # https://chocolatey.org/packages/powershell-core/
    
    
    # Python Stuff
    pip 1.2.0                   # Pip(Python) Installs Packages 1.2.0
    PyCharm-community 2019.3.3  # JetBrains PyCharm (Install) 2019.3.3
    python2 2.7.17              # Python 2.x
    python3 3.8.2               # Python 3.x 3.8.2
    miniconda3 4.7.12.1         # Miniconda (Python 3) 4.7.12.1
    
    
    # R statistics stuff
    R.Studio 1.2.5033
    

    # Modeling / Validating Models
    spawner 0.2.4  # Spawner is a tool for generating test data suitable for populating databases.
    staruml3 3.2.0
    
    
    # Email Client
    thunderbird 68.6.0

    # Other
    windowclippings 3.1.131 # NOT MODERATOR APPROVED https://chocolatey.org/packages/windowclippings


# TODO

1. Packages
   1. Does Not Exist - TODO Create - https://www.userbenchmark.com/resources/download/UserBenchMark.exe
   2. Does Not Exist - TODO Create - https://totusoft.com/lanspeed
   3. Does Not Exist - TODO Create - DevArt CodeCompare
   4. Does Not Exist - TODO Create - Duo Authentication
   
# Chocolatey Packages
| PackageName | Description | Radar Positioning |
| ----------- | ----------- | ----------------- |
| treesizefree | TreeSize Free tells you where precious disk space has gone. | - |
| notepadplusplus | Text editor with nice syntax highlighting and search. | - |
| SysExporter | SysExporter utility allows you to grab the data stored in standard list-views, tree-views, list boxes, combo boxes, text-boxes, and WebBrowser/HTML controls from almost any application running on your system, and export it to text, HTML or XML file. | Incoming |
| PeaZip | PeaZip is free file archiver utility, based on Open Source technologies of 7-Zip, p7zip, FreeArc, PAQ, and PEA projects.<br/>Cross-platform, full-featured but user-friendly alternative to WinRar, WinZip and similar general purpose archive manager applications, open and extract 180+ archive formats: 001, 7Z, ACE(\*), ARC, ARJ, BZ2, CAB, DMG, GZ, ISO, LHA, PAQ, PEA, RAR, TAR, UDF, WIM, XZ, ZIP ZIPX - view full list of supported archive file formats for archiving and for extraction. | Incoming |
