# Copyright 2016-2018 Jan Chren (rindeal)
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit rindeal

PYTHON_COMPAT=( python2_7 python3_{5,6} )
DISTUTILS_SINGLE_IMPL=true

GH_RN='github:pixelb'
GH_REF="v${PV}"

inherit git-hosting
inherit distutils-r1

DESCRIPTION='Utility to accurately report the in core memory usage for a program'
LICENSE='LGPL-2.1'

SLOT='0'

KEYWORDS='~amd64 ~arm ~arm64'

python_install_all() {
	doman "${PN}.1"

	distutils-r1_python_install_all
}
