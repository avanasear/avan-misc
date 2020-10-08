# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Slippi launcher for Super Smash Brothers Melee"
HOMEPAGE="https://slippi.gg"
SRC_URI="https://github.com/project-slippi/Ishiiruka/archive/v2.2.3.tar.gz"

S="${WORKDIR}/Ishiiruka-${PV}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"

IUSE=""

src_configure() {
	CMAKE_FLAGS = "${CMAKE_FLAGS} -DLINUX_LOCAL_DEV=true"
	mkdir -p build || die
	pushd build
	cmake ${CMAKE_FLAGS} ../ || die
	popd
}

src_compile() {
	pushd build
	emake || die
	popd
}

src_install() {
	cp -r -n Data/Sys/ build/Binaries/
	touch ./build/Binaries/portable.txt

	pushd build
	emake DESTDIR="${D}" install/local || die
	popd
}
