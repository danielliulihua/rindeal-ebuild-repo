# Copyright 1999-2016 Gentoo Foundation
# Copyright 2017-2018 Jan Chren (rindeal)
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit rindeal

## functions: tc-getCC, tc-getPKG_CONFIG
inherit toolchain-funcs

## functions: enewgroup, enewuser
inherit user

## functions: systemd_dounit
inherit systemd

## TODO
## TODO: though I cleaned this package a lot already, it's still not completely in shape
## TODO

DESCRIPTION="Network infrastructure for small networks: DNS, DHCP, ..."
HOMEPAGE="http://www.thekelleys.org.uk/dnsmasq/doc.html"
LICENSE="|| ( GPL-2 GPL-3 )"

SLOT="0"
SRC_URI="http://thekelleys.org.uk/gitweb/?p=${PN}.git;a=snapshot;h=refs/tags/v${PV};sf=tgz -> ${P}--snapshot.tgz"

KEYWORDS="~amd64 ~arm ~arm64"
IUSE_A=(
	nls selinux doc static

	auth-dns
	broken-rtc
	conntrack
	dbus
	dhcp
	dhcp-tools
	dns-loop
	dnssec
	idn
	+inotify
	ipset
	ipv6
	lua
	script
	systemd
	tftp
)

CDEPEND_A=(
	"dbus? ( sys-apps/dbus:0 )"
	"idn? ( net-dns/libidn:0 )"
	"lua? ( dev-lang/lua:* )"
	"conntrack? ( net-libs/libnetfilter_conntrack:0 )"
	"nls? ("
		"sys-devel/gettext:0"
		"net-dns/libidn:0"
	")"
)
DEPEND_A=( "${CDEPEND_A[@]}"
	"app-arch/xz-utils"
	"dnssec? ("
		"dev-libs/nettle[gmp]"
		"static? ("
			"dev-libs/nettle[static-libs(+)]"
		")"
	")"
	"virtual/pkgconfig"
)
RDEPEND_A=( "${CDEPEND_A[@]}"
	"dnssec? ("
		"!static? ("
			"dev-libs/nettle[gmp]"
		")"
	")"
	"selinux? ( sec-policy/selinux-dnsmasq )"
)

REQUIRED_USE_A=(
	"dhcp-tools? ( dhcp )"
	"lua? ( script )"
	"systemd? ( dbus )"
)

inherit arrays

S="${WORKDIR}/${PN}-v${PV}"

pkg_pretend() {
	if use static ; then
		einfo "Only sys-libs/gmp and dev-libs/nettle are statically linked."
		use dnssec || einfo "Thus, ${P}[!dnssec,static] makes no sense; the static USE flag is ignored."
	fi
}

pkg_setup() {
	enewgroup dnsmasq
	enewuser dnsmasq -1 -1 /dev/null dnsmasq
}

src_prepare() {
	eapply_user

	esed -r -e 's:lua5.[0-9]+:lua:' -i -- Makefile
	esed -e "s:%%PREFIX%%:${EPREFIX}/usr:" -i -- dnsmasq.conf.example

	## change default opts
	esed -e 's|CACHESIZ 150|CACHESIZ 2000|' \
		-e 's|CHUSER "nobody"|CHUSER "dnsmasq"|' \
		-e 's|CHGRP "dip"|CHGRP "dnsmasq"|' \
		-i -- src/config.h
}

my_use_have() {
	local useflag no_only uword

	useflag="${1}" ; shift

	if [[ $1 == '-n' ]] ; then
		no_only=1 ; shift
	fi

	uword="${1:-"${useflag}"}" ; shift

	while [[ ${uword} ]] ; do
		uword="${uword^^}"
		uword="${uword//-/_}"

		if ! use "${useflag}" ; then
			echo "-DNO_${uword}"
		elif ! (( no_only )) ; then
			echo "-DHAVE_${uword}"
		fi
		uword="${1}" ; shift
	done
}

src_configure() {
	# `egrep --no-filename -r "ifn?def (HAVE|NO)_" | egrep -o "(HAVE|NO)_[A-Z0-9_]*" | sort -u`
	# all options are in `src/config.h`, sometimes with description

	# the `-n` options are there because

	declare -g -r -a COPTS_A=(
		$(my_use_have broken-rtc)

		$(my_use_have tftp)

		# DHCP6 is not active until ipv6 is enabled
		$(my_use_have dhcp -n DHCP DHCP6)

		$(my_use_have script)
		$(my_use_have lua LUASCRIPT)

		$(my_use_have dbus)

		$(my_use_have idn)

		$(my_use_have conntrack)
		$(my_use_have ipset)

		$(my_use_have auth-dns AUTH)
		$(my_use_have dnssec)
		$(my_use_have static DNSSEC_STATIC)
		$(my_use_have dns-loop -n loop)

		$(my_use_have inotify -n)

		$(my_use_have ipv6 -n IPV6)

		# allow users to override and add additional options
		${DNSMASQ_CUSTOM_COPTS}
	)

	declare -g -r -a COMMON_EMAKE_OPTS=(
		PREFIX=/usr
		MANDIR=/usr/share/man
		CC="$(tc-getCC)"
		PKG_CONFIG="$(tc-getPKG_CONFIG)"
		CFLAGS="-Wall -Wextra ${CFLAGS}"
		LDFLAGS="${LDFLAGS}"
		CONFFILE="/etc/${PN}.conf"
		COPTS="${COPTS_A[@]}"
	)
}

src_compile() {
	emake "${COMMON_EMAKE_OPTS[@]}" \
		all$(usex nls "-i18n" "")

	use dhcp-tools && \
		emake -C contrib/lease-tools "${COMMON_EMAKE_OPTS[@]}" \
			all
}

src_install() {
	emake "${COMMON_EMAKE_OPTS[@]}" DESTDIR="${ED}" \
		install$(use nls && echo "-i18n")

	[[ -d "${D}"/usr/share/locale/ ]] && \
		ermdir --ignore-fail-on-non-empty "${ED}"/usr/share/locale/

	dodoc CHANGELOG CHANGELOG.archive FAQ dnsmasq.conf.example

	if use doc ; then
		docinto /
		dodoc -r logo
		docinto html/
		dodoc *.html
	fi

	insinto /usr/share/dnsmasq
	doins trust-anchors.conf

	if use dhcp ; then
		keepdir /var/lib/misc
	fi

	if use dbus ; then
		insinto /etc/dbus-1/system.d
		doins dbus/dnsmasq.conf
	fi

	if use dhcp-tools ; then
		dosbin contrib/lease-tools/{dhcp_release,dhcp_lease_time}
		doman contrib/lease-tools/{dhcp_release,dhcp_lease_time}.1
	fi

	systemd_dounit "${FILESDIR}"/${PN}.service
}

pkg_preinst() {
	# temporary workaround to (hopefully) prevent leases file from being removed
	[[ -f /var/lib/misc/dnsmasq.leases ]] && \
		rcp /var/lib/misc/dnsmasq.leases "${T}"
}

pkg_postinst() {
	# temporary workaround to (hopefully) prevent leases file from being removed
	[[ -f "${T}"/dnsmasq.leases ]] && \
		rcp "${T}"/dnsmasq.leases /var/lib/misc/dnsmasq.leases
}
