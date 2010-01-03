#!/bin/sh

OLDVER=$1
NEWVER=$2

. `dirname $0`/reupgrade.sub
re_check_arguments

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
