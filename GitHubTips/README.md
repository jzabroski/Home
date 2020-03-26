https://help.github.com/en/articles/syncing-a-fork

# Git Aliases

Taken from github user irisstyle (Ethan Brown)

```
aliases = config --get-regexp alias
amend = commit --amend
bl = blame -w -M -C
bra = branch -rav
branches = branch -rav
changed = status -sb
f = !git ls-files | grep -i
filelog = log -u
hist = log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue) [%an]%Creset' --abbrev-commit --date=relative
last = log -p --max-count=1 --word-diff
lastref = rev-parse --short HEAD
lasttag = describe --tags --abbrev=0
pick = add -p
remotes = remote -v show
stage = add
standup = log --since yesterday --oneline --author {ME}
stats = diff --stat
sync = ! git fetch upstream -v && git fetch origin -v && git checkout master && git merge upstream/master
undo = reset head~
unstage = reset HEAD
wdiff = diff --word-diff
who = shortlog -s -e --
```

# Git Extensions

https://chocolatey.org/packages/EthanBrown.GitExtensionsConfiguration

Very simple set of standard GitExtensions configuration options

- SourceCodePro for diff font
- Max 50 characters for first line of commit
- Max 72 characters on subsequent lines
- 2nd line of commit must be empty
- Show repository status in browse dialog (number of changes in toolbar)
- Show current working dir changes in revision graph
- Use FileSystemWatcher to check if index is changed
- Show stash count on status bar in browse window

# Git Configuration

https://chocolatey.org/packages?q=ethanbrown.gitconfiguration

Very simple set of standard Git config on Windows

core.autocrlf true
core.safecrlf false
rebase.autosquash true
help.format html
push.default simple
core.editor Notepad++

diff.tool DiffMerge
diff.guitool DiffMerge
merge.tool DiffMerge
