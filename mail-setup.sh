#!/bin/bash

# update package list
sudo apt update

# install postfix
sudo apt install postfix -y

# install the telnet utility to check if it’s open or blocked.
sudo apt install telnet -y

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
echo -e '\x1dquit\x0d' | sleep 5 | telnet gmail-smtp-in.l.google.com 25 > temp.txt
CHECK_PORT_25=$(cat test.txt | grep "220 mx.google.com")
if [ "$CHECK_PORT_25" != "" ]; then 
    echo "Port 25... OK"
    send_test_email
else 
    echo "ERROR: Port 25 CLOSED!"
fi
rm temp.txt


# REFERENCE
# https://stackoverflow.com/a/54364978