#!/bin/sh

PECAN_PKGNAME="xz-5.0.4+2"

pecan_description="Library and command line tools for XZ and LZMA compressed files"

pecan_fetch_url="http://tukaani.org/xz/%FILE%"

pecan_abi_version="5.0.0"
pecan_api_version="5.0.0"

pecan_prereq_lib=">= gettext-runtime-0.18"
pecan_prereq_lib="${pecan_prereq_lib} >= libiconv-1.9.1"

pecan_tools_build="msgfmt sed"

if [ -f ./pecan/pecan.subr ]; then
	. ./pecan/pecan.subr
elif [ -f ../pecan/pecan.subr ]; then
	. ../pecan/pecan.subr
else
	exit 1
fi

pecan_configure_style="gnu"

pecan_post_stage()
{
	cp "${pecan_srcdir}/COPYING" "${pecan_stagedir}"
	cp "${pecan_srcdir}/COPYING.GPLv2" "${pecan_stagedir}"
	cp "${pecan_srcdir}/COPYING.GPLv3" "${pecan_stagedir}"
	cp "${pecan_srcdir}/COPYING.LGPLv2.1" "${pecan_stagedir}"
}

pecan_main "$@"
