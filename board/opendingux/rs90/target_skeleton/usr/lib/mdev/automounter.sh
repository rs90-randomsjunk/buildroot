#!/bin/sh

do_checks()
{
	if [ "`grep root=/dev/$1 /proc/cmdline`" ] ; then
		echo "Mounted at /boot ; skipping"
		exit 1
	fi

	if [ "`grep /dev/$1 /proc/mounts`" ] ; then
		echo "Partition already mounted ; skipping"
		exit 1
	fi
}

get_mount_name()
{
	MOUNT_NAME="`/usr/sbin/blkid_label /dev/$1`"
	[ -z "$MOUNT_NAME" ] && MOUNT_NAME="$1"
}

get_fs()
{
	MOUNT_OPTS=defaults
	MOUNT_FS="`/usr/sbin/blkid_fs /dev/$1`"
	[ "$MOUNT_FS" = "vfat" ] && MOUNT_OPTS+=",flush"
}

do_umount()
{
	get_mount_name $1

	mount -o remount,rw /media

	umount /media/$MOUNT_NAME
	rmdir /media/$MOUNT_NAME

	mount -o remount,ro /media
}

do_mount()
{
	get_mount_name $1
	get_fs $1

	mount -o remount,rw /media

	mkdir /media/$MOUNT_NAME
	mount /dev/$1 -t $MOUNT_FS -o $MOUNT_OPTS /media/$MOUNT_NAME

	mount -o remount,ro /media
}

do_remove()
{
	do_checks $1
	do_umount $1
}

do_add()
{
	do_remove $1
	do_mount $1
}

case $1 in
	--remove)
		do_remove $2
		;;
	--add)
		do_add $2
		;;
	*)
		echo "Unrecognized command $1"
		;;
esac
