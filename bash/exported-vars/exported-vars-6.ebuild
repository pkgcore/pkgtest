EAPI=6

DESCRIPTION="Output lists of variables in global, phase, and spawned scopes"
SLOT="0"
KEYWORDS="~amd64"

S=${WORKDIR}

__GLOBAL_VARS=$(set -o posix; set)
__PHASES=( src_prepare src_configure src_compile src_test src_install )

# Accessible variable lists are outputted to files named ${PHASE_NAME}-vars,
# ${PHASE_NAME}-spawned-vars, and global-vars in ${S}.
for __phase in "${__PHASES[@]}"; do
	eval "${__phase}() {
		default
		unset __PHASES __phase
		if [[ ! -e \"\${S}\"/global-vars ]]; then
			echo \${__GLOBAL_VARS} | tr ' ' '\n' > \"\${S}\"/global-vars
			unset __GLOBAL_VARS
		fi
		(set -o posix; set) > \"\${S}\"/\${FUNCNAME[0]}-vars
		\${FILESDIR}/test.sh /\${FUNCNAME[0]}
	}"
done
