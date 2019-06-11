rm -rf /lib/systemd/system/ctrl-alt-del.target
echo "Disable ctrl-alt-del" >> /tmp/report.txt


chown root:root /etc/passwd
chmod 644 /etc/passwd
echo "Ensure permissions on /etc/passwd are configured" >> /tmp/report.txt

chown root:root /etc/shadow
chmod 000 /etc/shadow
echo "Ensure permissions on /etc/shadow are configured" >> /tmp/report.txt

chown root:root /etc/group
chmod 644 /etc/group
echo "Ensure permissions on /etc/group are configured" >> /tmp/report.txt

chown root:root /etc/gshadow
chmod 000 /etc/gshadow
echo "Ensure permissions on /etc/gshadow are configured" >> /tmp/report.txt

chown root:root /etc/passwd-
chmod 600 /etc/passwd-
echo "Ensure permissions on /etc/passwd- are configured" >> /tmp/report.txt

chown root:root /etc/shadow-
chmod 600 /etc/shadow-
echo "Ensure permissions on /etc/shadow- are configured" >> /tmp/report.txt

chown root:root /etc/group-
chmod 600 /etc/group-
echo "Ensure permissions on /etc/group- are configured" >> /tmp/report.txt

chown root:root /etc/gshadow-
chmod 600 /etc/gshadow-
echo "Ensure permissions on /etc/gshadow- are configured" >> /tmp/report.txt




echo "" > /etc/issue
chown root:root /etc/issue
chmod 644 /etc/issue
echo "Ensure permissions on /etc/issue are configured" >> /tmp/report.txt

echo "" > /etc/issue.net
chown root:root /etc/issue.net
chmod 644 /etc/issue.net
echo "Ensure permissions on /etc/issue.net are configured" >> /tmp/report.txt

chown root:root /etc/motd
chmod 644 /etc/motd
echo "" > /etc/motd
echo "Ensure permissions on /etc/motd are configured" >> /tmp/report.txt


echo 'install usb-storage /bin/false' >> /etc/modprobe.d/disable-usb-storage.conf

echo "install firewire-core /bin/false" >> /etc/modprobe.d/firewire.conf
echo "install thunderbolt /bin/false" >> /etc/modprobe.d/thunderbolt.conf

