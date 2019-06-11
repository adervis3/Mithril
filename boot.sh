


read -p "Have you grub? (y/n)" choice
case choice in
	y|Y )
		update-grub
		clear
		echo "You have to give password (2 times)..."
		grub-md5-crypt | tee password.txt
		sed 's/^Password://' password.txt >yeni.txt
		sed 's/^Retype password://' yeni.txt>password.txt   
		cat /boot/grub/menu.lst > islem.txt
		sed 's/#     password --md5................................./      password --md5 /' islem.txt
		chmod 600 /boot/grub/menu.lst
		;;
	n|N )
		read -p "Do you want to install grub? (y/n)" choice
		case choice in
			y|Y )
				case $OS in
					Debian )
						apt-get install grub -y
						. grub.sh;;
					Rhel )
						yum install grub -y
						. grub.sh;;
					Arch )
						;;
				esac;;
			n|N )
				;;
		esac


;;
esac




echo "Require Authentication for Single User Mode" >> /tmp/report.txt
echo "SINGLE=/sbin/sulogin" >> /etc/sysconfig/init

