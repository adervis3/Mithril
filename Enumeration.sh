#!/bin/sh

case $(uname) in
    Linux)
	if [[ -e /etc/debian_version ]]; then
		OS="Debian"
		source /etc/os-release
	elif [[ -e /etc/centos-release ]]; then
		OS="Rhel"
	elif [[ -e /etc/arch-release ]]; then
		OS="Arch"
	else
		echo "Other GNU/Linux Distro"
		exit 1
	fi;;
    *)
        echo "Only GNU/Linux"
esac


#KERNEL Check
NEW_KERNEL_VERSION=$(curl "https://www.kernel.org/"| grep -A 1 "<td>stable:</td>" | grep -v "stable" -m1| cut -d'>' -f3| cut -d'.' -f1,2)
KERNEL_VERSION=$(uname -r|cut -d'.' -f1,2)

if [ $KERNEL_VERSION -eq $NEW_KERNEL_VERSION ]
  then
      NEED_KERNEL_UPDATE=0
      echo "You don't need Kernel update."
  else
      NEED_KERNEL_UPDATE=1
      echo "You need to Kernel Update."
fi
