# Copyright 2016-2018 Jan Chren (rindeal)
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit rindeal

## git-hosting.eclass:
GH_RN="github:pawelsalawa"

## functions: eqmake5
inherit qmake-utils

## EXPORT_FUNCTIONS: src_prepare pkg_preinst pkg_postinst pkg_postrm
inherit xdg

## functions: format_qt_pro
inherit qt-pro-formatter

## functions: make_desktop_entry, doicon
inherit desktop

## functions: eshopts_push, eshopts_pop
inherit estack

## EXPORT_FUNCTIONS: src_unpack
inherit git-hosting

DESCRIPTION="Powerful cross-platform SQLite database manager"
HOMEPAGE="https://sqlitestudio.pl"
LICENSE="GPL-3"

SLOT="0"

[[ "${PV}" != *9999* ]] && KEYWORDS="~amd64"
IUSE_A=( cli cups nls tcl test )

CDEPEND_A=(
	"dev-db/sqlite:3"

	dev-qt/qt{concurrent,core,gui,network,script,svg,widgets,xml}:5

	"cups? ( dev-qt/qtprintsupport:5 )"
	"cli? ( sys-libs/readline:* )"
	"tcl? ( dev-lang/tcl:* )"
)
DEPEND_A=( "${CDEPEND_A[@]}"
	"dev-qt/designer:5"
	"test? ( dev-qt/qttest:5 )"
)
RDEPEND_A=( "${CDEPEND_A[@]}" )

inherit arrays

# Upstream guide: https://github.com/pawelsalawa/sqlitestudio/wiki/Instructions_for_compilation_under_Linux#manual-compilation---short-description

pkg_setup() {
	# NOTE: this dir structure resembles upstream guide
	# https://github.com/pawelsalawa/sqlitestudio/wiki/Instructions_for_compilation_under_Linux#source-code-layout

	declare -r -g -- \
		MY_CORE_SRC_DIR="${S}/SQLiteStudio3"
	declare -r -g -- \
		MY_PLUGINS_SRC_DIR="${S}/Plugins"
	declare -r -g -- \
		MY_CORE_BUILD_DIR="${S}/output/build"
	declare -r -g -- \
		MY_PLUGINS_BUILD_DIR="${MY_CORE_BUILD_DIR}/Plugins"

	# NOTE: SQLITESTUDIO_*_DIRS dirs can also be specified at runtime
	#       as `SQLITESTUDIO_{PLUGINS,ICONS,FORMS}` env vars, which
	#       also accept multiple values as `:` separated list.

	# Additional directory to look up for plugins.
	# NOTE: this dir is the same as for core plugins
	declare -r -g -- \
		SQLITESTUDIO_PLUGINS_DIR="/usr/$(get_libdir)/${PN}"
	# Additional directory to look up for icons.
	declare -r -g -- \
		SQLITESTUDIO_ICONS_DIR="/usr/share/${PN}/icons"
	# Additional directory to look up for *.ui files (forms used by plugins).
	declare -r -g -- \
		SQLITESTUDIO_FORMS_DIR="/usr/share/${PN}/forms"
}

src_prepare() {
	eapply_user
	eapply "${FILESDIR}/foo.patch"

	xdg_src_prepare

	eshopts_push -s globstar
	local pro_files=( **/*.pro )
	format_qt_pro "${pro_files[@]}"
	eshopts_pop

	if ! use nls ; then
		# delete all files with translations
		find -type f \( -name "*.ts" -o -name "*.qm" \) -delete || die
		# delete refs in project files
		find -type f -name "*.pro" -print0 | xargs -0 sed -e '/^TRANSLATIONS/d' -i --
		assert
		# delete refs in resource files
		find -type f -name "*.qrc" -print0 | xargs -0 sed -e '\|\.qm</file>|d' -i --
		assert
	fi

	disable_modules() {
		debug-print-function "${FUNCTION}" "${@}"
		local -r file="$1"; shift
		local -r modules=( "${@}" )

		# skip if no modules specified
		(( ${#modules[@]} )) || return 0

		# build regex simply looking like this: `module1(\|$)|module2(\|$)`
		local m regex=""
		for m in "${modules[@]}" ; do
			regex+="\b${m}\b[[:space:]]*(\\\\|\r?\$)|"
		done
		regex="${regex%"|"}"

		einfo "Disabling modules: '${modules[*]}' in '${file#${S}/}'"
		esed -r -e "/${regex}/d" -i -- "${file}"
	}

	## Core
	local disabled_modules=(
		$(usex cli '' 'cli')
	)
	disable_modules "${MY_CORE_SRC_DIR}/SQLiteStudio3.pro" "${disabled_modules[@]}"

	## Plugins
	local disabled_plugins=(
		'DbSqlite2'	# we provide no support for sqlite2
		$(usex tcl '' 'ScriptingTcl')
		$(usex cups '' 'Printing')
	)
	disable_modules "${MY_PLUGINS_SRC_DIR}/Plugins.pro" "${disabled_plugins[@]}"
}

src_configure() {
	local qmake_args=(
		"BINDIR=${EPREFIX}/usr/bin"
		"LIBDIR=${EPREFIX}/usr/$(get_libdir)"

		"DEFINES+=PLUGINS_DIR=\"${EPREFIX}${SQLITESTUDIO_PLUGINS_DIR}\""
		"DEFINES+=ICONS_DIR=\"${EPREFIX}${SQLITESTUDIO_ICONS_DIR}\""
		"DEFINES+=FORMS_DIR=\"${EPREFIX}${SQLITESTUDIO_FORMS_DIR}\""

		$(usex test 'DEFINES+=tests' '')
	)

	## Core
	rmkdir "${MY_CORE_BUILD_DIR}" && cd "${MY_CORE_BUILD_DIR}" || die
	eqmake5 "${qmake_args[@]}" "${MY_CORE_SRC_DIR}"

	## Plugins
	rmkdir "${MY_PLUGINS_BUILD_DIR}" && cd "${MY_PLUGINS_BUILD_DIR}" || die
	eqmake5 "${qmake_args[@]}" "${MY_PLUGINS_SRC_DIR}"
}

src_compile() {
	emake -C "${MY_CORE_BUILD_DIR}"
	emake -C "${MY_PLUGINS_BUILD_DIR}"
}

src_install() {
	emake -C "${MY_CORE_BUILD_DIR}"     INSTALL_ROOT="${D}" install
	emake -C "${MY_PLUGINS_BUILD_DIR}"  INSTALL_ROOT="${D}" install

	doicon -s scalable "${MY_CORE_SRC_DIR}/guiSQLiteStudio/img/${PN}.svg"

	## system-wide dirs for addons
	keepdir "${SQLITESTUDIO_PLUGINS_DIR}"
	keepdir "${SQLITESTUDIO_ICONS_DIR}"
	keepdir "${SQLITESTUDIO_FORMS_DIR}"

	local make_desktop_entry_args=(
		"${EPREFIX}/usr/bin/${PN} -- %F"	# exec
		'SQLiteStudio3'	# name
		"${PN}"	# icon
		'Development;Database;Utility'	# categories
	)
	local make_desktop_entry_extras=( 'MimeType=application/x-sqlite3;' )
	make_desktop_entry "${make_desktop_entry_args[@]}" \
		"$( printf '%s\n' "${make_desktop_entry_extras[@]}" )"
}
