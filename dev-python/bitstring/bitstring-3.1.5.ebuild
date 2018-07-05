# Copyright 2017 Jan Chren (rindeal)
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit rindeal

GH_RN="github:scott-griffiths"
GH_REF="${PN}-${PV}"

PYTHON_COMPAT=( python2_7 python3_{5,6} )

inherit git-hosting
inherit distutils-r1

DESCRIPTION="Python module for creation and analysis of binary data"
HOMEPAGE="https://pythonhosted.org/${PN}/ https://pypi.python.org/pypi/${PN} ${GH_HOMEPAGE}"
LICENSE="MIT"

SLOT="0"

KEYWORDS="~amd64 ~arm ~arm64"

DOCS=( README.rst release_notes.txt )
