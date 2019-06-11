#!/bin/bash

source $(dirname "$0")/*.sh

mkdir /tmp/backup
touch /tmp/report.txt

read -p "1-) Enumeration
2-) Hardening
3-) System Report
4-) Exit
Make your choose...: " choice
case "$choice" in
	1 ) cho=1;;
	2 ) cho=2;;
	3 ) cho=3;;
	4 ) exit;;
esac

. Enumeration.sh

if [ "$cho" = 2 ];  then

	while true
	do
	clear
	echo "1. boot
2. cron
3. firewall
4. general
5. logging
6. user hardening
7. root hardening
8. services
9. ssh
10. update
11. users
99. Exit"

	printf '%*s\n' "${COLUMNS:-$(tput cols)}" '' | tr ' ' '#'

	read -p "Make your choose...:" choice
	case "$choice" in
		1 ) . boot.sh;;
		2 ) . cron.sh;;
		3 ) . firewall.sh;;
		4 ) . general.sh;;
		5 ) . logging.sh;;
		6 ) . pam.sh;;
		7 ) . root.sh;;
		8 ) . services.sh;;
		9 ) . ssh.sh;;
		10 ) . update.sh;;
		11) . users.sh;;
		99)	exit;;
	esac
	done

fi


