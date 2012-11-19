#!/bin/sh

PECAN_PKGNAME="getopt-1.1.5"

pecan_description="GNU getopt(3)-compatible tool for shell scripts"

pecan_prereq_build=">= gettext-tools-0.18.1"
pecan_prereq_build="${pecan_prereq_build} * gmake"
pecan_prereq_lib=">= gettext-runtime-0.18.1"
pecan_prereq_lib="${pecan_prereq_lib} >= libiconv-1.14"

if [ -f ./pecan.subr ]; then
	. ./pecan.subr
elif [ -f ../pecan/pecan.subr ]; then
	. ../pecan/pecan.subr
else
	exit 1
fi

pecan_post_extract()
{
	# Remove *.o files that were included in the tarball.
	cd "${pecan_srcdir}" && rm gnu/*.o
}

pecan_configure_style=

make_args="prefix=${pecan_pkgdir} mandir=${pecan_mandir}"

pecan_build()
{
	cd "${pecan_srcdir}" && \
	make all ${make_args} \
		EXTRA_CPPFLAGS="${pecan_cppflags}" \
		EXTRA_LDFLAGS="${pecan_ldflags}" \
		EXTRA_LIBS="-lintl -iconv"
}

pecan_install_args="${pecan_install_args} ${make_args}"

pecan_post_stage()
{
	cp "${pecan_srcdir}/COPYING" "${pecan_stagedir}"
}

pecan_main "$@"
