###############################
#                             #
# 		 Update System		  #
#                             #
###############################

case $OS in
	Debian)
    read -p "Do you want to update all system? (y/n)" choice
    case "$choice" in
    	y|Y|yes|YES ) apt-get dist-upgrade -y;apt-get autoclean -y; apt-get autoremove -y;;
    	n|N|no|NO ) ;;
    esac
		echo "Debian Güncelleme yapıyor";;
	Rhel)

		echo "Rhel Güncelleme yapıyor"
		yum check-update
		read -p "Do you want to update all system? (y/n)" choice
		case "$choice" in
			y|Y|yes|YES )
				yum update -y
				;;
			n|N|no|NO ) ;;
		esac




		;;
	Arch)
		#pacman -Syyu; pacman -Sc
		echo "Arch Güncelleme yapıyor";;
esac
