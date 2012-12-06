#!/bin/sh

PECAN_PKGNAME="openslp-1.2.1"

pecan_description="Service Location Protocol (SLP) client & libraries"

pecan_prereq_lib=">= openssl-1.0.1c"

if [ -f ./pecan.subr ]; then
	. ./pecan.subr
elif [ -f ../pecan/pecan.subr ]; then
	. ../pecan/pecan.subr
else
	exit 1
fi

pecan_gnu_configure_args="${pecan_gnu_configure_args} --enable-slpv2-security"

pecan_post_build()
{
	# Make an empty CVS directory so that the lack of one doesn't
	# break `install-data-local'.
	#
	mkdir -p "${pecan_srcdir}/doc/CVS"
}

pecan_post_stage()
{
	cp "${pecan_srcdir}/AUTHORS" "${pecan_stagedir}"
	cp "${pecan_srcdir}/COPYING" "${pecan_stagedir}"
	mkdir -p "${pecan_stagedir}/share/examples/rc.d"
	cp "${pecan_topdir}/slpd.in" "${pecan_stagedir}/share/examples/rc.d"
}

openslp_docdir="${pecan_pkgdir}/share/doc/openslp"
openslp_exampledir="${pecan_pkgdir}/share/examples/openslp"

pecan_install_args="${pecan_install_args} sysconfdir=${openslp_exampledir}"
pecan_install_args="${pecan_install_args} DOC_DIR=${openslp_docdir}"

pecan_main "$@"