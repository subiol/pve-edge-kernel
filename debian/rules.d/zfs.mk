# Path to the ZFS sources
ZFS_SRC=zfs

.PHONY: zfs_configure
zfs_configure:
	cd ${ZFS_SRC}; $(MAKE) kernel
	dh_auto_configure --sourcedirectory ${ZFS_SRC}/pkg-zfs -- --with-config=kernel --with-linux=${KERNEL_SRC} --with-linux-obj=${KERNEL_SRC}

.PHONY: zfs_build
zfs_build:
	dh_auto_build --sourcedirectory ${ZFS_SRC}/pkg-zfs

.PHONY: zfs_clean
zfs_clean:
	dh_auto_clean --sourcedirectory ${ZFS_SRC}
	[ -d "${ZFS_SRC}/pkg-zfs" ] && dh_auto_clean --sourcedirectory ${ZFS_SRC}/pkg-zfs || true
