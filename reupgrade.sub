#!/bin/sh

set -x

NAME='brahma' # XXX
OS='OpenBSD'  # XXX

if [ `basename $0` == 'refunctions.sh' ]; then
  echo "There's no executable code in this script"
  exit -1
fi

function re_check_arguments() {

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

}
