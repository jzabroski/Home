```powershell
choco.exe list --localy-only --all-versions --include-programs
```
TIP: When benchmarking, it is a good idea to use several different benchmark programs, as some may have bugs. For example, CrystalDiskMark was great for mechanical hard drives, but NVMe SSDs have exposed potential bugs in its timing data. See also https://github.com/aerospike/act/blob/master/README.md

    
    7zip 18.5.0.20180730
    7zip.install 18.5.0.20180730
    adobereader 2015.007.20033.02
    chocolatey 0.10.11
    chocolatey-core.extension 1.3.3
    clink # https://github.com/mridgers/clink cmd.exe replacement, supports logging cmd.exe commands system wide
    cpu-z.install 1.87
    ConEmu # https://chocolatey.org/packages/ConEmu
    crystaldiskmark 5.2.0
    diskmarkstream 1.1.2
    iometer 1.1.0
    cyberduck.install 6.2.9.26659 # FTP / CloudStorage / WebDAV client
    DotNet4.5.2 4.5.2.20140902
    dotnetcore-sdk 2.2.105
    docker-desktop 2.0.0.3
    easy.install 0.6.11.4
    github-desktop https://chocolatey.org/packages/github-desktop
    gitkraken 5.0.4
    jdk8 8.0.162
    javaruntime 8.0.191
    jdupes 1.10.3
    linqpad (linqpad5.install) v5.36.03
    lockhunter 3.2
    notepadplusplus 7.5.1
    notepadplusplus.install 7.5.1
    OctopusTools 4.22.0
    pip 1.2.0
    powershell-core 6.1.3 # https://chocolatey.org/packages/powershell-core/
    PyCharm-community 2017.2.4
    R.Studio 1.1.456
    rsat 2.0  (aduc) - active directory users and computers
    spawner 0.2.4
    https://github.com/Terminals-Origin/Terminals
    sysinternals 2019.3.18 #  https://chocolatey.org/packages/sysinternals
    SysExporter 1.75  # https://chocolatey.org/packages/sysexp 
    thunderbird 60.7.2
    tortoisesvn 1.12.0.28568
    vcredist2010 10.0.40219.2
    visualstudio2017buildtools 15.9.11.0 https://chocolatey.org/packages/visualstudio2017buildtools
    vscode 1.35.1
    windowclippings 3.1.131 https://chocolatey.org/packages/windowclippings
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
