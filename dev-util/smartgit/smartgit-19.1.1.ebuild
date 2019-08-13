# Copyright 2015-2019 Jan Chren (rindeal)
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit rindeal

## EXPORT_FUNCTIONS: src_prepare, pkg_preinst, pkg_postinst, pkg_postrm
inherit xdg

## functions: newicon, domenu
inherit desktop

DESCRIPTION="Git client with support for GitHub Pull Requests+Comments, SVN and Mercurial"
HOMEPAGE="https://www.syntevo.com/${PN,,}"
LICENSE="${PN}"

# slot number is based on the upstream slotting mechanism which creates a new subdir
# in `~/.smartgit/` for each new major release. The subdir name corresponds with SLOT.
PV_MAJ="$(ver_cut 1)"
PV_MIN="$(ver_cut 2)"
SLOT="${PV_MAJ}$( (( PV_MIN )) && echo ".${PV_MIN}" )"
MY_PNS="${PN}${SLOT%%/*}"

SRC_URI_A=(
	# Upstream's handling of files and permalinks is very bad.
	# They change URLs, move files from one place to another, delete files, return 3xx HTTP codes when file not found.
	#
	# 1) Get download link from:
	#
	#        https://www.syntevo.com/smartgit/download/
	#
	# 2) Upload it to a 3rd party service usgin this command:
	#
	#        curl -s -o - https://www.syntevo.com/downloads/smartgit/smartgit-linux-VERSION.tar.gz | curl -F "file=@-" 'https://file.io/?expires=1y' | jq -r .link
	#
	# 3) Copy the output link here:
	#
	"https://file.io/zqSrfh -> ${P}.tar.gz"
)

# can be used on any 64-bit architecture supported by Linux, but the bundled JRE is for x86_64 only
KEYWORDS="-* ~amd64"
IUSE_A=( )

RDEPEND_A=(
)

RESTRICT+=" mirror strip"

inherit arrays

S="${WORKDIR}/${PN}"

src_prepare() {
	eapply_user
	xdg_src_prepare
}

src_install() {
	local -r vendor_ns="syntevo"
	local -r install_dir="/opt/${vendor_ns}/${MY_PNS}"

	rmkdir "${ED}${install_dir}"

	## move files to the install image
	rmv --strip-trailing-slashes --no-target-directory "${S}" "${ED}${install_dir}"

	## make scripts executable
	rchmod a+x {bin,lib}/*.sh

	## install entrypoint
	rcp "${FILESDIR}"/${PN,,}.sh "${ED}${install_dir}/bin/"
	rdosym --rel -- "/usr/bin/${MY_PNS}" "${install_dir}/bin/${PN}.sh"

	## install icons
	newicon -s 'scalable' "bin/${PN,,}.svg" "${MY_PNS}.png"
	local s
	for s in 32 48 64 128 256
	do
		newicon -s ${s} "bin/${PN,,}-${s}.png" "${MY_PNS}.png"
	done

	local -- dme_file="${T}/${PN,,}_${SLOT%%/*}.desktop"
	cat <<-_EOF_ > "${dme_file}" || die
		[Desktop Entry]
		Type=Application
		Version=1.1
		Name=SmartGit ${SLOT%%/*}
		GenericName=Git GUI
		Comment=${DESCRIPTION}
		Icon=${MY_PNS}
		TryExec=${EROOT}${install_dir}/bin/${PN,,}.sh
		Exec=${EROOT}${install_dir}/bin/${PN,,}.sh %U
		Terminal=false
		MimeType=x-scheme-handler/git;x-scheme-handler/smartgit;x-scheme-handler/sourcetree;
		Categories=Development;RevisionControl;
		Keywords=git;svn;hg;mercurial;github;bitbucket;
		StartupWMClass=SmartGit
	_EOF_
	domenu "${dme_file}"
}
