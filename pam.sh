#Ensure password creation requirements are configured
#Strong Password
cp /etc/security/pwquality.conf /tmp/backup/
cp /etc/pam.d/password-auth /tmp/backup/
cp /etc/pam.d/system-auth /tmp/backup/





if [[ "$(grep "^minlen" /etc/security/pwquality.conf)" || "$(grep "^#.*minlen" /etc/security/pwquality.conf)" != "14" ]]; then
    sed 's/^#.*minlen.*/minlen 14/' /etc/security/pwquality.conf > /etc/security/pwquality.conf.bac
    sed 's/^minlen.*/minlen 14/' /etc/security/pwquality.conf.bac > /etc/security/pwquality.conf.bac2
    mv /etc/security/pwquality.conf.bac2 /etc/security/pwquality.conf
    rm /etc/security/pwquality.conf.bac
    echo "Password must be 14 characters or more" >> /tmp/report.txt
else
	echo "minlen 14" >> /etc/security/pwquality.conf
    echo "Password must be 14 characters or more" >> /tmp/report.txt
fi
#password must be 14 characters or more


if [[ "$(grep "^dcredit" /etc/security/pwquality.conf)" || "$(grep "^#.*dcredit" /etc/security/pwquality.conf)" != "-1" ]]; then
    sed 's/^#.*dcredit.*/dcredit -1/' /etc/security/pwquality.conf > /etc/security/pwquality.conf.bac
    sed 's/^dcredit.*/dcredit -1/' /etc/security/pwquality.conf.bac > /etc/security/pwquality.conf.bac2
    mv /etc/security/pwquality.conf.bac2 /etc/security/pwquality.conf
    rm /etc/security/pwquality.conf.bac
    echo "Provide at least one digit" >> /tmp/report.txt
else
	echo "dcredit -1" >> /etc/security/pwquality.conf
    echo "Provide at least one digit" >> /tmp/report.txt
fi
#provide at least one digit

if [[ "$(grep "^ucredit" /etc/security/pwquality.conf)" || "$(grep "^#.*ucredit" /etc/security/pwquality.conf)" != "-1" ]]; then
    sed 's/^#.*ucredit.*/ucredit -1/' /etc/security/pwquality.conf > /etc/security/pwquality.conf.bac
    sed 's/^ucredit.*/ucredit -1/' /etc/security/pwquality.conf.bac > /etc/security/pwquality.conf.bac2
    mv /etc/security/pwquality.conf.bac2 /etc/security/pwquality.conf
    rm /etc/security/pwquality.conf.bac
    echo "Provide at least one uppercase character" >> /tmp/report.txt
else
	echo "ucredit -1" >> /etc/security/pwquality.conf
    echo "Provide at least one uppercase character" >> /tmp/report.txt
fi
#provide at least one uppercase character

if [[ "$(grep "^ocredit" /etc/security/pwquality.conf)" || "$(grep "^#.*ocredit" /etc/security/pwquality.conf)" != "-1" ]]; then
    sed 's/^#.*ocredit.*/ocredit -1/' /etc/security/pwquality.conf > /etc/security/pwquality.conf.bac
    sed 's/^ocredit.*/ocredit -1/' /etc/security/pwquality.conf.bac > /etc/security/pwquality.conf.bac2
    mv /etc/security/pwquality.conf.bac2 /etc/security/pwquality.conf
    rm /etc/security/pwquality.conf.bac
    echo "Provide at least one special character" >> /tmp/report.txt
else
	echo "ocredit -1" >> /etc/security/pwquality.conf
    echo "Provide at least one special character" >> /tmp/report.txt
fi
#provide at least one special character

if [[ "$(grep "^lcredit" /etc/security/pwquality.conf)" || "$(grep "^#.*lcredit" /etc/security/pwquality.conf)" != "-1" ]]; then
    sed 's/^#.*lcredit.*/lcredit -1/' /etc/security/pwquality.conf > /etc/security/pwquality.conf.bac
    sed 's/^lcredit.*/lcredit -1/' /etc/security/pwquality.conf.bac > /etc/security/pwquality.conf.bac2
    mv /etc/security/pwquality.conf.bac2 /etc/security/pwquality.conf
    rm /etc/security/pwquality.conf.bac
    echo "Provide at least one lowercase character" >> /tmp/report.txt
else
	echo "lcredit -1" >> /etc/security/pwquality.conf
    echo "Provide at least one lowercase character" >> /tmp/report.txt
fi
#provide at least one lowercase character








#Ensure lockout for failed password attempts is configured
echo "auth required pam_faillock.so preauth audit silent deny=5 unlock_time=900" >> /etc/pam.d/password-auth
echo "auth required pam_faillock.so preauth audit silent deny=5 unlock_time=900" >> /etc/pam.d/system-auth

echo "auth [success=1 default=bad] pam_unix.so" >> /etc/pam.d/password-auth
echo "auth [success=1 default=bad] pam_unix.so" >> /etc/pam.d/system-auth

echo "auth [default=die] pam_faillock.so authfail audit deny=5 unlock_time=900" >> /etc/pam.d/password-auth
echo "auth [default=die] pam_faillock.so authfail audit deny=5 unlock_time=900" >> /etc/pam.d/system-auth

echo "auth sufficient pam_faillock.so authsucc audit deny=5 unlock_time=900" >> /etc/pam.d/password-auth
echo "auth sufficient pam_faillock.so authsucc audit deny=5 unlock_time=900" >> /etc/pam.d/system-auth

echo "Ensure lockout for failed password attempts is configured" >> /tmp/report.txt





#Ensure password reuse is limited

echo "password sufficient pam_unix.so remember=5" >> /etc/pam.d/password-auth
echo "password sufficient pam_unix.so remember=5" >> /etc/pam.d/system-auth
echo "Ensure password reuse is limited" >> /tmp/report.txt




#Ensure password hashing algorithm is SHA-512

echo "password sufficient pam_unix.so sha512" >> /etc/pam.d/password-auth
echo "password sufficient pam_unix.so sha512" >> /etc/pam.d/system-auth
echo "Ensure password hashing algorithm is SHA-512" >> /tmp/report.txt



