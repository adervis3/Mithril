
Enable_Secure_high_quality_Password_Policy()
{
   echo '|Enable Secure (high quality) Password Policy'
   authconfig --passalgo=sha512 --update
}


cp /etc/login.defs /tmp/backup/




#Ensure password expiration is 90 days or less
sed 's/^PASS_MAX_DAYS.*/PASS_MAX_DAYS 90/' /etc/login.defs > /etc/login.defs.bac
mv /etc/login.defs.bac /etc/login.defs
echo "Ensure password expiration is 90 days or less" >> /tmp/report.txt
#Kontrol için chage --list <user>



#Ensure minimum days between password changes is 7 or more
sed 's/^PASS_MIN_DAYS.*/PASS_MIN_DAYS 7/' /etc/login.defs > /etc/login.defs.bac
mv /etc/login.defs.bac /etc/login.defs
echo "Ensure minimum days between password changes is 7 or more" >> report.txt


#Ensure password expiration warning days is 7 or more
sed 's/^PASS_WARN_AGE.*/PASS_WARN_AGE 3/' /etc/login.defs > /etc/login.defs.bac
mv /etc/login.defs.bac /etc/login.defs
echo "Ensure password expiration warning days is 7 or more" >> /tmp/report.txt
#Kontrol için chage --warndays 7 <user>

