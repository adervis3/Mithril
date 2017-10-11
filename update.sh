


###############################
#                             #
# 		 Update System		  #
#                             #
###############################


case $OS in
	Debian)
		#apt-get update -y; apt-get upgrade -y; apt-get dist-upgrade -y; apt-get autoclean -y; apt-get autoremove -y
		echo "Güncelleme yapıyor";;
	Rhel)
		#yum clean all; yum update; yum upgrade; yum autoremove; yum clean
		echo "Rhel";;
	Arch)
		#pacman -Syyu; pacman -Sc
		echo "Arch";;
esac