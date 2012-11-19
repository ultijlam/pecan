#!/bin/sh

PECAN_PKGNAME="libiconv-1.14"

pecan_description="GNU character set conversion library"

if [ -f ./pecan.subr ]; then
	. ./pecan.subr
elif [ -f ../pecan/pecan.subr ]; then
	. ../pecan/pecan.subr
else
	exit 1
fi

pecan_gnu_configure_args="${pecan_gnu_configure_args} --disable-nls"

pecan_test_style=make

pecan_post_stage()
{
	cp "${pecan_srcdir}/COPYING" ${pecan_stagedir}
	cp "${pecan_srcdir}/COPYING.LIB" ${pecan_stagedir}
}

pecan_main "$@"