#!/bin/sh

PECAN_PKGNAME="testsuite-0"

. ./pecan.subr

pecan_pkgspec_parse_test_helper()
{
	test_pkgspec="$1"
	pecan_pkgspec_parse $test_pkgspec test_pkgname test_version
	echo "$test_pkgspec: <$test_pkgname, $test_version>"
}

pecan_pkgspec_parse_test()
{
	echo "pecan_pkgspec_parse:"
	pecan_pkgspec_parse_test_helper zlib-1.2.7
	pecan_pkgspec_parse_test_helper perl-5.005
	pecan_pkgspec_parse_test_helper png-1.2.8c
	pecan_pkgspec_parse_test_helper openssl-0.9.9g+10
	pecan_pkgspec_parse_test_helper "foo-*"
	echo
}

pecan_vercmp_test_helper()
{
	pecan_vercmp "$1" "$2"
	test_result=$?
	if test $test_result -eq 2; then
		echo "$1 < $2"
	elif test $test_result -eq 0; then
		echo "$1 = $2 [FAIL]"
	elif test $test_result -eq 1; then
		echo "$1 > $2 [FAIL]"
	fi
}

pecan_vercmp_test()
{
	echo "pecan_vercmp:"
	pecan_vercmp_test_helper 1 1+1
	pecan_vercmp_test_helper 1.0 1.0.1
	pecan_vercmp_test_helper 1.23.2 1.23.11
	pecan_vercmp_test_helper 1.23.0alpha 1.23.0
	pecan_vercmp_test_helper 1.23.0alpha 1.23.0alpha1
	pecan_vercmp_test_helper 1.23.0alpha2 1.23.0alpha11
	pecan_vercmp_test_helper 1.23.0alpha 1.23.0beta
	pecan_vercmp_test_helper 1.23.0alpha 1.23.0rc
	pecan_vercmp_test_helper 1.23.0beta 1.23.0rc
	pecan_vercmp_test_helper 1.23.0alpha 1.23.0e
	pecan_vercmp_test_helper 1.23.0a 1.23.0b
	pecan_vercmp_test_helper 1.23.0a2 1.23.0a11
	pecan_vercmp_test_helper 1.23.0rc1 1.23.0a
	pecan_vercmp_test_helper 1.23.0 1.23.0+1
	pecan_vercmp_test_helper 1.23.0alpha99 1.23.0+1
	pecan_vercmp_test_helper 1.23.0+2 1.23.0+11
	pecan_vercmp_test_helper "*" 1.0
	echo
}

pecan_pkgspec_match_test_helper()
{
	if pecan_pkgspec_match "$1" "$2" test_result; then
		echo "\`$1 $2' best match is $test_result."
	else
		echo "\`$1 $2' does not match any package."
	fi
}

pecan_pkgspec_match_test()
{
	echo "pecan_pkgspec_match:"
	OLD_PECAN_TARGET="${PECAN_TARGET}"
	OLD_PECAN_SOURCE="${PECAN_SOURCE}"
	PECAN_TARGET="${pecan_topdir}/.pecan"
	PECAN_SOURCE="${PECAN_TARGET}/pecan"

	mkdir -p ${PECAN_SOURCE}
	mkdir -p ${PECAN_SOURCE}/zlib-1.2.1
	mkdir -p ${PECAN_SOURCE}/zlib-1.2.5
	mkdir -p ${PECAN_SOURCE}/zlib-1.2.7

	pecan_pkgspec_match_test_helper "=" "zlib-1.2.3" 
	pecan_pkgspec_match_test_helper "<" "zlib-1.2.3" 
	pecan_pkgspec_match_test_helper "*" "zlib-1.2.3" 
	pecan_pkgspec_match_test_helper "*" "zlib-*" 
	pecan_pkgspec_match_test_helper "<=" "zlib-1.2.5" 
	pecan_pkgspec_match_test_helper ">=" "zlib-1.2.5" 

	rm -rf "${PECAN_TARGET}"
	PECAN_TARGET="${OLD_PECAN_TARGET}"
	PECAN_SOURCE="${OLD_PECAN_SOURCE}"
	echo
}

pecan_encap_install_test_helper()
{
	pkgdir=${PECAN_SOURCE}/test-pkg-1.0

	mkdir -p ${pkgdir}
	mkdir -p ${pkgdir}/bin
	mkdir -p ${pkgdir}/lib
	mkdir -p ${pkgdir}/share
	mkdir -p ${pkgdir}/share/doc
	mkdir -p ${pkgdir}/share/doc/test-pkg
	mkdir -p ${pkgdir}/share/man
	mkdir -p ${pkgdir}/share/man/man1
	mkdir -p ${pkgdir}/share/man/man3

	touch ${pkgdir}/bin/testprog
	touch ${pkgdir}/lib/libtest.a
	touch ${pkgdir}/lib/libtest.so
	touch ${pkgdir}/lib/libtest.so.1.0
	touch ${pkgdir}/share/doc/test-pkg/README
	touch ${pkgdir}/share/man/man1/testprog.1
	touch ${pkgdir}/share/man/man3/test_func.3

	echo "linkname bin/testprog gnutestprog" > ${pkgdir}/encapinfo
	echo "exclude lib/libtest.so*" >> ${pkgdir}/encapinfo
	echo "linkdir share/doc/test-pkg" >> ${pkgdir}/encapinfo
	echo "linkdir share/man" >> ${pkgdir}/encapinfo

	mkdir -p ${PECAN_TARGET}/share/man
}

pecan_encap_install_test()
{
	echo "pecan_encap_install:"
	OLD_PECAN_EPKG_CMD="${PECAN_EPKG_CMD}"
	OLD_PECAN_TARGET="${PECAN_TARGET}"
	OLD_PECAN_SOURCE="${PECAN_SOURCE}"
	PECAN_EPKG_CMD=/nonexistent
	PECAN_TARGET="${pecan_topdir}/.pecan"
	PECAN_SOURCE="${PECAN_TARGET}/pecan"

	[ -d ${PECAN_SOURCE}/test-pkg-1.0 ] || \
		pecan_encap_install_test_helper

	( cd ${PECAN_SOURCE}/test-pkg-1.0 && find . | sort )

	pecan_encap_install test-pkg-1.0

	( cd ${PECAN_TARGET} && find . | grep -v "^[.]/pecan" | sort )

	rm -rf "${PECAN_TARGET}"
	PECAN_EPKG_CMD="${OLD_PECAN_EPKG_CMD}"
	PECAN_TARGET="${OLD_PECAN_TARGET}"
	PECAN_SOURCE="${OLD_PECAN_SOURCE}"
	echo
}

pecan_pkgspec_parse_test
pecan_vercmp_test
pecan_pkgspec_match_test
pecan_encap_install_test
