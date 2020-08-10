## Kernel information
KERNEL_VER=$(shell dpkg-parsechangelog --show-field Version | sed -n "s/^\([0-9.]*\).*$$/\1/p")
KERNEL_MAJMIN=$(shell echo ${KERNEL_VER} | sed -e "s/^v//" -e "s/\.[^.]*$$//")

# Increment KERNEL_RELEASE if the ABI changes (abicheck target in debian/rules)
KERNEL_RELEASE=1

## Debian package information
PKG_REVISION=$(shell dpkg-parsechangelog --show-field Version | sed -n "s/^[^-]*-\(.*\)$$/\1/p")
PKG_RELEASE=$(shell echo ${PKG_REVISION} | sed -n "s/^\([^+]*\).*$$/\1/p")
PKG_DATE:=$(shell dpkg-parsechangelog -SDate)
PKG_GIT_VERSION:=$(shell git rev-parse HEAD)

## Build flavor
# Default to PVE flavor
PKG_BUILD_FLAVOR ?= pve
ifneq (${PKG_BUILD_FLAVOR},pve)
	_ := $(info Using custom build flavor: ${PKG_BUILD_FLAVOR})
endif

## Build profile
# Default to generic march optimizations
PKG_BUILD_PROFILE ?= generic
ifneq (${PKG_BUILD_PROFILE},generic)
	_ := $(info Using custom build profile: ${PKG_BUILD_PROFILE})
endif

# Build settings
DEB_BUILD_ARCH=$(shell dpkg-architecture -qDEB_BUILD_ARCH)
PVE_BUILD_CC ?= ${CC}

### Debian package names
EXTRAVERSION=-${KERNEL_RELEASE}-${PKG_BUILD_FLAVOR}
KVNAME=${KERNEL_VER}${EXTRAVERSION}
PVE_KERNEL_PKG=pve-edge-kernel-${KVNAME}
PVE_HEADER_PKG=pve-edge-headers-${KVNAME}
PVE_USR_HEADER_PKG=pve-kernel-libc-dev
LINUX_TOOLS_PKG=linux-tools-${KERNEL_MAJMIN}

