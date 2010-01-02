#!/bin/sh

OLDVER=$1
NEWVER=$2
MIRROR="ftp://ftp.fr.openbsd.org/pub/OpenBSD"

. `dirname $0`/reupgrade.sub
re_check_arguments

# Verify and update file permissions using mtree
#
echo "** Verifying and fixing permissions"

echo "* 4.4BSD"
chroot . mtree -f etc/mtree/4.4BSD.dist -e -U

echo "* Special files"
chroot . mtree -f etc/mtree/special -e -U

echo "* /usr/local"
chroot . mtree -f etc/mtree/BSD.local.dist -e -U -p usr/local

# echo "* /usr/X11R6"
# chroot . mtree -f etc/mtree/BSD.x11.dist -e -U -p usr/X11R6

echo "** Re-installing packages with upgraded ones"

export PKG_PATH="$MIRROR/$NEWVER/packages/`uname -m`"
for file in var/db/pkg/*; do
  pkg=`basename $file | sed 's#-.*##'`
  echo "* $pkg"

  chroot . pkg_add -u $pkg
done 
