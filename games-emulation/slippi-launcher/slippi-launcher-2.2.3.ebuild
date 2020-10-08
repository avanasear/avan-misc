# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Slippi launcher for Super Smash Brothers Melee"
HOMEPAGE="https://slippi.gg"
SRC_URI="https://github.com/project-slippi/Ishiiruka/archive/v${PV}.tar.gz"

S="${WORKDIR}/Ishiiruka-${PV}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"

IUSE="alsa bluetooth discord-presence doc +evdev ffmpeg log lto profile pulseaudio +qt5 systemd upnp"

RDEPEND="
	dev-libs/hidapi:0=
	dev-libs/libfmt:0=
	dev-libs/lzo:2=
	dev-libs/pugixml:0=
	media-libs/libpng:0=
	media-libs/libsfml
	media-libs/mesa[egl]
	net-libs/enet:1.3
	net-libs/mbedtls:0=
	net-misc/curl:0=
	sys-libs/readline:0=
	sys-libs/zlib:0=
	x11-libs/libXext
	x11-libs/libXi
	x11-libs/libXrandr
	virtual/libusb:1
	virtual/opengl
	alsa? ( media-libs/alsa-lib )
	bluetooth? ( net-wireless/bluez )
	evdev? (
		dev-libs/libevdev
		virtual/udev
	)
	ffmpeg? ( media-video/ffmpeg:= )
	profile? ( dev-util/oprofile )
	pulseaudio? ( media-sound/pulseaudio )
	qt5? (
		dev-qt/qtcore:5
		dev-qt/qtgui:5
		dev-qt/qtwidgets:5
	)
	systemd? ( sys-apps/systemd:0= )
	upnp? ( net-libs/miniupnpc )
"
DEPEND="${RDEPEND}"
BDEPEND="
	sys-devel/gettext
	virtual/pkgconfig"

# vulkan-loader required for vulkan backend which can be selected
# at runtime.
RDEPEND="${RDEPEND}
	media-libs/vulkan-loader"

src_configure() {
	CMAKE_FLAGS="${CMAKE_FLAGS} -DLINUX_LOCAL_DEV=true"
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
	cp -r -n Data/Sys/ /usr/local/bin
	touch /usr/local/bin/build/Binaries/portable.txt

	pushd build
	emake DESTDIR="${D}" install || die
	popd
}

pkg_postinst() {
	xdg_icon_cache_update
}

pkg_postrm() {
	rm -rf /usr/local/bin/Sys/
	rm -f /usr/local/bin/portable.txt
	xdg_icon_cache_update
}
