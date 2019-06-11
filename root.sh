##############################
#                            #
# 		Root Security		 #
#                            #
##############################


chown -R root:root ~/




echo "Remote root access will be disabled. (passwd file will be changed)"
read -p "Will you continue? (y/n)" choice
case "$choice" in
	y|Y )
		sed 's/root.*root:\/root:\/bin\/bash/root:x:0:0:root:\/root:\/sbin\/nologin/' /etc/passwd > /etc/passwd1
		cat /etc/passwd1 > /etc/passwd
		rm /etc/passwd1
		echo "Disable remote root login" >> /tmp/report.txt;;
	* ) echo "invalid";;
esac


echo "Root access to system devices will be disabled, but the root user will be able to access the console."
read -p "Will you continue? (y/n)" choice
case "$choice" in
  y|Y ) echo "tty1" > /etc/securetty
		echo "Disable any tty root shell" >> /tmp/report.txt;;
  * ) echo "invalid";;
esac


read -p "If you will use ssh service, you have to disable remote root access. (y/n)" choice
case "$choice" in
	y|Y )
	    sed 's/^#PermitRootLogin.*/PermitRootLogin no/' /etc/ssh/sshd_config > /etc/ssh/sshd_config.bac
	    sed 's/^PermitRootLogin.*/PermitRootLogin no/' /etc/ssh/sshd_config.bac > /etc/ssh/sshd_config.bac2
	    mv /etc/ssh/sshd_config.bac2 /etc/ssh/sshd_config
	    rm /etc/ssh/sshd_config.bac
	    echo "Disable root ssh login" >> /tmp/report.txt
	;;

esac




