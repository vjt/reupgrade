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

mv etc/resolv.conf etc/resolv.conf.reupgrade
cp /etc/resolv.conf etc
chroot . pkg_add -u
mv etc/resolv.conf.reupgrade etc/resolv.conf

echo "** Re-generating pwd.db and spwd.db"
pwd_mkdb -p -d ./etc master.passwd
