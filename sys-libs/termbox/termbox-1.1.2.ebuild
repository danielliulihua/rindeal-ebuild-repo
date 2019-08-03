# Copyright 2016-2019 Jan Chren (rindeal)
# Distributed under the terms of the GNU General Public License v2

EAPI=6  # waf-utils doesn't support EAPI7
inherit rindeal

## git-hosting.eclass:
GH_RN="github:nsf"
GH_REF="v${PV}"

## python-*.eclass:
PYTHON_COMPAT=( python2_7 python3_{5,6,7} )
# threads are for waf
PYTHON_REQ_USE="threads(+)"

## distutils-r1.eclass:
DISTUTILS_OPTIONAL="TRUE"

## EXPORT_FUNCTIONS: src_unpack
inherit git-hosting

## functions: distutils-r1_src_prepare, distutils-r1_src_configure, distutils-r1_src_compile, distutils-r1_src_install
## variables: PYTHON_DEPS, PYTHON_USEDEP, PYTHON_REQUIRED_USE
inherit distutils-r1

## functions: waf-utils_src_configure, waf-utils_src_compile
## variables: WAF_BINARY
inherit waf-utils

DESCRIPTION="Library for writing text-based user interfaces"
LICENSE="MIT"

SLOT="0"

KEYWORDS="~amd64 ~arm ~arm64"
IUSE_A=( examples python static-libs )

CDEPEND_A=(
	"python? ( ${PYTHON_DEPS} )"
)
DEPEND_A=( "${CDEPEND_A[@]}"
	"python? ( dev-python/cython[${PYTHON_USEDEP}] )"
)
RDEPEND_A=( "${CDEPEND_A[@]}" )

REQUIRED_USE_A=(
	"python? ( ${PYTHON_REQUIRED_USE} )"
)

inherit arrays

pkg_setup() {
	python_setup
}

src_prepare() {
	default

	# respect flags
	rsed -e '/append.*CFLAGS/ s|-O[0-9]||' \
		-i -- wscript

	# do not build examples
	if ! use examples
	then
		rsed -e '/bld.recurse("demo")/d' \
			-i -- src/wscript
	fi

	use python && \
		distutils-r1_src_prepare
}

src_configure() {
	waf-utils_src_configure
	use python && \
		distutils-r1_src_configure
}

src_compile() {
	waf-utils_src_compile
	use python && \
		distutils-r1_src_compile
}

src_install() {
	local -a waf_cmd=(
		"${WAF_BINARY}"
		--destdir="${D}"
		--targets=$(usex static-libs 'termbox_static,' '')termbox_shared
		install
	)
	echo "${waf_cmd[@]}"
	"${waf_cmd[@]}" || die

	use python && \
		distutils-r1_src_install

	## docs
	einstalldocs

	docinto tools
	dodoc tools/*.py

	if use examples
	then
		docinto demo
		dodoc src/demo/*.c
	fi
}
