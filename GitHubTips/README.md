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
