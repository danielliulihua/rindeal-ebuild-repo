# Copyright 2018 Jan Chren (rindeal)
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit rindeal

## python-*.eclass:
PYTHON_COMPAT=( python3_{6,7} )

## git-hosting.eclass:
GH_RN="bitbucket:rindeal_py"
GH_REF="v${PV}"

## EXPORT_FUNCTIONS: src_unpack
inherit git-hosting
## EXPORT_FUNCTIONS: src_prepare src_configure src_compile src_test src_install
inherit distutils-r1

DESCRIPTION="${PN}"
LICENSE="GPL-3"

SLOT="0"

KEYWORDS="~amd64 ~arm ~arm64"
IUSE_A=( )

CDEPEND_A=()
DEPEND_A=( "${CDEPEND_A[@]}" )
RDEPEND_A=( "${CDEPEND_A[@]}"
	"app-portage/repoman"
	"dev-python/travis-ci-utils[${PYTHON_USEDEP}]"
)

REQUIRED_USE_A=(  )
RESTRICT+=""

inherit arrays
