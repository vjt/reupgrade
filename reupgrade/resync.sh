#!/bin/sh

DIRS='
  home

  usr/local

  var/backups
  var/db
  var/log
  var/mail
  var/privoxy
'

RSYNC="rsync -a --devices"

OLDVER=$1
NEWVER=$2

. `dirname $0`/reupgrade.sub
re_check_arguments

rootmail=`mktemp -t rootmail`
mv var/mail/root $rootmail

for dir in $DIRS; do
  echo "* Syncing $dir from ../$OLDVER"

  [ ! -d ./$dir ] && mkdir ./$dir
  $RSYNC ../$OLDVER/$dir ./`dirname $dir`
done

cat $rootmail >> var/mail/root
rm -f $rootmail
