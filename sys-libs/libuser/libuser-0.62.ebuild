# Copyright 2004-2016 Sabayon
# Copyright 2017-2018 Jan Chren (rindeal)
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit rindeal

## functions: eautoreconf
inherit autotools
## functions: prune_libtool_files
inherit ltprune

DESCRIPTION="Standardized interface for manipulating and administering user/group accounts"
HOMEPAGE="https://pagure.io/libuser"
LICENSE="GPL-2"

SLOT="0"
SRC_URI="https://releases.pagure.org/${PN}/${P}.tar.xz"

KEYWORDS="amd64 arm arm64"
IUSE_A=(
	+shared-libs static-libs nls doc

	+popt ldap sasl selinux
)

CDEPEND_A=(
	"dev-libs/glib:2"
	"popt? ( dev-libs/popt )"
	"ldap? ( net-nds/openldap )"
	"sasl? ( dev-libs/cyrus-sasl )"
	"selinux? ( sys-libs/libselinux )"
)
DEPEND_A=( "${CDEPEND_A[@]}"
	"virtual/yacc"
	"sys-devel/gettext"
)
RDEPEND_A=( "${CDEPEND_A[@]}" )

inherit arrays

src_prepare() {
	default

	## change `man 1 lid` to `man 1 libuser-lid`
	rmv apps/{,libuser-}lid.1
	rsed -e 's@ apps/lid\.1 @ apps/libuser-lid.1 @' \
		-i -- Makefile.am

	use doc || rsed -e '/^SUBDIRS/ s| docs| |' -i -- Makefile.am

	eautoreconf
}

src_configure() {
	local my_econf_args=(
		--without-python # too much pain to implement, for no gain
		--disable-Werror
		--enable-largefile
		--disable-rpath

		$(use_enable shared-libs shared)
		$(use_enable static-libs static)

		$(use_enable doc gtk-doc)
		$(use_enable doc gtk-doc-html)
		$(use_enable doc gtk-doc-pdf)

		$(use_with ldap)
		$(use_with popt)
		$(use_with sasl)
		$(use_with selinux)
	)

	econf "${my_econf_args[@]}"
}

src_install() {
	default

	prune_libtool_files
}
