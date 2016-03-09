# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

USE_RUBY="ruby20 ruby21"

inherit ruby-fakegem

DESCRIPTION="CLI-based access to GitHub API v3"
HOMEPAGE="http://github.com/peter-murach/github_cli"
LICENSE="MIT"

RESTRICT="mirror test"
SLOT="0"
KEYWORDS="~amd64 ~arm"

ruby_add_rdepend '
	=dev-ruby/github_api-0*
	=dev-ruby/tty-0.0*'

## ebuild generated for gem `github_cli-0.6.2` by gem2ebuild on 2016-03-09
