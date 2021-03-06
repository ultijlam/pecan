#!/bin/sh

PECAN_PKGNAME="priv-1.0beta2+2"

pecan_description="Utility to execute commands as a different user"

pecan_fetch_file="priv-1.0-beta2.tar.gz"
pecan_fetch_url="ftp://ftp.thistledown.com.au/pub/simonb/"

pecan_tools_build="sed"

if [ -f ./pecan/pecan.subr ]; then
	. ./pecan/pecan.subr
elif [ -f ../pecan/pecan.subr ]; then
	. ../pecan/pecan.subr
else
	exit 1
fi

pecan_configure_style="gnu"

# The GNU configure script is old and doesn't accept the --docdir
# option. Set "pecan_docdir" to the empty string to skip adding that
# option automatically.
#
pecan_docdir=

pecan_post_configure()
{
	( cd "${pecan_srcdir}" &&
	  mv priv.1 priv.1.orig &&
	  sed -e "s|/usr/local/etc/|${pecan_etcdir}/|g" priv.1.orig > priv.1 )
}

pecan_post_stage()
{
	sed -e '/^$/,$d' -e "s,^# *,," "${pecan_srcdir}/Makefile.in" \
		> "${pecan_stagedir}/LICENSE"
}

pecan_install_args="${pecan_install_args} mandir=${pecan_mandir}/man1"
pecan_install_args="${pecan_install_args} sysconfdir=${pecan_pkgdir}"
pecan_install_args="${pecan_install_args} BINMODE=4711"

pecan_post_install()
{
	# Remove empty directory.
	rmdir "${pecan_pkgdir}/priv"
}

pecan_main "$@"
