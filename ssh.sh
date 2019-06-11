



#Ensure permissions on /etc/ssh/sshd_config are configured
cp /etc/ssh/sshd_config /tmp/backup/
chown root:root /etc/ssh/sshd_config
chmod og-rwx /etc/ssh/sshd_config


#Ensure SSH root login is disabled
if [[ "$(grep "^PermitRootLogin" /etc/ssh/sshd_config)" || "$(grep "^#PermitRootLogin" /etc/ssh/sshd_config)" != "PermitRootLogin no" ]]; then
    sed 's/^#PermitRootLogin.*/PermitRootLogin no/' /etc/ssh/sshd_config > /etc/ssh/sshd_config.bac
    sed 's/^PermitRootLogin.*/PermitRootLogin no/' /etc/ssh/sshd_config.bac > /etc/ssh/sshd_config.bac2
    mv -f /etc/ssh/sshd_config.bac2 /etc/ssh/sshd_config
    rm -f /etc/ssh/sshd_config.bac
    echo "Ensure SSH root login is disabled" >> /tmp/report.txt
else
    echo "PermitRootLogin no" >> /etc/ssh/sshd_config
    echo "Ensure SSH root login is disabled" >> /tmp/report.txt
fi


#Ensure SSH Protocol is set to 2
if [[ "$(grep "^Protocol" /etc/ssh/sshd_config)" || "$(grep "^Protocol" /etc/ssh/sshd_config)" != "Protocol 2" ]]; then
    sed 's/^#Protocol.*/Protocol 2/' /etc/ssh/sshd_config > /etc/ssh/sshd_config.bac
    sed 's/^Protocol.*/Protocol 2/' /etc/ssh/sshd_config.bac > /etc/ssh/sshd_config.bac2
    mv -f /etc/ssh/sshd_config.bac2 /etc/ssh/sshd_config
    rm -f /etc/ssh/sshd_config.bac
    echo "Ensure SSH Protocol is set to 2" >> /tmp/report.txt
else
	echo "Protocol 2" >> /etc/ssh/sshd_config
    echo "Ensure SSH Protocol is set to 2" >> /tmp/report.txt
fi




#Ensure SSH LogLevel is set to INFO
if [[ "$(grep "^LogLevel" /etc/ssh/sshd_config)" || "$(grep "^#LogLevel" /etc/ssh/sshd_config)" != "LogLevel INFO" ]]; then
    sed 's/^#LogLevel.*/LogLevel INFO/' /etc/ssh/sshd_config > /etc/ssh/sshd_config.bac
    sed 's/^LogLevel.*/LogLevel INFO/' /etc/ssh/sshd_config.bac > /etc/ssh/sshd_config.bac2
    mv -f /etc/ssh/sshd_config.bac2 /etc/ssh/sshd_config
    rm -f /etc/ssh/sshd_config.bac
    echo "Ensure SSH LogLevel is set to INFO" >> /tmp/report.txt
else
	echo "LogLevel INFO" >> /etc/ssh/sshd_config
    echo "Ensure SSH LogLevel is set to INFO" >> /tmp/report.txt
fi


#Ensure SSH X11 forwarding is disabled
if [[ "$(grep "^X11Forwarding" /etc/ssh/sshd_config)" || "$(grep "^#X11Forwarding" /etc/ssh/sshd_config)" != "X11Forwarding no" ]]; then
    sed 's/^#X11Forwarding.*/X11Forwarding no/' /etc/ssh/sshd_config > /etc/ssh/sshd_config.bac
    sed 's/^X11Forwarding.*/X11Forwarding no/' /etc/ssh/sshd_config.bac > /etc/ssh/sshd_config.bac2
    mv -f /etc/ssh/sshd_config.bac2 /etc/ssh/sshd_config
    rm -f /etc/ssh/sshd_config.bac
    echo "Ensure SSH X11 forwarding is disabled" >> /tmp/report.txt
else
	echo "X11Forwarding no" >> /etc/ssh/sshd_config
    echo "Ensure SSH X11 forwarding is disabled" >> /tmp/report.txt
fi


#Ensure SSH MaxAuthTries is set to 4 or less
if [[ "$(grep "^MaxAuthTries" /etc/ssh/sshd_config)" || "$(grep "^#MaxAuthTries" /etc/ssh/sshd_config)" != "MaxAuthTries 4" ]]; then
    sed 's/^#MaxAuthTries.*/MaxAuthTries 4/' /etc/ssh/sshd_config > /etc/ssh/sshd_config.bac
    sed 's/^MaxAuthTries.*/MaxAuthTries 4/' /etc/ssh/sshd_config.bac > /etc/ssh/sshd_config.bac2
    mv -f /etc/ssh/sshd_config.bac2 /etc/ssh/sshd_config
    rm -f /etc/ssh/sshd_config.bac
    echo "Ensure SSH MaxAuthTries is set to 4 or less" >> /tmp/report.txt
else
	echo "MaxAuthTries 4" >> /etc/ssh/sshd_config
    echo "Ensure SSH MaxAuthTries is set to 4 or less" >> /tmp/report.txt
fi



#Ensure SSH PermitEmptyPasswords is disabled
if [[ "$(grep "^PermitEmptyPasswords" /etc/ssh/sshd_config)" || "$(grep "^#PermitEmptyPasswords" /etc/ssh/sshd_config)" != "PermitEmptyPasswords no" ]]; then
    sed 's/^#PermitEmptyPasswords.*/PermitEmptyPasswords no/' /etc/ssh/sshd_config > /etc/ssh/sshd_config.bac
    sed 's/^PermitEmptyPasswords.*/PermitEmptyPasswords no/' /etc/ssh/sshd_config.bac > /etc/ssh/sshd_config.bac2
    mv -f /etc/ssh/sshd_config.bac2 /etc/ssh/sshd_config
    rm -f /etc/ssh/sshd_config.bac
    echo "Ensure SSH PermitEmptyPasswords is disabled" >> /tmp/report.txt
else
	echo "PermitEmptyPasswords no" >> /etc/ssh/sshd_config
    echo "Ensure SSH PermitEmptyPasswords is disabled" >> /tmp/report.txt
fi



#Ensure SSH PermitUserEnvironment is disabled
if [[ "$(grep "^PermitUserEnvironment" /etc/ssh/sshd_config)" || "$(grep "^#PermitUserEnvironment" /etc/ssh/sshd_config)" != "PermitUserEnvironment no" ]]; then
    sed 's/^#PermitUserEnvironment.*/PermitUserEnvironment no/' /etc/ssh/sshd_config > /etc/ssh/sshd_config.bac
    sed 's/^PermitUserEnvironment.*/PermitUserEnvironment no/' /etc/ssh/sshd_config.bac > /etc/ssh/sshd_config.bac2
    mv -f /etc/ssh/sshd_config.bac2 /etc/ssh/sshd_config
    rm -f /etc/ssh/sshd_config.bac
    echo "Ensure SSH PermitUserEnvironment is disabled" >> /tmp/report.txt
else
	echo "PermitUserEnvironment no" >> /etc/ssh/sshd_config
    echo "Ensure SSH PermitUserEnvironment is disabled" >> /tmp/report.txt
fi



#Ensure SSH Idle Timeout Interval is configured
if [[ "$(grep "^ClientAliveInterval" /etc/ssh/sshd_config)" || "$(grep "^#ClientAliveInterval" /etc/ssh/sshd_config)" != "ClientAliveInterval 300" ]]; then
    sed 's/^#ClientAliveInterval.*/ClientAliveInterval 300/' /etc/ssh/sshd_config > /etc/ssh/sshd_config.bac
    sed 's/^ClientAliveInterval.*/ClientAliveInterval 300/' /etc/ssh/sshd_config.bac > /etc/ssh/sshd_config.bac2
    mv -f /etc/ssh/sshd_config.bac2 /etc/ssh/sshd_config
    rm -f /etc/ssh/sshd_config.bac
else
	echo "ClientAliveInterval 300" >> /etc/ssh/sshd_config
fi

if [[ "$(grep "^ClientAliveCountMax" /etc/ssh/sshd_config)" || "$(grep "^#ClientAliveCountMax" /etc/ssh/sshd_config)" != "ClientAliveCountMax 0" ]]; then
    sed 's/^#ClientAliveCountMax.*/ClientAliveCountMax 0/' /etc/ssh/sshd_config > /etc/ssh/sshd_config.bac
    sed 's/^ClientAliveCountMax.*/ClientAliveCountMax 0/' /etc/ssh/sshd_config.bac > /etc/ssh/sshd_config.bac2
    mv -f /etc/ssh/sshd_config.bac2 /etc/ssh/sshd_config
    rm -f /etc/ssh/sshd_config.bac
    echo "Ensure SSH Idle Timeout Interval is configured" >> /tmp/report.txt
else
	echo "ClientAliveCountMax 0" >> /etc/ssh/sshd_config
    echo "Ensure SSH Idle Timeout Interval is configured" >> /tmp/report.txt
fi



#Ensure SSH LoginGraceTime is set to one minute or less
if [[ "$(grep "^LoginGraceTime" /etc/ssh/sshd_config)" || "$(grep "^#LoginGraceTime" /etc/ssh/sshd_config)" != "LoginGraceTime 60" ]]; then
    sed 's/^#LoginGraceTime.*/LoginGraceTime 60/' /etc/ssh/sshd_config > /etc/ssh/sshd_config.bac
    sed 's/^LoginGraceTime.*/LoginGraceTime 60/' /etc/ssh/sshd_config.bac > /etc/ssh/sshd_config.bac2
    mv -f /etc/ssh/sshd_config.bac2 /etc/ssh/sshd_config
    rm -f /etc/ssh/sshd_config.bac
    echo "Ensure SSH LoginGraceTime is set to one minute or less" >> /tmp/report.txt
else
	echo "LoginGraceTime 60" >> /etc/ssh/sshd_config
    echo "Ensure SSH LoginGraceTime is set to one minute or less" >> /tmp/report.txt
fi


#Ensure SSH warning banner is configured
if [[ "$(grep "^Banner" /etc/ssh/sshd_config)" || "$(grep "^#Banner" /etc/ssh/sshd_config)" != "Banner /etc/issue.net" ]]; then
    #sed 's/^#Banner.*/Banner /etc/issue.net/' /etc/ssh/sshd_config > /etc/ssh/sshd_config.bac
    #sed 's/^Banner.*/Banner /etc/issue.net/' /etc/ssh/sshd_config.bac > /etc/ssh/sshd_config.bac2
    mv -f /etc/ssh/sshd_config.bac2 /etc/ssh/sshd_config
    rm -f /etc/ssh/sshd_config.bac
    echo "Ensure SSH warning banner is configured" >> /tmp/report.txt
else
	echo "Banner /etc/issue.net" >> /etc/ssh/sshd_config
    echo "Ensure SSH warning banner is configured" >> /tmp/report.txt
fi

if [[ "$(grep "^#Port.*" /etc/ssh/sshd_config)" || "$(grep "^Port.*" /etc/ssh/sshd_config)" != "Port 63291" ]]; then
    sed 's/^#Port.*/Port 63291/' /etc/ssh/sshd_config > /etc/ssh/sshd_config.bac
    sed 's/^Port.*/Port 63291/' /etc/ssh/sshd_config.bac > /etc/ssh/sshd_config.bac2
    mv -f /etc/ssh/sshd_config.bac2 /etc/ssh/sshd_config
    rm -f /etc/ssh/sshd_config.bac
    echo "Changing ssh port" >> /tmp/report.txt
else
    echo "Port 63291" >> /etc/ssh/sshd_config
    echo "Changing ssh port" >> /tmp/report.txt
fi

systemctl restart sshd








