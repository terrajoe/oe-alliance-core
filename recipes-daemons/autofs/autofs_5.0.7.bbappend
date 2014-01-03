PRINC = "9"

FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"

SRC_URI += " file://volatiles.99_autofs"

EXTRA_OECONF += "--with-confdir=/etc/default"

# Remove bash scripting from init script (meaning, remove "function"
# from each shell function)
do_configure_prepend () {
	for bashfile in redhat/autofs.init.in samples/rc.autofs.in
	do
		sed -i 's.#!/bin/bash.#!/bin/sh.' $bashfile
		sed -i 's/^function //g' $bashfile
	done
}

# Remove and change configuration files
do_install_append() {
    echo "/media/autofs  /etc/auto.network  --ghost" >> ${D}/etc/auto.master
    echo "# automounter configuration" > ${D}/etc/auto.network
    chmod 0644 ${D}/etc/auto.network
    rm -f ${D}/etc/auto.smb ${D}/etc/auto.misc ${D}/etc/autofs_ldap_auth.conf
    sed -i 's/^TIMEOUT=300/TIMEOUT=5/' ${D}/etc/default/autofs
    sed -i 's/count -lt 15/count -lt 60/' ${D}/etc/init.d/autofs
    sed -i 's/sleep 20/sleep 1/' ${D}/etc/init.d/autofs
    install -d ${D}${sysconfdir}/default/volatiles
    install -m 644 ${WORKDIR}/volatiles.99_autofs ${D}${sysconfdir}/default/volatiles/99_autofs
}