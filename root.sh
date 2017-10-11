



echo "Remote root access will be disabled. (passwd file will be changed)"
read -p "Will you continue? (y/n)" choice
case "$choice" in 
	y|Y )
sed 's/root.*root:\/root:\/bin\/bash/root:x:0:0:root:\/root:\/sbin\/nologin/' /etc/passwd > /etc/passwd1
cat /etc/passwd1 > /etc/passwd
rm /etc/passwd1;;
	* ) echo "invalid";;
esac


echo "Root access to system devices will be disabled, but the root user will be able to access the console."
read -p "Will you continue? (y/n)" choice
case "$choice" in 
  y|Y ) echo > /etc/securetty
		echo "OK";;
  * ) echo "invalid";;
esac


echo "Root privileges will be restricted." #5. madde buraya bir daha bak farklı işlemler yapman gerekebilir.
read -p "Will you continue? (y/n)" choice
case "$choice" in
	y|Y )

		;;
esac


echo ""
read -p "If you will use ssh service, you have to disable remote root access. (y/n)" choice
case "$choice" in
	y|Y )
		. ssh.sh
	;; #root loginin engellemek için /etc/ssh/sshd_config dosyasında PermitRootLogin no yapmayı unutma

