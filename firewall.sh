systemctl enable iptables
systemctl start iptables.service
echo "Enable iptables" >> /tmp/report.txt



read -p "
1-) Own local black list
2-) Own black list
3-) Using Mithril black list
Make your choose...: " choice
case "$choice" in
	1 ) 
    read -p "Show local black list file...: " list
	  grep -E -o "([0-9]{1,3}[\.]){3}[0-9]{1,3}" $list > BlackList2.txt
    echo $list
    echo "Your black list used" >> /tmp/report.txt;; 

  2 ) 
    read -p "Show black list file...: " list
    wget $list -O BlackList2.txt
  	grep -E -o "([0-9]{1,3}[\.]){3}[0-9]{1,3}" BlackList2.txt > BlackList.txt
  	rm BlackList2.txt
  	list=BlackList.txt
    echo "Your black list file used" >> /tmp/report.txt;;

	3 )  
    echo "Mithril using https://gist.githubusercontent.com/adervis3/c759a9f4cbf35be42728eee4aa1441ee/raw/eac2b6af55a1ef83255ef6dd8c304dad6a912f2f/test"
    wget https://gist.githubusercontent.com/adervis3/c759a9f4cbf35be42728eee4aa1441ee/raw/eac2b6af55a1ef83255ef6dd8c304dad6a912f2f/test -O BlackList2.txt
    grep -E -o "([0-9]{1,3}[\.]){3}[0-9]{1,3}" BlackList2.txt > BlackList.txt
    rm BlackList2.txt
    list=BlackList.txt
    echo "Using Mithril black list" >> /tmp/report.txt
  ;;
esac

for ip in `cat $list`
do
    iptables -A INPUT -s $ip -j DROP
    iptables -A OUTPUT -s $ip -j DROP
done






/sbin/sysctl -w net.ipv4.icmp_echo_ignore_broadcasts=1
/sbin/sysctl -w net.ipv4.icmp_echo_ignore_all=1
/sbin/sysctl -p
echo "Disable Ping" >> /tmp/report.txt


echo "install rds /bin/false"  > /etc/modprobe.d/rds.conf
echo "Disable uncommon protocols" >> /tmp/report.txt












Deny_All_TCP_Wrappers()
{
   cp /etc/hosts.deny /tmp/backup/
   cp /etc/hosts.allow /tmp/backup/
   echo "ALL:ALL:twist /bin/echo What are you doing %a!"  >> /etc/hosts.deny

   echo "sshd:ALL:spawn /bin/echo Date: `/bin/date` IP: %c To Server: %s PID: %p >> /var/log/sshd_auth.log" >> /etc/hosts.allow
   chmod 644 /etc/hosts.deny
   chmod 644 /etc/hosts.allow
}


Disable_Uncommon_Protocols()
{
   cp /etc/modprobe.d/dccp.conf /tmp/backup/
   cp /etc/modprobe.d/sctp.conf /tmp/backup/
   cp /etc/modprobe.d/rds.conf /tmp/backup/
   cp /etc/modprobe.d/tipc.conf /tmp/backup/
   echo "install dccp /bin/false" > /etc/modprobe.d/dccp.conf
   echo "install sctp /bin/false" > /etc/modprobe.d/sctp.conf
   echo "install rds /bin/false"  > /etc/modprobe.d/rds.conf
   echo "install tipc /bin/false" > /etc/modprobe.d/tipc.conf
}







Disable_IPv6()
{
  /sbin/sysctl -w net.ipv6.conf.all.disable_ipv6 = 1
  /sbin/sysctl -w net.ipv6.conf.default.disable_ipv6 = 1
  /sbin/sysctl -w net.ipv6.conf.lo.disable_ipv6 = 1
  /sbin/sysctl -p
}

Ensure_IPv6_Router_Advertisements_Disable()
{
  /sbin/sysctl -w net.ipv6.conf.all.accept_ra=0
  /sbin/sysctl -w net.ipv6.conf.default.accept_ra=0
  /sbin/sysctl -p
}

Disable_IPv6_Redirect()
{
  /sbin/sysctl -w net.ipv6.conf.all.accept_redirects=0
  /sbin/sysctl -w net.ipv6.conf.default.accept_redirects=0
  /sbin/sysctl -p
}



Disable_Ping_Response()
{
  /sbin/sysctl -w net.ipv4.icmp_echo_ignore_broadcasts=1
  /sbin/sysctl -w net.ipv4.icmp_echo_ignore_all=1
  /sbin/sysctl -p
}



Disable_IP_Forward()
{
  /sbin/sysctl -w net.ipv4.ip_forward = 0
  /sbin/sysctl -p
}

ICMP_Redirect_Disable()
{
   /sbin/sysctl -w net.ipv4.conf.all.send_redirects = 0
   /sbin/sysctl -w net.ipv4.conf.default.send_redirects = 0
   /sbin/sysctl -p
}

Disable_ICMP_Package()
{
   /sbin/sysctl -w net.ipv4.conf.all.accept_redirects = 0
   /sbin/sysctl -w net.ipv4.conf.default.accept_redirects = 0
   /sbin/sysctl -p  
}

Disable_Secure_ICMP_Package()
{  
   /sbin/sysctl -w net.ipv4.conf.all.secure_redirects = 0
   /sbin/sysctl -w net.ipv4.conf.default.secure_redirects = 0
   /sbin/sysctl -p
}

Ignored_Broadcast_ICMP_Package()
{
   /sbin/sysctl -w net.ipv4.icmp_echo_ignore_broadcasts = 1
   /sbin/sysctl -p
}

Ignored_Bogus_ICMP_Package()
{
   /sbin/sysctl -w net.ipv4.icmp_ignore_bogus_error_responses = 1
   /sbin/sysctl -p
}

Disable_Routed_Package()
{
   /sbin/sysctl -w net.ipv4.conf.all.accept_source_route = 0
   /sbin/sysctl -w net.ipv4.conf.default.accept_source_route = 0
   /sbin/sysctl -p
}

Sucpicious_Package_Logged()
{
   /sbin/sysctl -w net.ipv4.conf.all.log_martians = 1
   /sbin/sysctl -w net.ipv4.conf.default.log_martians = 1
   /sbin/sysctl -p
}


Reverse_Path_Filtering()
{
   /sbin/sysctl -w net.ipv4.conf.all.rp_filter = 1
   /sbin/sysctl -w net.ipv4.conf.default.rp_filter = 1
   /sbin/sysctl -p
}

Enabled_TCPSYN_Cookie()
{
   /sbin/sysctl -w net.ipv4.tcp_syncookies = 1
   /sbin/sysctl -p  
}






