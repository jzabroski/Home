1. [Sublime Merge](https://www.sublimemerge.com/)
2. [GitKraken: Free Git GUI Client - Windows, Mac & Linux](https://www.gitkraken.com/)

# Prevent Checking In Files (e.g, web.confg)

```powershell
#Run this to reverse ignoring of changes to web.config so it gets committed.
git update-index --no-assume-unchanged path_to_file/web.config
```

To refresh and ignore assume unchanged settings:
```powershell
git update-index --really-refresh
```

To undo assume unchanged settings:
```powershell
#Run this in GitBash to temporarily ignore changes to web.config so it does not get committed.
git update-index --assume-unchanged path_to_file/web.config
```
