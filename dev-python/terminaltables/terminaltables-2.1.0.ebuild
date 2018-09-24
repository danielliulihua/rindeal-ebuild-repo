# Copyright 2016-2017 Jan Chren (rindeal)
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit rindeal

PYTHON_COMPAT=( python2_7 python3_{5,6,7} )

GH_RN='github:Robpol86'
GH_REF="v${PV}"

inherit git-hosting
inherit distutils-r1

DESCRIPTION='Generate simple tables in terminals from a nested list of strings'
LICENSE='MIT'

SLOT='0'

KEYWORDS='~amd64 ~arm ~arm64'
