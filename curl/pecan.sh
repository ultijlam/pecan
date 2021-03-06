#!/bin/sh

PECAN_PKGNAME="curl-7.28.0+3"

pecan_description="Command-line tool for transferring data with URL syntax"

pecan_fetch_url="http://curl.haxx.se/download/%FILE%"

pecan_abi_version="7.28.0"
pecan_api_version="7.12.3"

pecan_prereq_lib=">= libidn-0.4.6"
pecan_prereq_lib="${pecan_prereq_lib} >= openssl-1.0.1c"
pecan_prereq_lib="${pecan_prereq_lib} >= zlib-1.1.4"

pecan_tools_build="pkg-config sed"

if [ -f ./pecan/pecan.subr ]; then
	. ./pecan/pecan.subr
elif [ -f ../pecan/pecan.subr ]; then
	. ../pecan/pecan.subr
else
	exit 1
fi

configure_args="--with-ca-path=${PECAN_TARGET}/etc/ssl/certs"
configure_args="${configure_args} --with-libidn"
configure_args="${configure_args} --with-ssl"
configure_args="${configure_args} --with-zlib"

pecan_configure_style="gnu"
pecan_configure_args="${pecan_configure_args} ${configure_args}"

pecan_post_stage()
{
	curl_license="${pecan_stagedir}/LICENSE"
	cat "${pecan_srcdir}"/COPYING > "${curl_license}"
	echo >> "${curl_license}"
	echo "lib/krb4.c:" >> "${curl_license}"
	sed -e '1,/name space/d' -e '/ [*][/]/,$d' -e "s/^ *[*] *//" \
		"${pecan_srcdir}"/lib/krb4.c >> "${curl_license}"
	echo "lib/krb5.c:" >> "${curl_license}"
	sed -e '1d' -e '/#include/,$d' -e "s/^ *[*] *//" \
		"${pecan_srcdir}"/lib/krb5.c >> "${curl_license}"
	echo "lib/security.c:" >> "${curl_license}"
	sed -e '1,/below/d' -e '/#include/,$d' -e "s/^ *[*] *//" \
		"${pecan_srcdir}"/lib/security.c >> "${curl_license}"
}

pecan_main "$@"
