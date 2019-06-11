case $(awk '{print$9}' /proc/version) in 
    \(Debian)
        apt-get install auditd -y
        ;;
    \(Red)
        yum install auditd -y
        ;;
esac;;





#Ensure audit log storage size is configured 
cp /etc/audit/auditd.conf /tmp/backup/
sed 's/max_log_file.*/max_log_file = 16/' /etc/audit/auditd.conf > /etc/audit/auditd.conf.bac
mv /etc/audit/auditd.conf.bac /etc/audit/auditd.conf



#Ensure the audit configuration is immutable
cp /etc/audit/audit.rules /tmp/backup/
sed 's/\-f.*/-e 2/' /etc/audit/audit.rules > /etc/audit/audit.rules.bac
mv  >> /etc/audit/audit.rules.bac  >> /etc/audit/audit.rules

#Ensure auditd service is enabled
if [[ "$(systemctl is-enabled auditd)" != "enabled" ]]; then
    systemctl enable auditd
fi

# Ensure system is disabled when audit logs are full 
Disable_Full_log()
{
	sed 's/^space_left_action.*/space_left_action = email/g' /etc/audit/auditd.conf > /etc/audit/auditd.conf.bac
	mv /etc/audit/auditd.conf.bac /etc/audit/auditd.conf

	sed 's/action_mail_acct.*/action_mail_acct = root/' /etc/audit/auditd.conf > /etc/audit/auditd.conf2
	mv /etc/audit/auditd.conf2 /etc/audit/auditd.conf

	sed 's/admin_space_left_action.*/admin_space_left_action = halt/' /etc/audit/auditd.conf > /etc/audit/auditd.conf2
	mv /etc/audit/auditd.conf2 /etc/audit/auditd.conf

	#Ensure audit logs are not automatically deleted 
	sed 's/max_log_file_action.*/max_log_file_action = keep_logs/' /etc/audit/auditd.conf > /etc/audit/auditd.conf2
	mv /etc/audit/auditd.conf2 /etc/audit/auditd.conf
}







#Ensure auditing for processes that start prior to auditd is enabled
if [[ "$(dd bs=512 count=1 if=/dev/sda 2>/dev/null | strings|grep GRUB)" == "GRUB" ]]; then
	cp /etc/default/grub /tmp/backup/
	sed 's/GRUB_CMDLINE_LINUX="/GRUB_CMDLINE_LINUX=" audit=1 /' /etc/default/grub > /etc/default/grub.bac
	mv /etc/default/grub.bac /etc/default/grub
	grub2-mkconfig > /boot/grub2/grub.cfg
fi





#Ensure events that modify date and time information are collected
if [[ "$(uname -m)" == "x86_64" ]]; then
    echo "-a always,exit -F arch=b64 -S adjtimex -S settimeofday -k time-change" >> /etc/audit/audit.rules
	echo "-a always,exit -F arch=b32 -S adjtimex -S settimeofday -S stime -k time- change" >> /etc/audit/audit.rules
	echo "-a always,exit -F arch=b64 -S clock_settime -k time-change" >> /etc/audit/audit.rules
	echo "-a always,exit -F arch=b32 -S clock_settime -k time-change" >> /etc/audit/audit.rules
	echo "-w /etc/localtime -p wa -k time-change" >> /etc/audit/audit.rules
elif [[ "$(uname -m)" == "i386" || "$(uname -m)" == "i686" ]]; then
    echo "-a always,exit -F arch=b32 -S adjtimex -S settimeofday -S stime -k time- change" >> /etc/audit/audit.rules
	echo "-a always,exit -F arch=b32 -S clock_settime -k time-change" >> /etc/audit/audit.rules
	echo "-w /etc/localtime -p wa -k time-change" >> /etc/audit/audit.rules
fi




#Ensure events that modify user/group information are collected
Audit_Logging_File()
{
	echo "-w /etc/group -p wa -k identity" >> /etc/audit/audit.rules
	echo "-w /etc/passwd -p wa -k identity" >> /etc/audit/audit.rules
	echo "-w /etc/shadow -p wa -k identity" >> /etc/audit/audit.rules
	echo "-w /etc/gshadow -p wa -k identity" >> /etc/audit/audit.rules
	echo "-w /etc/security/opasswd -p wa -k identity" >> /etc/audit/audit.rules
}



#Ensure events that modify the system's network environment are collected
if [[ "$(uname -m)" == "x86_64" ]]; then
    echo "-a always,exit -F arch=b64 -S sethostname -S setdomainname -k system-locale" >> /etc/audit/audit.rules	
    echo "-a always,exit -F arch=b32 -S sethostname -S setdomainname -k system-locale" >> /etc/audit/audit.rules	
    echo "-w /etc/issue -p wa -k system-locale" >> /etc/audit/audit.rules	
    echo "-w /etc/issue.net -p wa -k system-locale" >> /etc/audit/audit.rules	
    echo "-w /etc/hosts -p wa -k system-locale" >> /etc/audit/audit.rules	
    echo "-w /etc/sysconfig/network -p wa -k system-locale" >> /etc/audit/audit.rules

elif [[ "$(uname -m)" == "i386" || "$(uname -m)" == "i686" ]]; then
    echo "-a always,exit -F arch=b32 -S sethostname -S setdomainname -k system-locale -w /etc/issue -p wa -k system-locale" >> /etc/audit/audit.rules
	echo "-w /etc/issue.net -p wa -k system-locale" >> /etc/audit/audit.rules
	echo "-w /etc/hosts -p wa -k system-locale" >> /etc/audit/audit.rules
	echo "-w /etc/sysconfig/network -p wa -k system-locale" >> /etc/audit/audit.rules
fi









#Ensure events that modify the system's Mandatory Access Controls are collected
echo "-w /etc/selinux/ -p wa -k MAC-policy" >> /etc/audit/audit.rules


#Ensure login and logout events are collected 
echo "-w /var/log/lastlog -p wa -k logins" >> /etc/audit/audit.rules
echo "-w /var/run/faillock/ -p wa -k logins" >> /etc/audit/audit.rules



#Ensure session initiation information is collected
echo "-w /var/run/utmp -p wa -k session" >> /etc/audit/audit.rules
echo "-w /var/log/wtmp -p wa -k session" >> /etc/audit/audit.rules
echo "-w /var/log/btmp -p wa -k session" >> /etc/audit/audit.rules


#Ensure discretionary access control permission modification events are collected
if [[ "$(uname -m)" == "x86_64" ]]; then
    echo "-a always,exit -F arch=b64 -S chmod -S fchmod -S fchmodat -F auid>=1000 -F auid!=4294967295 -k perm_mod" >> /etc/audit/audit.rules	
    echo "-a always,exit -F arch=b32 -S chmod -S fchmod -S fchmodat -F auid>=1000 -F auid!=4294967295 -k perm_mod" >> /etc/audit/audit.rules	
    echo "-a always,exit -F arch=b64 -S chown -S fchown -S fchownat -S lchown -F auid>=1000 -F auid!=4294967295 -k perm_mod" >> /etc/audit/audit.rules	
    echo "-a always,exit -F arch=b32 -S chown -S fchown -S fchownat -S lchown -F auid>=1000 -F auid!=4294967295 -k perm_mod" >> /etc/audit/audit.rules	
    echo "-a always,exit -F arch=b64 -S setxattr -S lsetxattr -S fsetxattr -S removexattr -S lremovexattr -S fremovexattr -F auid>=1000 -F auid!=4294967295 -k perm_mod" >> /etc/audit/audit.rules	
    echo "-a always,exit -F arch=b32 -S setxattr -S lsetxattr -S fsetxattr -S removexattr -S lremovexattr -S fremovexattr -F auid>=1000 -F auid!=4294967295 -k perm_mod" >> /etc/audit/audit.rules
elif [[ "$(uname -m)" == "i386" || "$(uname -m)" == "i686" ]]; then
    echo "-a always,exit -F arch=b32 -S chmod -S fchmod -S fchmodat -F auid>=1000 -F auid!=4294967295 -k perm_mod" >> /etc/audit/audit.rules
	echo "-a always,exit -F arch=b32 -S chown -S fchown -S fchownat -S lchown -F auid>=1000 -F auid!=4294967295 -k perm_mod" >> /etc/audit/audit.rules
	echo "-a always,exit -F arch=b32 -S setxattr -S lsetxattr -S fsetxattr -S removexattr -S lremovexattr -S fremovexattr -F auid>=1000 -F auid!=4294967295 -k perm_mod" >> /etc/audit/audit.rules
fi


#Ensure unsuccessful unauthorized file access attempts are collected
if [[ "$(uname -m)" == "x86_64" ]]; then
    echo "-a always,exit -F arch=b64 -S creat -S open -S openat -S truncate -S ftruncate -F exit=-EACCES -F auid>=1000 -F auid!=4294967295 -k access" >> /etc/audit/audit.rules	
    echo "-a always,exit -F arch=b32 -S creat -S open -S openat -S truncate -S ftruncate -F exit=-EACCES -F auid>=1000 -F auid!=4294967295 -k access" >> /etc/audit/audit.rules	
    echo "-a always,exit -F arch=b64 -S creat -S open -S openat -S truncate -S ftruncate -F exit=-EPERM -F auid>=1000 -F auid!=4294967295 -k access" >> /etc/audit/audit.rules	
    echo "-a always,exit -F arch=b32 -S creat -S open -S openat -S truncate -S ftruncate -F exit=-EPERM -F auid>=1000 -F auid!=4294967295 -k access" >> /etc/audit/audit.rules	
elif [[ "$(uname -m)" == "i386" || "$(uname -m)" == "i686" ]]; then
    echo "-a always,exit -F arch=b32 -S creat -S open -S openat -S truncate -S ftruncate -F exit=-EACCES -F auid>=1000 -F auid!=4294967295 -k access" >> /etc/audit/audit.rules
	echo "-a always,exit -F arch=b32 -S creat -S open -S openat -S truncate -S ftruncate -F exit=-EPERM -F auid>=1000 -F auid!=4294967295 -k access" >> /etc/audit/audit.rules
fi

#Ensure use of privileged commands is collected
find / -xdev \( -perm -4000 -o -perm -2000 \) -type f | awk '{print "-a always,exit -F path=" $1 " -F perm=x -F auid>=1000 -F auid!=4294967295 -k privileged" }' >> /etc/audit/audit.rules



#Ensure successful file system mounts are collected 
if [[ "$(uname -m)" == "x86_64" ]]; then
    echo "-a always,exit -F arch=b64 -S mount -F auid>=1000 -F auid!=4294967295 -k mounts" >> /etc/audit/audit.rules	
    echo "-a always,exit -F arch=b32 -S mount -F auid>=1000 -F auid!=4294967295 -k mounts" >> /etc/audit/audit.rules	
elif [[ "$(uname -m)" == "i386" || "$(uname -m)" == "i686" ]]; then
    echo "-a always,exit -F arch=b32 -S mount -F auid>=1000 -F auid!=4294967295 -k mounts" >> /etc/audit/audit.rules
fi



#Ensure file deletion events by users are collected
if [[ "$(uname -m)" == "x86_64" ]]; then
    echo "-a always,exit -F arch=b64 -S unlink -S unlinkat -S rename -S renameat -F auid>=1000 -F auid!=4294967295 -k delete" >> /etc/audit/audit.rules	
    echo "-a always,exit -F arch=b32 -S unlink -S unlinkat -S rename -S renameat -F auid>=1000 -F auid!=4294967295 -k delete" >> /etc/audit/audit.rules	
elif [[ "$(uname -m)" == "i386" || "$(uname -m)" == "i686" ]]; then
    echo "-a always,exit -F arch=b32 -S unlink -S unlinkat -S rename -S renameat -F auid>=1000 -F auid!=4294967295 -k delete" >> /etc/audit/audit.rules
fi



#Ensure changes to system administration scope (sudoers) is collected
echo "-w /etc/sudoers -p wa -k scope" >> /etc/audit/audit.rules	
echo "-w /etc/sudoers.d -p wa -k scope" >> /etc/audit/audit.rules	


#Ensure system administrator actions (sudolog) are collected
echo "-w /var/log/sudo.log -p wa -k actions" >> /etc/audit/audit.rules	

       
#Ensure kernel module loading and unloading is collected
if [[ "$(uname -m)" == "x86_64" ]]; then
    echo "-w /sbin/insmod -p x -k modules" >> /etc/audit/audit.rules
    echo "-w /sbin/rmmod -p x -k modules" >> /etc/audit/audit.rules
    echo "-w /sbin/modprobe -p x -k modules" >> /etc/audit/audit.rules
    echo "-a always,exit arch=b64 -S init_module -S delete_module -k modules" >> /etc/audit/audit.rules
elif [[ "$(uname -m)" == "i386" || "$(uname -m)" == "i686" ]]; then
    echo "-w /sbin/insmod -p x -k modules" >> /etc/audit/audit.rules
    echo "-w /sbin/rmmod -p x -k modules" >> /etc/audit/audit.rules
    echo "-w /sbin/modprobe -p x -k modules" >> /etc/audit/audit.rules
    echo "-a always,exit arch=b32 -S init_module -S delete_module -k modules" >> /etc/audit/audit.rules
fi






####################


if [[ "$(rpm -q rsyslog|grep "not installed")" == "package rsyslog is not installed" ]]; then
    yum install rsyslog -y
fi


#Enable
if [[ "$(systemctl is-enabled rsyslog)" != "enabled" ]]; then
    systemctl enable rsyslog
fi

#Ensure logging is configured
echo -e "*.emerg \t :omusrmsg:*" >> /etc/rsyslog.conf
echo -e "mail.* \t -/var/log/mail" >> /etc/rsyslog.conf
echo -e "mail.info \t -/var/log/mail.info" >> /etc/rsyslog.conf
echo -e "mail.warning \t -/var/log/mail.warn" >> /etc/rsyslog.conf
echo -e "mail.err \t /var/log/mail.err" >> /etc/rsyslog.conf #tire yok dosya başında kontrol et###

echo -e "news.crit \t -/var/log/news/news.crit" >> /etc/rsyslog.conf
echo -e "news.err \t -/var/log/news/news.err" >> /etc/rsyslog.conf
echo -e "news.notice \t -/var/log/news/news.notice" >> /etc/rsyslog.conf
echo -e "*.=warning;*.=err \t -/var/log/warn" >> /etc/rsyslog.conf
echo -e "*.crit \t /var/log/warn" >> /etc/rsyslog.conf #tire yok dosya başında kontrol et###

echo -e "*.*;mail.none;news.none \t -/var/log/messages" >> /etc/rsyslog.conf

pkill -HUP rsyslogd



#Configure syslog-ng

#Is installed?
if [[ "$(rpm -q syslog-ng|grep "not installed")" == "package syslog-ng is not installed" ]]; then
    yum install syslog-ng
fi




if [[ "$(systemctl is-enabled syslog-ng)" != "enabled" ]]; then
    systemctl enable syslog-ng -y
fi


#Ensure logging is configured

echo "log { source(src); source(chroots); filter(f_console); destination(console); };" >> /etc/syslog-ng/syslog-ng.conf
echo "log { source(src); source(chroots); filter(f_console); destination(xconsole); };" >> /etc/syslog-ng/syslog-ng.conf
echo "log { source(src); source(chroots); filter(f_newscrit); destination(newscrit); };" >> /etc/syslog-ng/syslog-ng.conf
echo "log { source(src); source(chroots); filter(f_newserr); destination(newserr); };" >> /etc/syslog-ng/syslog-ng.conf
echo "log { source(src); source(chroots); filter(f_newsnotice); destination(newsnotice); };" >> /etc/syslog-ng/syslog-ng.conf
echo "log { source(src); source(chroots); filter(f_mailinfo); destination(mailinfo); };" >> /etc/syslog-ng/syslog-ng.conf
echo "log { source(src); source(chroots); filter(f_mailwarn); destination(mailwarn); };" >> /etc/syslog-ng/syslog-ng.conf
echo "log { source(src); source(chroots); filter(f_mailerr); destination(mailerr); };" >> /etc/syslog-ng/syslog-ng.conf
echo "log { source(src); source(chroots); filter(f_mail); destination(mail); };" >> /etc/syslog-ng/syslog-ng.conf
echo "log { source(src); source(chroots); filter(f_acpid); destination(acpid); flags(final); };" >> /etc/syslog-ng/syslog-ng.conf
echo "log { source(src); source(chroots); filter(f_acpid_full); destination(devnull); flags(final); };" >> /etc/syslog-ng/syslog-ng.conf
echo "log { source(src); source(chroots); filter(f_acpid_old); destination(acpid); flags(final); };" >> /etc/syslog-ng/syslog-ng.conf
echo "log { source(src); source(chroots); filter(f_netmgm); destination(netmgm); flags(final); };" >> /etc/syslog-ng/syslog-ng.conf
echo "log { source(src); source(chroots); filter(f_local); destination(localmessages); };" >> /etc/syslog-ng/syslog-ng.conf
echo "log { source(src); source(chroots); filter(f_messages); destination(messages); };" >> /etc/syslog-ng/syslog-ng.conf
echo "log { source(src); source(chroots); filter(f_iptables); destination(firewall); };" >> /etc/syslog-ng/syslog-ng.conf
echo "log { source(src); source(chroots); filter(f_warn); destination(warn); };" >> /etc/syslog-ng/syslog-ng.conf
pkill -HUP syslog-ng



