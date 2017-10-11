#!/bin/bash

#if [ "$EUID" -ne 0 ]
#  then echo "Please run as root!!!"
#  exit
#fi
#Whether you have root privilege was checked above


. OSDetect.sh


while true
do
clear
echo "1. update
2. services
3. root security
4. 
5. 
6. 
7. 
8. 
9. 
19. 
20. Tips
21. Exit"

printf '%*s\n' "${COLUMNS:-$(tput cols)}" '' | tr ' ' '#' 

read -p "Make your choose...:" choice
case "$choice" in
	1 ) . update.sh;;
	2 ) . services.sh;;
	3 ) . root.sh;;	
	19) echo "Good Bye!!!";;
	20) less Tips.txt;;
	21)	exit;;	
esac
	

done



#Servis kapatma komutu yaz buraya

