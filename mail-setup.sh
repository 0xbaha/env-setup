#!/bin/bash


FILE_TEMP="temp.txt"
FILE_CONFIG_POSTFIX_MAIN="/etc/postfix/main.cf"
FILE_CONFIG_POSTFIX_MASTER="/etc/postfix/master.cf"
FILE_CONFIG_ALIASES="/etc/aliases"
FILE_CONFIG_OPENDKIM="/etc/opendkim.conf"
FILE_CONFIG_OPENDKIM_SIGNINGTABLE="/etc/opendkim/signing.table"
FILE_CONFIG_OPENDKIM_KEYTABLE="/etc/opendkim/key.table"
FILE_CONFIG_OPENDKIM_TRUSTEDHOSTS="/etc/opendkim/trusted.hosts"
FILE_CONFIG_OPENDKIM_DEFAULT="/etc/default/opendkim"

# Check if user want to continue the process
ask_continue_process() {

    TEMP_PRINT="Continue process? [Y/n] "
    read -p "$TEMP_PRINT" USER_OPTION_CONTINUE_PROCESS

    if [ "$USER_OPTION_CONTINUE_PROCESS" == "n" ] || [ "$USER_OPTION_CONTINUE_PROCESS" == "N" ]; then

        TEMP_PRINT="Process aborted"
        printf "${RED}${TEMP_PRINT}...${NC}\n"

        exit

    fi

}


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

# Setting up DKIM
# First, install OpenDKIM which is an open-source implementation of the DKIM sender authentication system.
sudo apt install opendkim opendkim-tools -y

# Then add postfix user to opendkim group.
sudo gpasswd -a postfix opendkim 

# Edit OpenDKIM main configuration file.
sudo sed -i "s/#Canonicalization\tsimple/Canonicalization\tsimple/g" $FILE_CONFIG_OPENDKIM
sudo sed -i "s/#Mode\t\t\tsv/Mode\t\t\tsv/g" $FILE_CONFIG_OPENDKIM
sudo sed -i "s/#SubDomains\t\tno/SubDomains\t\tno/g" $FILE_CONFIG_OPENDKIM

TEMP_PRINT_1="AutoRestart         yes"
TEMP_PRINT_2="AutoRestartRate     10/1M"
TEMP_PRINT_3="Background          yes"
TEMP_PRINT_4="DNSTimeout          5"
TEMP_PRINT_5="SignatureAlgorithm  rsa-sha256 "
printf "\n$TEMP_PRINT_1\n$TEMP_PRINT_2\n$TEMP_PRINT_3\n$TEMP_PRINT_4\n$TEMP_PRINT_5\n" | sudo tee -a $FILE_CONFIG_OPENDKIM

TEMP_PRINT_1="# Map domains in From addresses to keys used to sign messages"
TEMP_PRINT_2="KeyTable           refile:$FILE_CONFIG_OPENDKIM_KEYTABLE"
TEMP_PRINT_3="SigningTable       refile:$FILE_CONFIG_OPENDKIM_SIGNINGTABLE"
TEMP_PRINT_4="# Hosts to ignore when verifying signatures"
TEMP_PRINT_5="ExternalIgnoreList  $FILE_CONFIG_OPENDKIM_TRUSTEDHOSTS"
TEMP_PRINT_6="# A set of internal hosts whose mail should be signed"
TEMP_PRINT_7="InternalHosts       $FILE_CONFIG_OPENDKIM_TRUSTEDHOSTS "
printf "\n$TEMP_PRINT_1\n$TEMP_PRINT_2\n$TEMP_PRINT_3\n\n$TEMP_PRINT_4\n$TEMP_PRINT_5\n\n$TEMP_PRINT_6\n$TEMP_PRINT_7\n" | sudo tee -a $FILE_CONFIG_OPENDKIM

# -------------------------------------------------------------------

# Create a directory structure for OpenDKIM
sudo mkdir /etc/opendkim
sudo mkdir /etc/opendkim/keys

# Change the owner from root to opendkim and make sure only opendkim user can read and write to the keys directory.
sudo chown -R opendkim:opendkim /etc/opendkim
sudo chmod go-rw /etc/opendkim/keys 


sudo touch $FILE_CONFIG_OPENDKIM_SIGNINGTABLE

TEMP_PRINT="*@${EMAIL_DOMAIN}    default._domainkey.${EMAIL_DOMAIN}"
printf "\n$TEMP_PRINT\n" | sudo tee -a $FILE_CONFIG_OPENDKIM_SIGNINGTABLE

sudo touch $FILE_CONFIG_OPENDKIM_KEYTABLE

TEMP_PRINT="default._domainkey.${EMAIL_DOMAIN}    ${EMAIL_DOMAIN}:default:/etc/opendkim/keys/${EMAIL_DOMAIN}/default.private"
printf "\n$TEMP_PRINT\n" | sudo tee -a $FILE_CONFIG_OPENDKIM_KEYTABLE

sudo touch $FILE_CONFIG_OPENDKIM_TRUSTEDHOSTS

TEMP_PRINT_1="#127.0.0.1"
TEMP_PRINT_2="localhost"
TEMP_PRINT_3="*.${EMAIL_DOMAIN}"
printf "\n$TEMP_PRINT_1\n$TEMP_PRINT_2\n\n$TEMP_PRINT_3\n" | sudo tee -a $FILE_CONFIG_OPENDKIM_TRUSTEDHOSTS

# -------------------------------------------------------------------

# Create a separate folder for the domain.
sudo mkdir /etc/opendkim/keys/$EMAIL_DOMAIN 
# Generate keys using opendkim-genkey tool.
sudo opendkim-genkey -b 2048 -d $EMAIL_DOMAIN -D /etc/opendkim/keys/$EMAIL_DOMAIN -s default -v
# Make opendkim as the owner of the private key.
sudo chown opendkim:opendkim /etc/opendkim/keys/$EMAIL_DOMAIN/default.private 
# And change the permission, so only the opendkim user has read and write access to the file.
sudo chmod 600 /etc/opendkim/keys/$EMAIL_DOMAIN/default.private 

# Publish Your Public Key in DNS Records
# Display the public key
sudo cat /etc/opendkim/keys/$EMAIL_DOMAIN/default.txt

# -------------------------------------------------------------------

# Check if user want to continue the process
ask_continue_process

# -------------------------------------------------------------------

# Test DKIM Key
# Enter the following command on Ubuntu server to test your key.
sudo opendkim-testkey -d $EMAIL_DOMAIN -s default -vvv

# -------------------------------------------------------------------

# Create a directory to hold the OpenDKIM socket file and allow only opendkim user and postfix group to access it.
sudo mkdir /var/spool/postfix/opendkim
sudo chown opendkim:postfix /var/spool/postfix/opendkim

# Then edit the OpenDKIM main configuration file.
sudo sed -i "s/local:\/run\/opendkim\/opendkim.sock/local:\/var\/spool\/postfix\/opendkim\/opendkim.sock/g" $FILE_CONFIG_OPENDKIM
sudo sed -i "s/SOCKET=local:\$RUNDIR\/opendkim.sock/SOCKET=\"local:\/var\/spool\/postfix\/opendkim\/opendkim.sock\"/g" $FILE_CONFIG_OPENDKIM_DEFAULT

TEMP_PRINT_1="# Milter configuration"
TEMP_PRINT_2="milter_default_action = accept"
TEMP_PRINT_3="milter_protocol = 6"
TEMP_PRINT_4="smtpd_milters = local:opendkim/opendkim.sock"
TEMP_PRINT_5="non_smtpd_milters = \$smtpd_milters"
printf "\n$TEMP_PRINT_1\n$TEMP_PRINT_2\n$TEMP_PRINT_3\n$TEMP_PRINT_4\n$TEMP_PRINT_5\n" | sudo tee -a $FILE_CONFIG_POSTFIX_MAIN

sudo systemctl restart opendkim postfix

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