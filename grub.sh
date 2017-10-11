


read -p "Have you grub? (y/n)" choice
case choice in
	y|Y )
		update-grub 
		clear
		echo "You have to give password (2 times)..."
		grub-md5-crypt tee password.txt
		sed 's/^Password://' password.txt >yeni.txt
		sed 's/^Retype password://' yeni.txt>password.txt   #Grub parolası çok farklı şekilde koyuluyor bir bak sekmelerde açık
		cat /boot/grub/menu.lst > islem.txt
		sed 's/#     password --md5................................./      password --md5 /' islem.txt
		;;
	n|N ) ;;
esac