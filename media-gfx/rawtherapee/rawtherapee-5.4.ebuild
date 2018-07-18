# Copyright 1999-2014 Gentoo Foundation
# Copyright 2016-2018 Jan Chren (rindeal)
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit rindeal

## git-hosting.eclass:
GH_RN="github:Beep6581:RawTherapee"

## EXPORT_FUNCTIONS: src_unpack
## variables: GH_HOMEPAGE
inherit git-hosting
## functions: tc-has-openmp
inherit toolchain-funcs
## EXPORT_FUNCTIONS: src_prepare src_configure src_compile src_test src_install
inherit cmake-utils
## EXPORT_FUNCTIONS: src_prepare pkg_preinst pkg_postinst pkg_postrm
inherit xdg

DESCRIPTION="Powerful cross-platform raw image processing program"
HOMEPAGE="http://www.rawtherapee.com/ ${GH_HOMEPAGE}"
LICENSE="GPL-3"

SLOT="0"

KEYWORDS="~amd64"
IUSE_A=( auto-gdk-flush bzip2 debug +mmap openmp profile )

CDEPEND_A=(
	">=x11-libs/gtk+-3.16:3"
	">=dev-libs/glib-2.44:2"
	">=dev-cpp/glibmm-2.44:2"
	">=dev-cpp/gtkmm-3.16:3.0"
	">=dev-libs/libsigc++-2.3.1:2"

	">=media-libs/lcms-2.6:2"
	">=dev-libs/expat-2.1"
	"sci-libs/fftw:3.0"
	"media-libs/libiptcdata"

	"virtual/jpeg:*"
	"media-libs/libpng:*"
	"media-libs/tiff:0"
	"sys-libs/zlib"

	"bzip2? ( app-arch/bzip2 )"

	"media-libs/libcanberra[gtk3]"
)
DEPEND_A=( "${CDEPEND_A[@]}"
	"app-arch/xz-utils"
	"virtual/pkgconfig"
)
RDEPEND_A=( "${CDEPEND_A[@]}" )

inherit arrays

pkg_pretend() {
	if use openmp ; then
		tc-has-openmp || die "Please switch to an openmp compatible compiler"
	fi
}

src_prepare() {
	eapply_user

	# do not install LICENSE
	rsed -e '/^install/ s/.*LICENSE.txt.*//' -i -- CMakeLists.txt

	# Generating this file automatically requires a valid GIT repo.
	# This info is only shown in the "About" dialog.
	cat <<-_EOF_ > ReleaseInfo.cmake || die
		set(GIT_BRANCH ${GH_REF})
		set(GIT_VERSION ${PV})
		set(GIT_CHANGESET ${GH_REF})
		set(GIT_TAGDISTANCE ${GH_REF})
	_EOF_

	xdg_src_prepare
	cmake-utils_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-D DOCDIR="${EPREFIX}/usr/share/doc/${PF}"
		# Examples: "" = ~/.config/RawTherapee, "latesttag" = ~/.config/RawTherapee4.2, "_testing" = ~/.config/RawTherapee_testing
		-D CACHE_NAME_SUFFIX=""
		-D CMAKE_BUILD_TYPE="$(usex debug 'Debug' 'Release')"

		-D OPTION_OMP="$(usex openmp)"	# "Build with OpenMP support"
		-D WITH_BZIP="$(usex bzip2)"	# "Build with Bzip2 support"
		-D WITH_MYFILE_MMAP="$(usex mmap)"
		-D WITH_PROF="$(usex profile)"	# "Build with profiling instrumentation"
		-D AUTO_GDK_FLUSH="$(usex auto-gdk-flush)"
	)
	cmake-utils_src_configure
}
