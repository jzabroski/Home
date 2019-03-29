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
    cyberduck.install 6.2.9.26659
    DotNet4.5.2 4.5.2.20140902
    dotnetcore-sdk
    easy.install 0.6.11.4
    github-desktop https://chocolatey.org/packages/github-desktop
    jdk8 8.0.162
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
    sysinternals Sysinternals 2019.3.18  https://chocolatey.org/packages/sysinternals
    thunderbird 52.5.0
    vcredist2010 10.0.40219.2
    visualstudio2017buildtools 15.9.8.0 https://chocolatey.org/packages/visualstudio2017buildtools
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
