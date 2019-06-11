
systemctl list-unit-files --type service > oku.txt
cat oku.txt
rm -rf oku.txt


if [[ "$(systemctl is-enabled avahi-daemon)" == "enabled" ]]; then
    systemctl disable avahi-daemon
    systemctl stop avahi-daemon
    echo "Disable avahi-daemon" >> /tmp/report.txt
fi

if [[ "$(systemctl is-enabled cups)" == "enabled" ]]; then
    systemctl disable cups
	systemctl stop cups
	echo "Disable cups" >> /tmp/report.txt
fi

if [[ "$(systemctl is-enabled dhcpd)" == "enabled" ]]; then
    systemctl disable dhcpd
	systemctl stop dhcpd
	echo "Disable dhcpd" >> /tmp/report.txt
fi

if [[ "$(systemctl is-enabled slapd)" == "enabled" ]]; then
    systemctl disable slapd
	systemctl stop slapd
	echo "Disable slapd" >> /tmp/report.txt
fi

if [[ "$(systemctl is-enabled nfs)" == "enabled" ]]; then
    systemctl disable nfs
	systemctl stop nfs
	echo "Disable nfs" >> /tmp/report.txt
fi
if [[ "$(systemctl is-enabled rpcbind)" == "enabled" ]]; then
    systemctl disable rpcbind
	systemctl stop rpcbind
	echo "Disable rpcbind" >> /tmp/report.txt
fi

if [[ "$(systemctl is-enabled named)" == "enabled" ]]; then
    systemctl disable named
	systemctl stop named
	echo "Disable named" >> /tmp/report.txt
fi

if [[ "$(systemctl is-enabled vsftpd)" == "enabled" ]]; then
    systemctl disable vsftpd
	systemctl stop vsftpd
	echo "Disable vsftpd" >> /tmp/report.txt
fi

if [[ "$(systemctl is-enabled httpd)" == "enabled" ]]; then
    systemctl disable httpd
	systemctl stop httpd
	echo "Disable httpd" >> /tmp/report.txt
fi

if [[ "$(systemctl is-enabled dovecot)" == "enabled" ]]; then
    systemctl disable dovecot
	systemctl stop dovecot
	echo "Disable dovecot" >> /tmp/report.txt
fi

if [[ "$(systemctl is-enabled smb)" == "enabled" ]]; then
    systemctl disable smb
	systemctl stop smb
	echo "Disable smb" >> /tmp/report.txt
fi

if [[ "$(systemctl is-enabled squid)" == "enabled" ]]; then
    systemctl disable squid
	systemctl stop squid
	echo "Disable squid" >> /tmp/report.txt
fi

if [[ "$(systemctl is-enabled snmpd)" == "enabled" ]]; then
    systemctl disable snmpd
	systemctl stop snmpd
	echo "Disable snmpd" >> /tmp/report.txt
fi

if [[ "$(systemctl is-enabled postfix)" == "enabled" ]]; then
	cp /etc/postfix/main.cf /tmp/backup/main.cf
    sed -e 's/^inet_interfaces =.*/inet_interfaces = localhost/g' /etc/postfix/main.cf > /etc/postfix/main2.cf
    rm -rf /etc/postfix/main.cf
    mv main2.cf /etc/postfix/main.cf
    systemctl restart postfix 
	echo "Ensure mail transfer agent is configured for local-only mode" >> /tmp/report.txt
fi

if [[ "$(systemctl is-enabled ypserv)" == "enabled" ]]; then
    systemctl disable ypserv
	systemctl stop ypserv
	echo "Disable ypserv" >> /tmp/report.txt
fi

if [[ "$(systemctl is-enabled rsh.socket)" == "enabled" ]]; then
    systemctl disable rsh.socket
	systemctl stop rsh.socket
	echo "Disable rsh.socket" >> /tmp/report.txt
fi

if [[ "$(systemctl is-enabled rlogin.socket)" == "enabled" ]]; then
    systemctl disable rlogin.socket
	systemctl stop rlogin.socket
	echo "Disable rlogin.socket" >> /tmp/report.txt
fi

if [[ "$(systemctl is-enabled rexec.socket)" == "enabled" ]]; then
    systemctl disable rexec.socket
	systemctl stop rexec.socket
	echo "Disable rexec.socket" >> /tmp/report.txt
fi

if [[ "$(systemctl is-enabled telnet.socket)" == "enabled" ]]; then
    systemctl disable telnet.socket
	systemctl stop telnet.socket
	echo "Disable telnet.socket" >> /tmp/report.txt
fi

if [[ "$(systemctl is-enabled tftp.socket)" == "enabled" ]]; then
    systemctl disable tftp.socket
	systemctl stop tftp.socket
	echo "Disable tftp.socket" >> /tmp/report.txt
fi

if [[ "$(systemctl is-enabled rsyncd)" == "enabled" ]]; then
    systemctl disable rsyncd
	systemctl stop rsyncd
	echo "Disable rsyncd" >> /tmp/report.txt
fi

if [[ "$(systemctl is-enabled ntalk)" == "enabled" ]]; then
    systemctl disable ntalk
	systemctl stop ntalk
	echo "Disable ntalk" >> /tmp/report.txt
fi

if [[ "$(rpm -q ypbind)" != "package ypbind is not installed" ]]; then
    yum remove ypbind -y
	echo "Remove ypbind" >> /tmp/report.txt
fi

if [[ "$(rpm -q rsh)" != "package rsh is not installed" ]]; then
    yum remove rsh -y
	echo "Remove rsh" >> /tmp/report.txt
fi

if [[ "$(rpm -q talk)" != "package talk is not installed" ]]; then
    yum remove talk -y
	echo "Remove talk" >> /tmp/report.txt
fi

if [[ "$(rpm -q telnet)" != "package telnet is not installed" ]]; then
	yum remove telnet -y 
	echo "Remove telnet" >> /tmp/report.txt 
fi

if [[ "$(rpm -q openldap-clients)" != "package openldap-clients is not installed" ]]; then
    yum remove openldap-clients -y
	echo "Remove openldap-clients" >> /tmp/report.txt
fi




# Auditing and Syslog should always be on...
/sbin/chkconfig --level 0123456 auditd on &> /dev/null
/sbin/service auditd start &> /dev/null
echo "Auditing always be on" >> /tmp/report.txt

/sbin/chkconfig --level 0123456 rsyslog on &> /dev/null
/sbin/service rsyslog start &> /dev/null
echo "Rsyslog always be on" >> /tmp/report.txt

### IPv6 - Requires ip6tables
`grep NETWORKING_IPV6 /etc/sysconfig/network | grep -q yes`
#if [ $? -eq 0 ]; then
#	echo "Enabling ip6tables Service."
#	/sbin/chkconfig ip6tables on &> /dev/null
#	/sbin/service ip6tables start &> /dev/null
#else
#	echo "Disabling ip6tables Service."
#	/sbin/chkconfig ip6tables off &> /dev/null
#	/sbin/service ip6tables stop &> /dev/null
#fi