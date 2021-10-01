#!/bin/bash


FILE_TEMP="temp.txt"
FILE_CONFIG_POSTFIX_MAIN="/etc/postfix/main.cf"
FILE_CONFIG_POSTFIX_MASTER="/etc/postfix/master.cf"
FILE_CONFIG_ALIASES="/etc/aliases"


# ....
CURRENT_SERVER_HOSTNAME=$(hostname)
read -p "Email hostname (eg, mail.example.com) []: " EMAIL_HOSTNAME
read -p "Email domain (eg, example.com) []: " EMAIL_DOMAIN
read -p "Email user alias (eg, admin) []: " EMAIL_USER_ALIAS

# update package list
sudo apt update

# install postfix
sudo apt install postfix -y

# install the telnet utility to check if it’s open or blocked.
sudo apt install telnet -y

# install mailutils to send and read email
sudo apt install mailutils -y

# Replace server hostname with email hostname in Postfix config
TEMP_PRINT="Replace server hostname with email hostname in Postfix config"
printf "$TEMP_PRINT\n"

# Delete lines that contain a pattern of 'myhostname =' and 'mydestination ='
sudo sed -i '/myhostname =/d' $FILE_CONFIG_POSTFIX_MAIN
sudo sed -i '/mydestination =/d' $FILE_CONFIG_POSTFIX_MAIN

# Add new line with new values of 'myhostname' and 'mydestination'
printf "myhostname = ${EMAIL_HOSTNAME}\n" | sudo tee -a $FILE_CONFIG_POSTFIX_MAIN
printf "mydestination = \$myhostname, ${EMAIL_DOMAIN}, ${EMAIL_HOSTNAME}, localhost.${EMAIL_DOMAIN}, localhost\n" | sudo tee -a $FILE_CONFIG_POSTFIX_MAIN

sudo systemctl reload postfix

# Check Postfix config after edit
cat $FILE_CONFIG_POSTFIX_MAIN | grep myhostname
cat $FILE_CONFIG_POSTFIX_MAIN | grep mydestination

# Add new line with new values of aliases
printf "root:\t${EMAIL_USER_ALIAS}\n" | sudo tee -a $FILE_CONFIG_ALIASES
sudo newaliases

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


# Configuring SPF Policy Agen to detecting forged incoming emails.
sudo apt install postfix-policyd-spf-python -y

# Edit the Postfix master process configuration file to start the SPF policy daemon when it’s starting itself.
TEMP_PRINT_1="policyd-spf  unix  -       n       n       -       0       spawn"
TEMP_PRINT_2="user=policyd-spf argv=/usr/bin/policyd-spf"
printf "\n$TEMP_PRINT_1\n  $TEMP_PRINT_2\n" | sudo tee -a $FILE_CONFIG_POSTFIX_MASTER

# Impose a restriction on incoming emails by rejecting unauthorized email and checking SPF record.
TEMP_PRINT_1="policyd-spf_time_limit = 3600"
TEMP_PRINT_2="smtpd_recipient_restrictions ="
TEMP_PRINT_3="permit_mynetworks,"
TEMP_PRINT_4="permit_sasl_authenticated,"
TEMP_PRINT_5="reject_unauth_destination,"
TEMP_PRINT_6="check_policy_service unix:private/policyd-spf"
printf "\n$TEMP_PRINT_1\n$TEMP_PRINT_2\n   $TEMP_PRINT_3\n   $TEMP_PRINT_4\n   $TEMP_PRINT_5\n   $TEMP_PRINT_6\n" | sudo tee -a $FILE_CONFIG_POSTFIX_MAIN
sudo systemctl restart postfix

# -------------------------------------------------------------------

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