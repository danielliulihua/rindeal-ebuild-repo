# Copyright 2017-2019 Jan Chren (rindeal)
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit rindeal

## git-hosting.eclass:
GH_RN="github:python"
GH_REF="f5c107c" # mypy-0.720

## EXPORT_FUNCTIONS: src_unpack
inherit git-hosting

DESCRIPTION="Collection of library stubs for Python, with static types"
LICENSE="Apache-2.0"

SLOT="0"

KEYWORDS="~amd64 ~arm ~arm64"

src_configure() { :; }
src_compile() { :; }

src_install() {
	dodoc README.md

	insinto /usr/share/${PN}
	doins -r stdlib third_party
}
