```powershell
choco.exe list --localy-only --all-versions --include-programs
```
TIP: When benchmarking, it is a good idea to use several different benchmark programs, as some may have bugs. For example, CrystalDiskMark was great for mechanical hard drives, but NVMe SSDs have exposed potential bugs in its timing data. See also https://github.com/aerospike/act/blob/master/README.md

    
    7zip 18.5.0.20180730
    7zip.install 18.5.0.20180730
    adobereader 2015.007.20033.02
    chocolatey 0.10.11
    chocolatey-core.extension 1.3.3
    cpu-z.install 1.87
    ConEmu https://chocolatey.org/packages/ConEmu
    crystaldiskmark 5.2.0
    diskmarkstream 1.1.2
    iometer 1.1.0
    cyberduck.install 6.2.9.26659
    DotNet4.5.2 4.5.2.20140902
    dotnetcore-sdk
    easy.install 0.6.11.4
    jdk8 8.0.162
    jdupes 1.10.3
    lockhunter 3.2
    notepadplusplus 7.5.1
    notepadplusplus.install 7.5.1
    OctopusTools 4.22.0
    pip 1.2.0
    PyCharm-community 2017.2.4
    R.Studio 1.1.456
    rsat 2.0
    spawner 0.2.4
    thunderbird 52.5.0
    vcredist2010 10.0.40219.2
    vscode 1.24.0
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
