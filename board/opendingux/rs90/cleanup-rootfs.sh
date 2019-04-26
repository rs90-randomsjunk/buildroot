#!/bin/sh

# We run dropbear from inetd
rm $1/etc/init.d/S50dropbear

# No need for udev's HW database
rm -rf output/target/etc/udev/hwdb.d

# We have our own mdev startup script
rm output/target/etc/init.d/S10mdev

if [ ! -h $1/usr/share/fonts/truetype ] ; then
	ln -s . $1/usr/share/fonts/truetype
fi

exit 0
