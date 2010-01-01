#!/bin/sh

OLDVER=$1
NEWVER=$2
NAME='brahma' # XXX
OS='OpenBSD'  # XXX

if [ ! -d .git ]; then
  echo "Must be called from the root directory"
  exit -1
fi

if [ -z "$OLDVER" -o -z "$NEWVER" ]; then
  echo "Usage: $0 <old $OS version> <new $OS version>"
  exit 1
fi

if [ ! -d ../$NEWVER ]; then
  echo "New version ../$NEWVER doesn't exist!"
  exit 2
fi

if [ ! echo $OLDVER | egrep '[1-9]\.[0-9]+' >/dev/null ]; then
  echo "Old version number $OLDVER is not valid"
  exit 3
fi

if [ ! echo $NEWVER | egrep '[1-9]\.[0-9]+' >/dev/null ]; then
  echo "New version number $NEWVER is not valid"
  exit 3
fi

echo "* Checking out $OLDVER configuration"
git checkout upstream/$OLDVER

echo "* Copying repo to ../$NEWVER"
cp -R .git ../$NEWVER
cd ../$NEWVER

echo "* Importing upstream changes"
git checkout -b upstream/$NEWVER
git add .
git commit -m "Import of $OS $NEWVER configuration trees"

echo "* Removing obsolete files"
git status|grep deleted|awk '{print $3}' | while read file; do
  git rm -f $file
done
git commit -m "Sync of removed files in $OS $NEWVER"

echo "* Rebasing $OLDVER changes onto $NEWVER"
git checkout "$NAME/$OLDVER"
git checkout -b "$NAME/$NEWVER"

if git rebase upstream/$NEWVER
  echo "* Complete without conflicts: this must be your lucky day!"
else
  echo "! Rebase conflicts, please cd to ../$NEWVER and fix them"
  echo "! Have a nice day! :-)"
fi
