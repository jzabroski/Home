```powershell
choco.exe list --localy-only --all-versions --include-programs
```
TIP: When benchmarking, it is a good idea to use several different benchmark programs, as some may have bugs. For example, CrystalDiskMark was great for mechanical hard drives, but NVMe SSDs have exposed potential bugs in its timing data. See also https://github.com/aerospike/act/blob/master/README.md

    telegram.install 1.9.21 # NEVER USED. Cloud-based synchronized messaging app with a focus on speed and security
    
    7zip 19.0
    7zip.install 19.0
    adobereader 2020.006.20042 # Adobe Acrobat Reader DC 2020.006.20042 - 290 million downloads
    chocolatey 0.10.15
    chocolatey-core.extension 1.3.5.1 # These functions may be used in Chocolatey install/uninstall scripts by declaring this package a dependency in your package's nuspec.
    clink 0.4.9 # https://github.com/mridgers/clink cmd.exe replacement, supports logging cmd.exe commands system wide
    cports 2.60 # https://www.nirsoft.net/utils/cports.html CurrPorts utility for tracing network ports.  Powerful incremental filter.
    cpu-z.install 1.91
    ConEmu 19.10.12.0 # https://chocolatey.org/packages/ConEmu Console Emulator with panes, tabs, tasks, jump lists, quake style, handy text and block selection, handy paste of paths in either Unix or Windows notation, and much more.
    crystaldiskmark 6.0.2
    dashlane 6.2007.0.32704 # Slightly behind official latest version
    dashlane-chrome 1.0.0 # Version number is not correct
    diskmarkstream 1.1.2
    iometer 1.1.0.20161009
    cyberduck.install 6.4.6.27773 # FTP / CloudStorage / WebDAV client
    DotNet4.5.2  4.5.2.20140902 # .NET Framework 4.5.2
    netfx-4.8-devpack 4.8.0.20190930 # .NET Framework 4.8 Developer Pack
    netfx-4.8 4.8.0.20190930 # .NET Framwork 4.8 Runtime
    dotnetcore-sdk 3.1.200
    docker-desktop 2.2.0.4
    github-desktop 2.3.1 https://chocolatey.org/packages/github-desktop
    gitkraken 6.5.1
    jdk8 8.0.211
    jre8 8.0.231   # This package is more actively maintained than javaruntime package
    jdupes 1.13.2  # A powerful duplicate file finder and an enhanced fork of 'fdupes'.
    linqpad (linqpad5.install) 5.41
    lockhunter 3.3.4 # LockHunter is a foolproof file unlocker
    notepadplusplus 7.8.5
    notepadplusplus.install 7.8.5
    OctopusTools 7.3.0
    PeaZip 7.1.1 # https://chocolatey.org/packages/peazip
    pip 1.2.0
    powershell-core 7.0.0 # https://chocolatey.org/packages/powershell-core/
    PyCharm-community 2019.3.3
    python2 2.7.17 # Python 2.x
    R.Studio 1.2.5033
    resharper-ultimate-all 2019.3.4  # Not the official version by JetBrains, but slightly more actively maintained.
    rsat 2.1809.0.20190205 # Remote Server Administration Tools (aka aduc) - active directory users and computers
    spawner 0.2.4  # Spawner is a tool for generating test data suitable for populating databases.
    https://github.com/Terminals-Origin/Terminals
    sysinternals 2019.12.19 #  https://chocolatey.org/packages/sysinternals
    sysexp 1.75  # https://chocolatey.org/packages/sysexp - SysExporter - Grab data from list-view, tree-view, combo box, WebBrowser control, and text-box.
    thunderbird 68.6.0
    tortoisesvn 1.13.1.28686
    vcredist2010 10.0.40219.2 # Microsoft Visual C++ 2010 Redistributable Package 10.0.40219.2
    vcredist2015 14.0.24215.20170201 # Microsoft Visual C++ Redistributable for Visual Studio 2015 Update 3 (with hotfix 2016-09-14) 14.0.24215.20170201
    visualstudio2017buildtools 15.9.11.0 https://chocolatey.org/packages/visualstudio2017buildtools
    visualstudio2019professional 16.5.0.0
    visualstudio2019buildtools 16.5.0.0
    vscode 1.43.1
    windowclippings 3.1.131 # NOT MODERATOR APPROVED https://chocolatey.org/packages/windowclippings
    microsoft-windows-terminal 0.10.761.0 # Windows Terminal is a new, modern, feature-rich, productive terminal application for command-line users. 
    whysoslow 1.00 # Analyzes existing crash dumps and tries to determine and state the root cause in easy to understand language.
```powershell
cinst -y chocolatey --version 0.10.11
```


1. Packages
   1. Does Not Exist - TODO Create - https://www.userbenchmark.com/resources/download/UserBenchMark.exe
   2. Does Not Exist - TODO Create - https://totusoft.com/lanspeed
   
# Chocolatey Packages
| PackageName | Description | Radar Positioning |
| ----------- | ----------- | ----------------- |
| treesizefree | TreeSize Free tells you where precious disk space has gone. | - |
| notepadplusplus | Text editor with nice syntax highlighting and search. | - |
| SysExporter | SysExporter utility allows you to grab the data stored in standard list-views, tree-views, list boxes, combo boxes, text-boxes, and WebBrowser/HTML controls from almost any application running on your system, and export it to text, HTML or XML file. | Incoming |
| PeaZip | PeaZip is free file archiver utility, based on Open Source technologies of 7-Zip, p7zip, FreeArc, PAQ, and PEA projects.<br/>Cross-platform, full-featured but user-friendly alternative to WinRar, WinZip and similar general purpose archive manager applications, open and extract 180+ archive formats: 001, 7Z, ACE(\*), ARC, ARJ, BZ2, CAB, DMG, GZ, ISO, LHA, PAQ, PEA, RAR, TAR, UDF, WIM, XZ, ZIP ZIPX - view full list of supported archive file formats for archiving and for extraction. | Incoming |
