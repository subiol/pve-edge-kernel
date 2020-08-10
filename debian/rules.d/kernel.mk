# Path to the Linux kernel sources
KERNEL_SRC=linux

${KERNEL_SRC}/.config:
	${KERNEL_SRC}/scripts/kconfig/merge_config.sh -m \
		-O ${KERNEL_SRC} \
		${KERNEL_SRC}/debian.master/config/config.common.ubuntu \
		${KERNEL_SRC}/debian.master/config/${DEB_BUILD_ARCH}/config.common.${DEB_BUILD_ARCH} \
		${KERNEL_SRC}/debian.master/config/${DEB_BUILD_ARCH}/config.flavour.generic \
		debian/config/config.pve
	$(MAKE) -C ${KERNEL_SRC} CC=${PVE_BUILD_CC} oldconfig

.PHONY: kernel_configure
kernel_configure: ${KERNEL_SRC}/.config

.PHONY: kernel_build
kernel_build: kernel_main_build kernel_tool_build

.PHONY: kernel_main_build
kernel_main_build:
	dh_auto_build --sourcedirectory ${KERNEL_SRC} \
		CC=${PVE_BUILD_CC} \
		KCFLAGS="${PVE_BUILD_CFLAGS}" \
		EXTRAVERSION="${EXTRAVERSION}" \
		KBUILD_BUILD_VERSION_TIMESTAMP="${KVNAME} ${PKG_BUILD_PROFILE} (${PKG_DATE})"

.PHONY: kernel_tool_build
kernel_tool_build: kernel_main_build
	dh_auto_build --sourcedirectory ${KERNEL_SRC}/tools/perf prefix=/usr HAVE_NO_LIBBFD=1 HAVE_CPLUS_DEMANGLE_SUPPORT=1 NO_LIBPYTHON=1 NO_LIBPERL=1 NO_LIBCRYPTO=1
	echo "checking GPL-2 only perf binary for library linkage with incompatible licenses.."
	! ldd ${KERNEL_SRC}/tools/perf/perf | grep -q -E '\blibbfd'
	! ldd ${KERNEL_SRC}/tools/perf/perf | grep -q -E '\blibcrypto'

.PHONY: kernel_clean
kernel_clean:
	dh_auto_clean --sourcedirectory ${KERNEL_SRC}
