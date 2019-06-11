if [[ "$(systemctl is-enabled crond)" != "enabled" ]]; then
    systemctl enable crond
    echo "cron enabled" >> /tmp/report.txt
fi



chown root:root /etc/crontab
chmod og-rwx /etc/crontab
echo "Ensure permissions on /etc/crontab are configured" >> /tmp/report.txt



chown root:root /etc/cron.*
chmod og-rwx /etc/cron.*
echo "Ensure permissions on /etc/cron.* are configured" >> /tmp/report.txt



rm /etc/cron.deny
rm /etc/at.deny
touch /etc/cron.allow
touch /etc/at.allow
chmod og-rwx /etc/cron.allow
chmod og-rwx /etc/at.allow
chown root:root /etc/cron.allow
chown root:root /etc/at.allow
echo "Ensure at/cron is restricted to authorized users" >> /tmp/report.txt


awk -F: '{print $1}' /etc/passwd | grep -v root > /etc/cron.deny



