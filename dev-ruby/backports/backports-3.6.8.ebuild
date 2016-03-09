# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

USE_RUBY="ruby20 ruby21"

inherit ruby-fakegem

DESCRIPTION="Essential backports that enable many of the nice features of Ruby 1.8.7 up to"
HOMEPAGE="http://github.com/marcandre/backports"
LICENSE="MIT"

RESTRICT="mirror test"
SLOT="0"
KEYWORDS="~amd64 ~arm"

## ebuild generated for gem `backports-3.6.8` by gem2ebuild on 2016-03-09
