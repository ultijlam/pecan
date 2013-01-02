#!/bin/sh

PECAN_PKGNAME="libffi-3.0.11"

pecan_description="Foreign function interface library"

pecan_fetch_url="ftp://sourceware.org/pub/libffi/%FILE%"

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
	echo "exclude share/info/dir" >> "${pecan_stage_encapinfo}"
	cp "${pecan_srcdir}/LICENSE" "${pecan_stagedir}"
}

pecan_main "$@"
