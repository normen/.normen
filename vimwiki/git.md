## GIT
```bash
# init repo + add remote
git init
git remote add origin https://github.com/normen/blah.git
# push to remote
git push -u origin master

# config user
git config --global user.name Normen
git config --global user.email normen667@gmail.com

# save credentials
git config --global credential.helper store

# git always rebase
git config --global --bool pull.rebase true

# git handle cr/lf windows/linux
git config --global core.autocrlf true

# commit
git add -A // or -u for already added files
git commit -m 'Stuff'
git push -u -f origin master

# "hide" changes (git stash doesn't hide untracked and ignored)
git stash save -a

# get latest changes from remote
git pull --rebase origin master

# "unhide" changes
git stash pop

# remove changes
git stash save --keep-index
git stash drop

# show stash as patch
git stash show -p

# branching
git branch branchname
git checkout branchname

# in one line, keeps current changes
git checkout -b newbranch

# merge to master
git checkout master
git merge --squash <feature branch> // --squash for making it one commit
git add -u
git commit -m "Merged WIP"

# reset dev branch to master
git checkout dev
git reset --hard master

# reset last commit if pull fails:
git reset --soft HEAD^

# rebase dev branch to master
git checkout dev
git rebase master

# rebase master from dev
git checkout master
git rebase -i dev
 - change from pick to squash

# rebase when merged before - ??
git checkout dev
git rebase -Xtheirs master // or -Xours to prefer master commit history
git pull -Xours origin dev
git push origin dev

# delete branch
git branch -d branchname
# delete remote branch
git push origin --delete branchname

# in branch, get new commits to master
git rebase master

# rename branch (from outside or in)
git branch -m <oldname> <newname>
git branch -m <newname>

# update fork from origin (or others, "upstream" can be changed to any name)
git remote add upstream git://github.com/ORIGINAL-DEV-USERNAME/REPO-YOU-FORKED-FROM.git
git fetch upstream
git checkout master
git rebase upstream/master (git merge upstream/master to keep "ugly" history)

# reset single file to head
git checkout HEAD -- my-file.txt

# get single file from other/upstream repo
git checkout -p other/target-branch target-file.ext

# FIX: go back to previous step when stuff happened
git reset --hard ORIG_HEAD

# remove all from staged
git reset HEAD -- .

# list untracked files
git ls-files --others --exclude-standard

# tagging
git tag -a v1.0 -m 'tagging Version 1.0'
git checkout tags/v1.0 -b branchname // no -b for no new branch
git fetch --all --tags --prune

# change commit message
git rebase -i HEAD~3 //3 last commits
#change pick -> reword in list
git push --force

# changes since last tag
LASTTAG=$(git describe --tags --abbrev=0)
git log $LASTTAG..HEAD --no-decorate --pretty=format:"- %s" --abbrev-commit > changes.txt

# prepare for email
git format-patch origin/master
# send last commit as mail
git send-email --to 'normenweb@mac.com' HEAD^
# apply mail patch (pipe in)
git am
# configure send-email
cpan Net::SMTP::SSL IO::Socket::SSL
cpan Authen::SASL MIME::Base64 Net::SMTP::SSL
vim ~/.gitconfig
<<CONTENT
[sendemail]
	smtpserver = mail.example.org
	smtpuser = you@example.org
	smtpencryption = tls
	smtpserverport = 587
CONTENT

#! /bin/bash
# git-interactive-merge
from=$1
to=$2
git checkout $from
git checkout -b ${from}_tmp
git rebase -i $to || $SHELL
# Above will drop you in an editor and pick the changes you want
git checkout $to
git pull . ${from}_tmp
git branch -d ${from}_tmp

# config git

```
