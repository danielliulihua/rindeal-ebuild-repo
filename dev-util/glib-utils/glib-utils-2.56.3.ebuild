# Copyright 1999-2018 Gentoo Authors
# Copyright 2018 Jan Chren (rindeal)
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="Build utilities for GLib using projects"
HOMEPAGE="https://www.gtk.org/"
LICENSE="LGPL-2.1+"

SLOT="0"

KEYWORDS="~amd64 ~arm ~arm64"
IUSE_A=( )

CDEPEND_A=(
	"!<dev-libs/glib-2.56.2:2"
)
DEPEND_A=( "${CDEPEND_A[@]}" )
RDEPEND_A=( "${CDEPEND_A[@]}"
	"dev-libs/glib"
)

inherit arrays

S="${WORKDIR}"

src_configure() { :; }
src_compile() { :; }
src_install() { :; }
