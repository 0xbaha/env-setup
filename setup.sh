#!/bin/bash

############################# VARIABLES #############################

# BASH

# Bash Color
RED='\033[1;31m'        # Light Red
GREEN='\033[1;32m'      # Light Green
YELLOW='\033[1;33m'     # Yellow
PURPLE='\033[1;35m'     # Light Purple
CYAN='\033[1;36m'       # Light Cyan
NC='\033[0m'            # No Color

# Bash Text Style
BOLD=$(tput bold)       # Bold text
NORMAL=$(tput sgr0)     # Normal text

# ----------------------------------------------------------------- #

# LINUX

TIMEZONE="Asia/Jakarta"
NEW_USERNAME=""
DNS_NAMESERVER="208.67.222.222"

# ----------------------------------------------------------------- #

# EMAIL SETUP

FILE_TEMP="temp.txt"
FILE_CONFIG_POSTFIX_MAIN="/etc/postfix/main.cf"
FILE_CONFIG_POSTFIX_MASTER="/etc/postfix/master.cf"
FILE_CONFIG_ALIASES="/etc/aliases"
FILE_CONFIG_OPENDKIM="/etc/opendkim.conf"
FILE_CONFIG_OPENDKIM_SIGNINGTABLE="/etc/opendkim/signing.table"
FILE_CONFIG_OPENDKIM_KEYTABLE="/etc/opendkim/key.table"
FILE_CONFIG_OPENDKIM_TRUSTEDHOSTS="/etc/opendkim/trusted.hosts"
FILE_CONFIG_OPENDKIM_DEFAULT="/etc/default/opendkim"

# ----------------------------------------------------------------- # 

# OTHERS

FILE_SETUP="setup.sh"
FILE_TMP="_tmp.txt"

ARG_CLOUD="cloud"
ARG_DESKTOP="desktop"
ARG_DO="do"
ARG_SERVER="server"
ARG_VBOX="vbox"

DEFAULT_NEW_SSH_PORT="11122"

################################ MAIN ###############################

main() {

    # ./setup.sh

    if [ "$0" == "./$FILE_SETUP" ] && [ "$1" == "" ]; then 

        check_sudo_user
        if [ "$IS_SUDO_USER" = true ]; then ask_user_option; fi
    
    
    # If the command is not valid, an error message will be shown

    else

        TEMP_PRINT="ERROR: Command is not valid"
        printf "${RED}${TEMP_PRINT}...${NC}\n"
        
        exit

    fi

}

############################## FUNCTIONS ############################

# ============================== START ==============================

# Check if User is in sudo mode
check_sudo_user() {
    
    if [ `whoami` != root ]; then
    
        TEMP_PRINT="ERROR: Please run this script as root or using sudo"
        printf "${RED}${TEMP_PRINT}...${NC}\n"
        
        exit

    else
    
        IS_SUDO_USER=true
        
    fi

}


# Ask the user option
ask_user_option() {

    ask_user() {

        TEMP_PRINT_A="${CYAN}Which options do you need?${NC}\n"
        TEMP_PRINT_1="  1. VirtualBox (Desktop)\n"
        TEMP_PRINT_2="  2. VirtualBox (Server)\n"
        TEMP_PRINT_3="  3. Cloud (DigitalOcean/Hostwinds)\n"
        TEMP_PRINT_4="  4. Bare-metal (physical server)\n"
        TEMP_PRINT_5="  5. Email Server (${RED}required${NC} to set up ${YELLOW}at least${NC} 1 of option 1-4)\n"
        printf "$TEMP_PRINT_A"
        printf "$TEMP_PRINT_1"
        printf "$TEMP_PRINT_2"
        printf "$TEMP_PRINT_3"
        printf "$TEMP_PRINT_4"
        printf "$TEMP_PRINT_5"

        TEMP_PRINT="Option: "
        read -p "$TEMP_PRINT" USER_OPTION

        if [ "$USER_OPTION" == "1" ]; then

            setup_vbox_desktop

        elif [ "$USER_OPTION" == "2" ]; then

            setup_vbox_server

        elif [ "$USER_OPTION" == "3" ]; then

            setup_cloud_digitalocean

        elif [ "$USER_OPTION" == "4" ]; then

            setup_physical_server

        elif [ "$USER_OPTION" == "5" ]; then

            setup_email_server

        else

            TEMP_PRINT="ERROR: Wrong option"
            printf "${RED}${TEMP_PRINT}...${NC}\n"

        fi

    }

    ask_user

    ARR_OPTIONS=(1 2 3 4 5)

    while ! [[ ${ARR_OPTIONS[*]} =~ (^|[[:space:]])"$USER_OPTION"($|[[:space:]]) ]]; do
        ask_user
    done

}


# -------------------------------------------------------------------

# Setup for VBox (desktop)
setup_vbox_desktop() {

    TEMP_PRINT="Setup for VBox (desktop)"
    printf "${YELLOW}${TEMP_PRINT}...${NC}\n"

    # Init Setup
    basic_setup

    # Install Required Apps
    install_dev_tools
    install_other_apps
    
    # End Setup
    end_setup

}


# Setup for VBox (server)
setup_vbox_server() {

    TEMP_PRINT="Setup for VBox (server)"
    printf "${YELLOW}${TEMP_PRINT}...${NC}\n"

    # Init Setup
    basic_setup

    # Install Required Apps
    install_other_apps

    # End Setup
    end_setup

}


# Setup for DigitalOcean
setup_cloud_digitalocean() {

    TEMP_PRINT="Setup for server"
    printf "${YELLOW}${TEMP_PRINT}...${NC}\n"

    # Init Setup
    create_user
    ssh_settings
    basic_setup

    # Install Required Apps
    install_other_apps

    # End Setup
    end_setup

}


# Setup for physical server
setup_physical_server() {

    TEMP_PRINT="Setup for physical server"
    printf "${YELLOW}${TEMP_PRINT}...${NC}\n"

    # Init Setup
    ssh_settings
    basic_setup

    # Install Required Apps
    install_other_apps

    # End Setup
    end_setup

}


# =========================== INIT SETUP ============================

# Create User
create_user() {

    # Check if User want to create new sudo user
    ask_create_sudo_user() {

        TEMP_PRINT="Create new sudo user? [Y/n] "
        read -p "$TEMP_PRINT" user_option_create_user

        if [ "$user_option_create_user" == "n" ] || [ "$user_option_create_user" == "N" ]; then

            TEMP_PRINT="Sudo user will NOT be created"
            printf "${RED}${TEMP_PRINT}...${NC}\n"

            is_create_sudo_user=false

        else

            TEMP_PRINT="Sudo user WILL be created"
            printf "${GREEN}${TEMP_PRINT}...${NC}\n"
            
            is_create_sudo_user=true

        fi

    }

    # Check if user exist
    check_user_exist() {

        id -u "$NEW_USERNAME" &> $FILE_TMP
        temp1=$(cat $FILE_TMP | grep id)

        if [ "$temp1" == "" ]; then

            temp="User \"$NEW_USERNAME\" is exist"
            printf "${RED}${temp}!${NC}\n"

            IS_USER_EXIST=true  
            
        else

            IS_USER_EXIST=false
            IS_CONTINUE_CREATE_USER=false
            
        fi

        rm $FILE_TMP

    }

    # Create sudo user
    create_sudo_user() {

        temp="Create sudo user"
        printf "${CYAN}${temp}:${NC}\n"

        IS_CONTINUE_CREATE_USER=true

        while [ $IS_CONTINUE_CREATE_USER = true ] || [ $IS_USER_EXIST = true ]; do

            # Check new username
            read -p "Enter username: " NEW_USERNAME

            # Check if user exist
            check_user_exist

        done

        # Create the user
        sudo adduser $NEW_USERNAME
        
        # Add to sudo group
        sudo usermod -aG sudo $NEW_USERNAME

    }

    ask_create_sudo_user

    if [ "$is_create_sudo_user" = true ]; then

        # Create sudo user
        create_sudo_user

        # Copy SSH authorized keys
        copy_ssh_authorized_keys

    fi

}


# SSH settings
ssh_settings() {

    TEMP_PRINT="SSH settings"
    printf "${CYAN}${TEMP_PRINT}:${NC}\n"

    TEMP_PRINT="Edit SSH settings? [Y/n] "
    read -p "$TEMP_PRINT" USER_OPTION_SSH_SETTINGS

    if [ "$USER_OPTION_SSH_SETTINGS" == "n" ] || [ "$USER_OPTION_SSH_SETTINGS" == "N" ]; then

        TEMP_PRINT="SSH settings will NOT be edited"
        printf "${PURPLE}${TEMP_PRINT}...${NC}\n"

    else

        # Change the SSH Port
        change_ssh_port

        # Disable password authentication on SSH
        disable_ssh_password_auth

        # Disable root login on SSH
        disable_ssh_root_login

        # Check if user want to continue the process
        ask_continue_process

    fi

}


# Basic Setup 
basic_setup() {

    # Set timezone
    set_timezone

    # Update/upgrade packages
    update_and_upgrade

}


# -------------------------------------------------------------------

# Copy SSH authorized keys
copy_ssh_authorized_keys() {

    # Check if SSH authorized keys exist
    check_ssh_authorized_keys_exist() {

        TEMP_COMMAND=$(cat ~/.ssh/authorized_keys)

        if [ "$TEMP_COMMAND" != "" ]; then

            TEMP_PRINT="authorized_keys is exist"
            printf "${GREEN}${TEMP_PRINT}...${NC}\n"

            IS_AUTHORIZED_KEYS_EXIST=true

        else

            TEMP_PRINT="ERROR: authorized_keys is NOT available"
            printf "${RED}${TEMP_PRINT}...${NC}\n"

            IS_AUTHORIZED_KEYS_EXIST=false

            fi
            
    }

    TEMP_PRINT_A="Copy SSH authorized keys"
    printf "${CYAN}${TEMP_PRINT_A}:${NC}\n"

    check_ssh_authorized_keys_exist

    while [ $IS_AUTHORIZED_KEYS_EXIST = false ]; do

        # Check if user want to continue the process
        ask_continue_process

        # Check if SSH authorized keys exist
        check_ssh_authorized_keys_exist

    done

    mkdir /home/$NEW_USERNAME/.ssh
    cp /root/.ssh/authorized_keys /home/$NEW_USERNAME/.ssh/
    chown -R $NEW_USERNAME:$NEW_USERNAME /home/$NEW_USERNAME/.ssh/

    printf "${TEMP_PRINT_A}...${NC} ${GREEN}OK${NC}\n"

}


# Set timezone
set_timezone() {

    TEMP_PRINT="Set timezone"
    printf "${CYAN}${TEMP_PRINT}:${NC}\n"
    
    timedatectl set-timezone $TIMEZONE

    printf "${TEMP_PRINT}...${NC} ${GREEN}OK${NC}\n"

}


# Update and upgrade the packages 
update_and_upgrade() {

    TEMP_PRINT="Update and upgrade the packages"
    printf "${CYAN}${TEMP_PRINT}:${NC}\n"

    # Update the package lists that need upgrading
    TEMP_PRINT="Update the package lists that need upgrading"
    printf "${PURPLE}${TEMP_PRINT}...${NC}\n"

    sudo apt update

    # Upgrade packages and its dependencies
    TEMP_PRINT="Upgrade packages and its dependencies"
    printf "${PURPLE}${TEMP_PRINT}...${NC}\n"

    sudo apt dist-upgrade -y

}


# -------------------------------------------------------------------

# SSH

# Change the SSH Port
change_ssh_port() {

    # Ask if user want to change the SSH port
    ask_ssh_port() {

        TEMP_PRINT="Change SSH default port? [Y/n] "
        read -p "$TEMP_PRINT" USER_OPTION_SSH_PORT

        if [ "$USER_OPTION_SSH_PORT" == "n" ] || [ "$USER_OPTION_SSH_PORT" == "N" ]; then

            TEMP_PRINT="SSH port will NOT be changed"
            printf "${PURPLE}${TEMP_PRINT}...${NC}\n"

            is_change_ssh_port=false

        else

            TEMP_PRINT="SSH port WILL be changed"
            printf "${PURPLE}${TEMP_PRINT}...${NC}\n"
            
            is_change_ssh_port=true

        fi

    }

    ask_ssh_port

    if [ "$is_change_ssh_port" == true ]; then

        read -p "Enter the new port [$DEFAULT_NEW_SSH_PORT] " USER_INPUT_NEW_SSH_PORT

        TEMP_MESSAGE="Using default value"
        TEMP_PRINT="${PURPLE}${TEMP_MESSAGE}...${NC}\n"

        if [ "$USER_INPUT_NEW_SSH_PORT" == "" ]; then
            printf "$TEMP_PRINT"
            USER_INPUT_NEW_SSH_PORT="$DEFAULT_NEW_SSH_PORT"
        fi
    
        # Change the default value
        TEMP_PRINT="Change the default value"
        printf "${PURPLE}${TEMP_PRINT}...${NC}\n"

        sudo sed -i "s/#Port 22/Port $USER_INPUT_NEW_SSH_PORT/g" /etc/ssh/sshd_config
        sudo systemctl restart ssh
    
        # Allow the new port in firewall
        TEMP_PRINT="Allow the new port in firewall"
        printf "${PURPLE}${TEMP_PRINT}...${NC}\n"

        sudo ufw allow $USER_INPUT_NEW_SSH_PORT/tcp
    
    fi

}


# Disable password authentication on SSH
disable_ssh_password_auth() {

    # Ask if user want to disable password authentication on SSH
    ask_disable_ssh_password_auth() {

        TEMP_PRINT="Disable password authentication on SSH? [Y/n] "
        read -p "$TEMP_PRINT" USER_OPTION_SSH_PASSWORD_AUTH

        if [ "$USER_OPTION_SSH_PASSWORD_AUTH" == "n" ] || [ "$USER_OPTION_SSH_PASSWORD_AUTH" == "N" ]; then

            TEMP_PRINT="Password authentication on SSH will NOT be disabled"
            printf "${PURPLE}${TEMP_PRINT}...${NC}\n"

            is_disable_ssh_password_auth=false

        else

            TEMP_PRINT="Password authentication on SSH will be DISABLED"
            printf "${PURPLE}${TEMP_PRINT}...${NC}\n"
            
            is_disable_ssh_password_auth=true

        fi

    }

    # Ask if user already copy the Public Key to Authorized Keys
    ask_copy_publickey_to_authorizedkey() {

        TEMP_PRINT="Already copy the Public Key to Authorized Keys? [y/N] "
        read -p "$TEMP_PRINT" USER_OPTION_COPY_PUBLICKEY

        if [ "$USER_OPTION_COPY_PUBLICKEY" == "y" ] || [ "$USER_OPTION_COPY_PUBLICKEY" == "Y" ]; then

            is_continue_disable_ssh_password_auth=true

        else

            TEMP_PRINT="Please copy the Public Key to Authorized Keys"
            printf "${RED}${TEMP_PRINT}...${NC}\n"

            exit

        fi

    }

    ask_disable_ssh_password_auth

    if [ "$is_disable_ssh_password_auth" == true ]; then ask_copy_publickey_to_authorizedkey; fi

    if [ "$is_disable_ssh_password_auth" == true ] && [ "$is_continue_disable_ssh_password_auth" == true ]; then
    
        # Change the default value
        sudo sed -i "s/PasswordAuthentication yes/PasswordAuthentication no/g" /etc/ssh/sshd_config
        sudo systemctl restart ssh

    fi

}


# Disable root login on SSH
disable_ssh_root_login() {

    # Ask if user want to disable root login on SSH
    ask_disable_ssh_root_login() {

        TEMP_PRINT="Disable root login on SSH? [Y/n] "
        read -p "$TEMP_PRINT" USER_OPTION_SSH_ROOT_LOGIN

        if [ "$USER_OPTION_SSH_ROOT_LOGIN" == "n" ] || [ "$USER_OPTION_SSH_ROOT_LOGIN" == "N" ]; then

            TEMP_PRINT="Root login on SSH will NOT be disabled"
            printf "${PURPLE}${TEMP_PRINT}...${NC}\n"

            is_disable_ssh_root_login=false

        else

            TEMP_PRINT="Root login on SSH will be DISABLED"
            printf "${PURPLE}${TEMP_PRINT}...${NC}\n"
            
            is_disable_ssh_root_login=true

        fi
        
    }

    ask_disable_ssh_root_login

    if [ "$is_disable_ssh_root_login" == true ]; then
    
        # Change the default value
        sudo sed -i "s/PermitRootLogin yes/PermitRootLogin no/g" /etc/ssh/sshd_config
        sudo sed -i "s/#PermitRootLogin prohibit-password/PermitRootLogin no/g" /etc/ssh/sshd_config
        sudo systemctl restart ssh

    fi

}


# ============================ DEV-TOOLS =============================

# Install developing apps
install_dev_tools() {

    # Essential
    install_vscode            # Install Visual Studio Code
    install_sqlitebrowser     # Install SQLite Browser
    install_mysqlworkbench    # Install MySQL Workbench
    install_postman           # Install Postman

    # Additional
    install_filezilla         # Install FileZilla
    install_tree              # Install tree
    install_rename            # Install rename
    install_imagemagick       # Install Imagemagick

}


# -------------------------------------------------------------------

# Install Visual Studio Code
install_vscode() {

    TEMP_PRINT="Install Visual Studio Code"
    printf "${CYAN}${TEMP_PRINT}:${NC}\n"

    # Install the dependencies
    TEMP_PRINT="Install the dependencies"
    printf "${PURPLE}${TEMP_PRINT}...${NC}\n"

    sudo apt install software-properties-common apt-transport-https wget -y
    
    # Import the Microsoft GPG key
    TEMP_PRINT="Import the Microsoft GPG key"
    printf "${PURPLE}${TEMP_PRINT}...${NC}\n"

    wget -q https://packages.microsoft.com/keys/microsoft.asc -O- | sudo apt-key add -
    
    # Enable the repository and update the package index
    TEMP_PRINT="Enable the repository and update the package index"
    printf "${PURPLE}${TEMP_PRINT}...${NC}\n"

    sudo add-apt-repository "deb [arch=amd64] https://packages.microsoft.com/repos/vscode stable main"
    sudo apt update

    # Install the package
    TEMP_PRINT="Install the package"
    printf "${PURPLE}${TEMP_PRINT}...${NC}\n"

    sudo apt install code -y

}


# Install SQLite Browser
install_sqlitebrowser() {

    # https://sqlitebrowser.org/dl/

    TEMP_PRINT="Install SQLite Browser"
    printf "${CYAN}${TEMP_PRINT}:${NC}\n"

    sudo apt install sqlitebrowser -y
 
}


# Install MySQL Workbench
install_mysqlworkbench() {

    TEMP_PRINT="Install MySQL Workbench"
    printf "${CYAN}${TEMP_PRINT}:${NC}\n"

    # Install the dependencies of MySQL Workbench
    TEMP_PRINT="Install the dependencies of MySQL Workbench"
    printf "${PURPLE}${TEMP_PRINT}...${NC}\n"

    sudo apt install libopengl0 libpcrecpp0v5 libproj15 libzip5 -y
    
    # Download the installer
    TEMP_PRINT="Download the installer"
    printf "${PURPLE}${TEMP_PRINT}...${NC}\n"

    wget https://dev.mysql.com/get/Downloads/MySQLGUITools/mysql-workbench-community_8.0.26-1ubuntu20.04_amd64.deb
    
    # Install the MySQL Workbench
    TEMP_PRINT="Install the MySQL Workbench"
    printf "${PURPLE}${TEMP_PRINT}...${NC}\n"

    sudo dpkg -i mysql-*
    
    # Remove the installer after installation finish
    TEMP_PRINT="Remove the installer after installation finish"
    printf "${PURPLE}${TEMP_PRINT}...${NC}\n"

    rm mysql-*

}


# Install Postman
install_postman() {

    # https://speedysense.com/install-postman-on-ubuntu-20-04/

    TEMP_PRINT="Install Postman"
    printf "${CYAN}${TEMP_PRINT}:${NC}\n"

    # Download Postman installer
    TEMP_PRINT="Download Postman installer"
    printf "${PURPLE}${TEMP_PRINT}...${NC}\n"

    wget --content-disposition https://dl.pstmn.io/download/latest/linux
    
    # Extract Postman package
    TEMP_PRINT="Extract Postman package"
    printf "${PURPLE}${TEMP_PRINT}...${NC}\n"

    tar -xzf Postman-linux-*
    
    # Move the directory to `opt/` directory
    TEMP_PRINT="Move the directory to \`opt/\` directory"
    printf "${PURPLE}${TEMP_PRINT}...${NC}\n"

    sudo mv Postman /opt
    
    # Create a Symbolic Links
    TEMP_PRINT="Create a Symbolic Links"
    printf "${PURPLE}${TEMP_PRINT}...${NC}\n"

    sudo ln -s /opt/Postman/Postman /usr/local/bin/postman
    
    # Create a desktop file for Postman app
    TEMP_PRINT="Create a desktop file for Postman app"
    printf "${PURPLE}${TEMP_PRINT}...${NC}\n"

    DESKTOP_FILE="/usr/share/applications/postman.desktop"
    echo "[Desktop Entry]" >> $DESKTOP_FILE
    echo "Type=Application" >> $DESKTOP_FILE
    echo "Name=Postman" >> $DESKTOP_FILE
    echo "Icon=/opt/Postman/app/resources/app/assets/icon.png" >> $DESKTOP_FILE
    echo "Exec=\"/opt/Postman/Postman\"" >> $DESKTOP_FILE
    echo "Comment=Postman GUI" >> $DESKTOP_FILE
    echo "Categories=Development;Code;" >> $DESKTOP_FILE
    
    # Remove the installer after installation finish
    TEMP_PRINT="Remove the installer after installation finish"
    printf "${PURPLE}${TEMP_PRINT}...${NC}\n"

    rm Postman-linux-*

}


# -------------------------------------------------------------------

# Install FileZilla
install_filezilla() {

    TEMP_PRINT="Install FileZilla"
    printf "${CYAN}${TEMP_PRINT}:${NC}\n"

    sudo apt install filezilla -y

}


# Install tree
install_tree() {

    TEMP_PRINT="Install tree"
    printf "${CYAN}${TEMP_PRINT}:${NC}\n"

    sudo apt install tree -y

}


# Install rename
install_rename() {

    TEMP_PRINT="Install rename"
    printf "${CYAN}${TEMP_PRINT}:${NC}\n"

    sudo apt install rename -y

}


# Install Imagemagick
install_imagemagick() {

    TEMP_PRINT="Install Imagemagick"
    printf "${CYAN}${TEMP_PRINT}:${NC}\n"

    sudo apt install imagemagick -y

}


# ============================= OTHERS ===============================

# Install other apps
install_other_apps() {

    install_openssh                 # Install OpenSSH
    install_host                    # Install host
    install_htop                    # Install htop
    install_git                     # Install Git
    install_nettools                # Install net-tools
    install_python_dependencies     # Install Python dependencies
    install_docker                  # Install Docker
    install_nginx                   # Install NGINX
    install_certbot                 # Install Certbot
    install_redis                   # Install Redis
    install_postgresql              # Install PostgreSQL

}


# -------------------------------------------------------------------

# Install OpenSSH
install_openssh() {

    TEMP_PRINT="Install OpenSSH"
    printf "${CYAN}${TEMP_PRINT}:${NC}\n"

    sudo apt install openssh-server -y

}


# Install host
install_host() {

    TEMP_PRINT="Install host"
    printf "${CYAN}${TEMP_PRINT}:${NC}\n"

    sudo apt install host -y

}


# Install htop
install_htop() {

    TEMP_PRINT="Install htop"
    printf "${CYAN}${TEMP_PRINT}:${NC}\n"

    sudo apt install htop -y

}


# Install Git
install_git() {

    TEMP_PRINT="Install Git"
    printf "${CYAN}${TEMP_PRINT}:${NC}\n"

    sudo apt install git -y

}


# Install net-tools
install_nettools() {

    TEMP_PRINT="Install net-tools"
    printf "${CYAN}${TEMP_PRINT}:${NC}\n"

    sudo apt install net-tools -y

}


# Install Python dependencies
install_python_dependencies() {

    TEMP_PRINT="Install Python dependencies"
    printf "${CYAN}${TEMP_PRINT}:${NC}\n"

    # Install Python environment
    TEMP_PRINT="Install Python environment"
    printf "${PURPLE}${TEMP_PRINT}...${NC}\n"
    
    sudo apt install python3.8-venv -y
    
    # Install PIP
    TEMP_PRINT="Install PIP"
    printf "${PURPLE}${TEMP_PRINT}...${NC}\n"
    
    sudo apt install python3-pip -y
    
    # Install Django Admin
    TEMP_PRINT="Install Django Admin"
    printf "${PURPLE}${TEMP_PRINT}...${NC}\n"
    
    sudo apt install python3-django -y

}


# Install Docker
install_docker() {

    TEMP_PRINT="Install Docker"
    printf "${CYAN}${TEMP_PRINT}:${NC}\n"

    # Install the dependencies of Docker
    TEMP_PRINT="Install the dependencies of Docker"
    printf "${PURPLE}${TEMP_PRINT}...${NC}\n"
    
    sudo apt install apt-transport-https ca-certificates curl gnupg lsb-release -y
    
    # Add Docker’s official GPG key
    TEMP_PRINT="Add Docker’s official GPG key"
    printf "${PURPLE}${TEMP_PRINT}...${NC}\n"
    
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
    
    # Set up the stable repository of Docker and update the package index
    TEMP_PRINT="Set up the stable repository of Docker and update the package index"
    printf "${PURPLE}${TEMP_PRINT}...${NC}\n"
    
    echo "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
    sudo apt update

    # Install the latest version of Docker Engine and container
    TEMP_PRINT="Install the latest version of Docker Engine and container"
    printf "${PURPLE}${TEMP_PRINT}...${NC}\n"
    
    sudo apt install docker-ce docker-ce-cli containerd.io -y
    
    # Install Docker Compose
    TEMP_PRINT="Install Docker Compose"
    printf "${PURPLE}${TEMP_PRINT}...${NC}\n"
    
    sudo apt install docker-compose -y
    
    # Adding user to the Docker group
    TEMP_PRINT="Adding user to the Docker group"
    printf "${PURPLE}${TEMP_PRINT}...${NC}\n"
    
    sudo usermod -a -G docker $USER
    
}


# Install NGINX
install_nginx() {

    TEMP_PRINT="Install NGINX"
    printf "${CYAN}${TEMP_PRINT}:${NC}\n"

    sudo apt install nginx -y

}


# Install Certbot and it’s NGINX plugin
install_certbot() {

    TEMP_PRINT="Install Certbot and it’s NGINX plugin"
    printf "${CYAN}${TEMP_PRINT}:${NC}\n"

    sudo apt install certbot python3-certbot-nginx -y

}


# Install Redis
install_redis() {

    TEMP_PRINT="Install Redis"
    printf "${CYAN}${TEMP_PRINT}:${NC}\n"

    sudo apt install redis-server -y

}


# Install PostgreSQL
install_postgresql() {

    TEMP_PRINT="Install PostgreSQL"
    printf "${CYAN}${TEMP_PRINT}:${NC}\n"

    sudo apt install libpq-dev postgresql postgresql-contrib -y

}


# =========================== END SETUP =============================

# End Setup
end_setup() {

    # Enable the firewall
    enable_firewall

    # Reboot the system 
    reboot_system       

}


# -------------------------------------------------------------------

# Enable the firewall
enable_firewall() {

    TEMP_PRINT="Enable the firewall"
    printf "${CYAN}${TEMP_PRINT}:${NC}\n"

    # Enable the Uncomplicated Firewall (UFW)
    TEMP_PRINT="Enable the Uncomplicated Firewall (UFW)"
    printf "${PURPLE}${TEMP_PRINT}...${NC}\n"

    sudo ufw enable
    
    # Allow OpenSSH
    TEMP_PRINT="Allow OpenSSH"
    printf "${PURPLE}${TEMP_PRINT}...${NC}\n"

    sudo ufw allow OpenSSH
    
    # Allow NGINX
    TEMP_PRINT="Allow NGINX"
    printf "${PURPLE}${TEMP_PRINT}...${NC}\n"

    sudo ufw allow 'Nginx Full'

}


# Reboot the system
reboot_system() {

    # Some settings or installation need reboot to be affected.

    TEMP_PRINT="Reboot the system"
    printf "${CYAN}${TEMP_PRINT}:${NC}\n"

    # Ask the user
    read -p "Reboot now? [y/N] " is_reboot

    if [ "$is_reboot" == "y" ] || [ "$is_reboot" == "Y" ]; then

        printf "${TEMP_PRINT}...${NC} ${GREEN}OK${NC}\n"
        sudo reboot now

    else

        TEMP_PRINT="Reboot the system canceled."
        printf "${RED}${TEMP_PRINT}${NC}\n"

        exit

    fi

}


# ============================= EMAIL ===============================

# Setup for Email Server
setup_email_server() {

    # Ask if user want to set up an email server
    ask_setup_email_server() {

        TEMP_PRINT="Set up an email server? [y/N] "
        read -p "$TEMP_PRINT" USER_OPTION_SETUP_EMAIL_SERVER

        if [ "$USER_OPTION_SETUP_EMAIL_SERVER" == "y" ] || [ "$USER_OPTION_SETUP_EMAIL_SERVER" == "Y" ]; then

            TEMP_PRINT="The email server WILL be set up"
            printf "${PURPLE}${TEMP_PRINT}...${NC}\n"
            
            is_setup_email_server=true

        else

            TEMP_PRINT="The email server will NOT be set up"
            printf "${PURPLE}${TEMP_PRINT}...${NC}\n"

            is_setup_email_server=false

        fi

    }

    # Sending Test Email
    send_test_email() {

        TEMP_PRINT="Postfix sending test email"
        printf "${CYAN}${TEMP_PRINT}:${NC}\n"

        read -p "Receiver (eg, user@mail.com) []: " EMAIL_FOR_TEST_POSTFIX
        read -p "Message []: " MESSAGE_FOR_TEST_POSTFIX

        echo "$MESSAGE_FOR_TEST_POSTFIX" | sendmail $EMAIL_FOR_TEST_POSTFIX

        printf "${TEMP_PRINT}...${NC} ${GREEN}OK${NC}\n"

    }

    ask_setup_email_server

    if [ "$is_setup_email_server" = true ]; then

        TEMP_PRINT="Setup for Email Server"
        printf "${YELLOW}${TEMP_PRINT}...${NC}\n"

        CURRENT_SERVER_HOSTNAME=$(hostname)

        # Read user input
        TEMP_PRINT_1="Email hostname (eg, mail.example.com) []: "
        TEMP_PRINT_2="Email domain (eg, example.com) []: "
        TEMP_PRINT_3="Email user alias (eg, admin) []: "
        read -p "$TEMP_PRINT_1" EMAIL_HOSTNAME
        read -p "$TEMP_PRINT_2" EMAIL_DOMAIN
        read -p "$TEMP_PRINT_3" EMAIL_USER_ALIAS

        # ---------------------------------------------------------------

        # Update package list
        TEMP_PRINT="Update package list"
        printf "${CYAN}${TEMP_PRINT}:${NC}\n"

        sudo apt update

        # Install postfix
        TEMP_PRINT="Install postfix"
        printf "${CYAN}${TEMP_PRINT}:${NC}\n"

        sudo apt install postfix -y

        # Install telnet (to check port 25)
        TEMP_PRINT="Install telnet (to check port 25)"
        printf "${CYAN}${TEMP_PRINT}:${NC}\n"

        sudo apt install telnet -y

        # Install mailutils (to send and read email)
        TEMP_PRINT="Install mailutils to (send and read email)"
        printf "${CYAN}${TEMP_PRINT}:${NC}\n"

        sudo apt install mailutils -y

        # ---------------------------------------------------------------

        # Replace server hostname with email hostname in Postfix config
        TEMP_PRINT="Replace server hostname with email hostname in Postfix config"
        printf "${CYAN}${TEMP_PRINT}:${NC}\n"

        # Delete lines that contain a pattern of 'myhostname =' and 'mydestination ='
        TEMP_PRINT="Delete lines that contain a pattern of 'myhostname =' and 'mydestination ='"
        printf "${PURPLE}${TEMP_PRINT}...${NC}\n"

        sudo sed -i '/myhostname =/d' $FILE_CONFIG_POSTFIX_MAIN
        sudo sed -i '/mydestination =/d' $FILE_CONFIG_POSTFIX_MAIN

        # Add new line with new values of 'myhostname' and 'mydestination'
        TEMP_PRINT="Add new line with new values of 'myhostname' and 'mydestination'"
        printf "${PURPLE}${TEMP_PRINT}...${NC}\n"

        printf "myhostname = $EMAIL_HOSTNAME\n" | sudo tee -a $FILE_CONFIG_POSTFIX_MAIN
        printf "mydestination = \$myhostname, $EMAIL_DOMAIN, $EMAIL_HOSTNAME, localhost.$EMAIL_DOMAIN, localhost\n" | sudo tee -a $FILE_CONFIG_POSTFIX_MAIN

        sudo systemctl reload postfix

        # ---------------------------------------------------------------

        # Check Postfix config after edit
        TEMP_PRINT="Check Postfix config after edit"
        printf "${PURPLE}${TEMP_PRINT}...${NC}\n"

        cat $FILE_CONFIG_POSTFIX_MAIN | grep -e myhostname -e mydestination

        # Add new line with new values of aliases
        TEMP_PRINT="Add new line with new values of aliases"
        printf "${PURPLE}${TEMP_PRINT}...${NC}\n"

        printf "root:\t${EMAIL_USER_ALIAS}\n" | sudo tee -a $FILE_CONFIG_ALIASES
        sudo newaliases

        # Check Postfix version with this command
        TEMP_PRINT="Check Postfix version with this command"
        printf "${PURPLE}${TEMP_PRINT}...${NC}\n"

        postconf mail_version

        # Check if Postfix master process is listening on TCP port 25
        TEMP_PRINT="Check if Postfix master process is listening on TCP port 25"
        printf "${PURPLE}${TEMP_PRINT}...${NC}\n"

        sudo ss -lnpt | grep master 

        # Postfix ships with many binaries under the /usr/sbin/ directory
        TEMP_PRINT="Postfix ships with many binaries under the /usr/sbin/ directory"
        printf "${PURPLE}${TEMP_PRINT}...${NC}\n"

        dpkg -L postfix | grep /usr/sbin/ 

        # Open TCP Port 25 (inbound) in firewall
        TEMP_PRINT="Open TCP Port 25 (inbound) in firewall"
        printf "${PURPLE}${TEMP_PRINT}...${NC}\n"

        sudo ufw allow 25/tcp 

        # ---------------------------------------------------------------

        # Create an SPF Record in DNS (v=spf1 mx ~all)
        TEMP_PRINT="Create an SPF Record in DNS (v=spf1 mx ~all)"
        printf "${PURPLE}${TEMP_PRINT}...${NC}\n"

        # Check if user want to continue the process
        ask_continue_process

        # ---------------------------------------------------------------

        # Install SPF Policy Agen (to detect forged incoming emails)
        TEMP_PRINT="Install SPF Policy Agen (to detect forged incoming emails)"
        printf "${CYAN}${TEMP_PRINT}:${NC}\n"

        sudo apt install postfix-policyd-spf-python -y

        # Edit the Postfix master process configuration file (to start the SPF policy daemon when it’s starting itself)
        TEMP_PRINT="Edit the Postfix master process configuration file (to start the SPF policy daemon when it’s starting itself)"
        printf "${PURPLE}${TEMP_PRINT}...${NC}\n"
        
        TEMP_PRINT_1="policyd-spf  unix  -       n       n       -       0       spawn"
        TEMP_PRINT_2="user=policyd-spf argv=/usr/bin/policyd-spf"
        printf "\n$TEMP_PRINT_1\n  $TEMP_PRINT_2\n" | sudo tee -a $FILE_CONFIG_POSTFIX_MASTER

        # Impose a restriction on incoming emails (by rejecting unauthorized email and checking SPF record)
        TEMP_PRINT="Impose a restriction on incoming emails (by rejecting unauthorized email and checking SPF record)"
        printf "${PURPLE}${TEMP_PRINT}...${NC}\n"
        
        TEMP_PRINT_1="policyd-spf_time_limit = 3600"
        TEMP_PRINT_2="smtpd_recipient_restrictions ="
        TEMP_PRINT_3="permit_mynetworks,"
        TEMP_PRINT_4="permit_sasl_authenticated,"
        TEMP_PRINT_5="reject_unauth_destination,"
        TEMP_PRINT_6="check_policy_service unix:private/policyd-spf"
        printf "\n$TEMP_PRINT_1\n$TEMP_PRINT_2\n   $TEMP_PRINT_3\n   $TEMP_PRINT_4\n   $TEMP_PRINT_5\n   $TEMP_PRINT_6\n" | sudo tee -a $FILE_CONFIG_POSTFIX_MAIN
        sudo systemctl restart postfix

        # ---------------------------------------------------------------

        # Setting up DKIM
        # First, install OpenDKIM which is an open-source implementation of the DKIM sender authentication system.
        TEMP_PRINT="Install OpenDKIM"
        printf "${CYAN}${TEMP_PRINT}:${NC}\n"

        sudo apt install opendkim opendkim-tools -y

        # Add postfix user to OpenDKIM group
        TEMP_PRINT="Add postfix user to OpenDKIM group"
        printf "${PURPLE}${TEMP_PRINT}...${NC}\n"

        sudo gpasswd -a postfix opendkim 

        # Edit OpenDKIM configuration files
        TEMP_PRINT="Edit OpenDKIM configuration files"
        printf "${PURPLE}${TEMP_PRINT}...${NC}\n"

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

        # ---------------------------------------------------------------

        # Create a directory structure for OpenDKIM
        TEMP_PRINT="Create a directory structure for OpenDKIM"
        printf "${PURPLE}${TEMP_PRINT}...${NC}\n"

        sudo mkdir /etc/opendkim
        sudo mkdir /etc/opendkim/keys

        # Change the owner from 'root' to 'opendkim' (make sure only 'opendkim' user can read and write to the keys directory)
        TEMP_PRINT="Change the owner from 'root' to 'opendkim' (make sure only 'opendkim' user can read and write to the keys directory)"
        printf "${PURPLE}${TEMP_PRINT}...${NC}\n"

        sudo chown -R opendkim:opendkim /etc/opendkim
        sudo chmod go-rw /etc/opendkim/keys 

        sudo touch $FILE_CONFIG_OPENDKIM_SIGNINGTABLE

        TEMP_PRINT="*@$EMAIL_DOMAIN    default._domainkey.$EMAIL_DOMAIN"
        printf "\n$TEMP_PRINT\n" | sudo tee -a $FILE_CONFIG_OPENDKIM_SIGNINGTABLE

        sudo touch $FILE_CONFIG_OPENDKIM_KEYTABLE

        TEMP_PRINT="default._domainkey.$EMAIL_DOMAIN    $EMAIL_DOMAIN:default:/etc/opendkim/keys/$EMAIL_DOMAIN/default.private"
        printf "\n$TEMP_PRINT\n" | sudo tee -a $FILE_CONFIG_OPENDKIM_KEYTABLE

        sudo touch $FILE_CONFIG_OPENDKIM_TRUSTEDHOSTS

        TEMP_PRINT_1="#127.0.0.1"
        TEMP_PRINT_2="localhost"
        TEMP_PRINT_3="*.$EMAIL_DOMAIN"
        printf "\n$TEMP_PRINT_1\n$TEMP_PRINT_2\n\n$TEMP_PRINT_3\n" | sudo tee -a $FILE_CONFIG_OPENDKIM_TRUSTEDHOSTS

        # ---------------------------------------------------------------

        # Create a separate folder for the domain
        TEMP_PRINT="Create a separate folder for the domain"
        printf "${PURPLE}${TEMP_PRINT}...${NC}\n"

        sudo mkdir /etc/opendkim/keys/$EMAIL_DOMAIN 
        
        # Generate keys using opendkim-genkey tool
        TEMP_PRINT="Generate keys using opendkim-genkey tool"
        printf "${PURPLE}${TEMP_PRINT}...${NC}\n"

        sudo opendkim-genkey -b 2048 -d $EMAIL_DOMAIN -D /etc/opendkim/keys/$EMAIL_DOMAIN -s default -v
        
        # Make 'opendkim' as the owner of the Private Key
        TEMP_PRINT="Make 'opendkim' as the owner of the Private Key"
        printf "${PURPLE}${TEMP_PRINT}...${NC}\n"

        sudo chown opendkim:opendkim /etc/opendkim/keys/$EMAIL_DOMAIN/default.private 
        
        # Change the permission (only the opendkim user has read and write access to the file)
        TEMP_PRINT="Change the permission (only the opendkim user has read and write access to the file)"
        printf "${PURPLE}${TEMP_PRINT}...${NC}\n"

        sudo chmod 600 /etc/opendkim/keys/$EMAIL_DOMAIN/default.private 

        # Display the public key
        TEMP_PRINT="Display the public key"
        printf "${PURPLE}${TEMP_PRINT}...${NC}\n"

        sudo cat /etc/opendkim/keys/$EMAIL_DOMAIN/default.txt

        # ---------------------------------------------------------------

        # Publish the Public Key in DNS Records
        TEMP_PRINT="Publish the Public Key in DNS Records"
        printf "${PURPLE}${TEMP_PRINT}...${NC}\n"

        # Check if user want to continue the process
        ask_continue_process

        # ---------------------------------------------------------------

        # Test the DKIM Key
        TEMP_PRINT="Test the DKIM Key"
        printf "${PURPLE}${TEMP_PRINT}...${NC}\n"

        sudo opendkim-testkey -d $EMAIL_DOMAIN -s default -vvv

        # ---------------------------------------------------------------

        # Create a directory to hold the OpenDKIM socket file and allow only opendkim user and postfix group to access it
        TEMP_PRINT="Create a directory to hold the OpenDKIM socket file and allow only opendkim user and postfix group to access it"
        printf "${PURPLE}${TEMP_PRINT}...${NC}\n"

        sudo mkdir /var/spool/postfix/opendkim
        sudo chown opendkim:postfix /var/spool/postfix/opendkim

        # Edit the OpenDKIM main configuration file
        TEMP_PRINT="Edit the OpenDKIM main configuration file"
        printf "${PURPLE}${TEMP_PRINT}...${NC}\n"

        sudo sed -i "s/local:\/run\/opendkim\/opendkim.sock/local:\/var\/spool\/postfix\/opendkim\/opendkim.sock/g" $FILE_CONFIG_OPENDKIM
        sudo sed -i "s/SOCKET=local:\$RUNDIR\/opendkim.sock/SOCKET=\"local:\/var\/spool\/postfix\/opendkim\/opendkim.sock\"/g" $FILE_CONFIG_OPENDKIM_DEFAULT

        TEMP_PRINT_1="# Milter configuration"
        TEMP_PRINT_2="milter_default_action = accept"
        TEMP_PRINT_3="milter_protocol = 6"
        TEMP_PRINT_4="smtpd_milters = local:opendkim/opendkim.sock"
        TEMP_PRINT_5="non_smtpd_milters = \$smtpd_milters"
        printf "\n$TEMP_PRINT_1\n$TEMP_PRINT_2\n$TEMP_PRINT_3\n$TEMP_PRINT_4\n$TEMP_PRINT_5\n" | sudo tee -a $FILE_CONFIG_POSTFIX_MAIN

        sudo systemctl restart opendkim postfix

        # ---------------------------------------------------------------

        # Check if port 25 open or blocked
        TEMP_PRINT="Check if port 25 open or blocked"
        printf "${CYAN}${TEMP_PRINT}:${NC}\n"

        # Run the following command on your mail server.
        echo -e '\x1dquit\x0d' | sleep 5 | telnet gmail-smtp-in.l.google.com 25 > $FILE_TEMP
        CHECK_PORT_25=$(cat $FILE_TEMP | grep "220 mx.google.com")
        if [ "$CHECK_PORT_25" != "" ]; then 

            printf "Port 25... ${GREEN}OK${NC}\n"

            # Sending Test Email
            send_test_email

        else 

            printf "${RED}ERROR: Port 25 CLOSED!${NC}\n"

        fi

        rm $FILE_TEMP
    
    fi

}

# ============================= OTHERS ==============================

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


main "$@"


############################## REFERENCES ############################
# - How to change the output color of echo in Linux https://stackoverflow.com/a/5947802
# - How to fix ERROR: Couldn’t connect to Docker daemon at http+docker://localhost – is it running? https://techoverflow.net/2019/03/16/how-to-fix-error-couldnt-connect-to-docker-daemon-at-httpdocker-localhost-is-it-running/
# - What does "sudo apt-get update" do? https://askubuntu.com/a/222352
# - Check Whether a User Exists https://stackoverflow.com/a/14811915
# - How to insert text into a root-owned file using sudo? https://unix.stackexchange.com/a/4337
# - Temporary failure in name resolution https://stackoverflow.com/a/54460886
# - How do I test if an item is in a bash array? https://unix.stackexchange.com/a/625665
# - Auto exit Telnet https://stackoverflow.com/a/54364978
# - Email Setup:
#   > Build Your Own Email Server on Ubuntu https://www.linuxbabe.com/mail-server/setup-basic-postfix-mail-sever-ubuntu
#   > How to Set up SPF and DKIM with Postfix https://www.linuxbabe.com/mail-server/setting-up-dkim-and-spf
