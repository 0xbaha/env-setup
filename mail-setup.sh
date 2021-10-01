#!/bin/bash


FILE_TEMP="temp.txt"


# ....
CURRENT_SERVER_HOSTNAME=$(hostname)
read -p "Email hostname (eg, mail.example.com) []: " EMAIL_HOSTNAME
read -p "Email domain (eg, example.com for user@xample.com) []: " EMAIL_DOMAIN

# update package list
sudo apt update

# install postfix
sudo apt install postfix -y

# install the telnet utility to check if it’s open or blocked.
sudo apt install telnet -y

# Replace server hostname with email hostname in Postfix config
TEMP_PRINT="Replace server hostname with email hostname in Postfix config"
printf "$TEMP_PRINT\n"

# Delete lines that contain a pattern of 'myhostname =' and 'mydestination ='
sudo sed -i '/myhostname =/d' /etc/postfix/main.cf
sudo sed -i '/mydestination =/d' /etc/postfix/main.cf

# Add new line with new values of 'myhostname' and 'mydestination'
echo "myhostname = ${EMAIL_HOSTNAME}" >> /etc/postfix/main.cf
echo "mydestination = \$myhostname, ${EMAIL_DOMAIN}, ${EMAIL_HOSTNAME}, localhost.${EMAIL_DOMAIN}, localhost" >> /etc/postfix/main.cf

sudo systemctl reload postfix

# Check Postfix version with this command:
TEMP_PRINT="Check Postfix version with this command:"
printf "$TEMP_PRINT\n"

postconf mail_version

# The ss (Socket Statistics) utility tells us that the Postfix master process is listening on TCP port 25.
TEMP_PRINT="The ss (Socket Statistics) utility tells us that the Postfix master process is listening on TCP port 25."
printf "$TEMP_PRINT\n"

sudo ss -lnpt | grep master 

# Postfix ships with many binaries under the /usr/sbin/ directory, as can be seen with the following command.
TEMP_PRINT="Postfix ships with many binaries under the /usr/sbin/ directory, as can be seen with the following command."
printf "$TEMP_PRINT\n"

dpkg -L postfix | grep /usr/sbin/ 

# Open TCP Port 25 (inbound) in Firewall
TEMP_PRINT="Open TCP Port 25 (inbound) in Firewall"
printf "$TEMP_PRINT\n"

sudo ufw allow 25/tcp 

# Sending Test Email
send_test_email() {

    TEMP_PRINT="Postfix sending test email"
    printf "$TEMP_PRINT\n"
    read -p "Receiver (eg, user@mail.com) []: " EMAIL_FOR_TEST_POSTFIX
    read -p "Message []: " MESSAGE_FOR_TEST_POSTFIX
    echo "$MESSAGE_FOR_TEST_POSTFIX" | sendmail $EMAIL_FOR_TEST_POSTFIX

}

# Run the following command on your mail server.
echo -e '\x1dquit\x0d' | sleep 5 | telnet gmail-smtp-in.l.google.com 25 > $FILE_TEMP
CHECK_PORT_25=$(cat $FILE_TEMP | grep "220 mx.google.com")
if [ "$CHECK_PORT_25" != "" ]; then 
    echo "Port 25... OK"
    send_test_email
else 
    echo "ERROR: Port 25 CLOSED!"
fi
rm $FILE_TEMP


# REFERENCE
# https://stackoverflow.com/a/54364978