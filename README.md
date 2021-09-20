# Dev Setup

Setup for development, testing, and deployment environment.

- Virtual machine setup in [VirtualBox 6.1](#notes) for **development** environment.
- Server setup in [DigitalOcean](https://m.do.co/c/d0e1521b9ceb) for **testing** and **deployment** environment.

## How to Start

### VirtualBox

**Desktop**

1. Download and install the [guest OS](#general-information) (clean install).
1. [User Setup](#user-setup) in the **guest**.
1. [Install VBox Guest](#install-vbox-guest) in the **guest**.
1. [Download](https://github.com/ba1x/dev-setup/archive/refs/heads/main.zip) this project using the **host**.
1. Enable the **Shared Folders** from **host** to **guest**, then copy the downloaded file and extract it.
1. Run command [`sudo ./setup.sh`](setup.sh) to [initiate](#init-setup) the setup and install the [required applications](#install-required-applications).
1. [Clear](https://gist.github.com/ba1x/35621c685282993146f6c51afd6f9bef) bash history if necessary.

**Server**

1. Download and install the [guest OS](#general-information) (clean install).
1. [User Setup](#user-setup) in the **guest**.
1. [Fix Error](#fix-error) in the **guest**.
1. Clone this project and open the folder.
    ```bash
    git clone https://github.com/ba1x/dev-setup.git
    cd dev-setup
    ```
1. Run command [`sudo ./setup.sh`](setup.sh) to [initiate](#init-setup) the setup and install the [required applications](#install-required-applications).
1. [Clear](https://gist.github.com/ba1x/35621c685282993146f6c51afd6f9bef) bash history if necessary.

### DigitalOcean

1. Create a new droplet with the [required specification](#general-information).
1. Login to the server.
    ```bash
    ssh root@SERVER_IP_ADDRESS     # login using SSH
    ```
1. Clone this project and open the folder.
    ```bash
    git clone https://github.com/ba1x/dev-setup.git
    cd dev-setup
    ```
1. Run command [`./setup.sh`](setup.sh) to [initiate](#init-setup) the setup and install the [required applications](#install-required-applications).
1. SSH manual [setup](https://gist.github.com/ba1x/38a6b359e2b4221b72adff201403045d) for using the existing key.
1. [Clear](https://gist.github.com/ba1x/35621c685282993146f6c51afd6f9bef) bash history if necessary.

## General Information

### VirtualBox

**Settings**

| No | Operating System | CPU | RAM | HDD | VGA | Network | Tested? |
|---|---|---|---|---|---|---|---|
| 1 | [Ubuntu Desktop 20.04.3 LTS*](https://ubuntu.com/download/desktop) | 2 CPUs | 4096 MB | 25 GB | 64 MB | NAT | ✅ |
| 2 | [Ubuntu Server 20.04.3 LTS](https://ubuntu.com/download/server) | 1 CPU | 1024 MB | 10 GB | 16 MB | Bridged | ✅ |

```
* Minimal Installation
```

**Profile**

| No | VM Name | Name | Hostname | Username | Password |
|---|---|---|---|---|---|
| 1 | dev-labvm | dev | labvm | dev | dev |
| 2 | dev-labvm-server | dev | labvm-server | dev | dev | 

### DigitalOcean

| No | Operating System | CPU | RAM | SSD | Tested? | 
|----|------------------|-----|-----|-----|---------|
| 1 | [Ubuntu 20.04 (LTS) x64](https://ubuntu.com/download/server) | 1 CPU | 1 GB | 25 GB | ✅ |

## User Setup

- (Optional) Change the `root` password
    ```bash
    # Set the user root password
    sudo passwd root
    ```
- (Optional) [Sudo without password](https://linuxhandbook.com/sudo-without-password/)
    ```bash
    # Use the following command to edit the /etc/sudoers file:
    # - Add a line like this in this file:
    #   username ALL=(ALL) NOPASSWD:ALL
    # - eg. for this OVA file:
    #   dev ALL=(ALL) NOPASSWD:ALL
    sudo visudo
    ```
- Reboot the system
    ```bash
    # Reboot the system
    sudo reboot now
    ```

## Fix Error

- (Optional) [Fix: Temporary failure in name resolution](https://stackoverflow.com/a/54460886)
    ```bash
    # Disable systemd-resolved service
    sudo systemctl disable systemd-resolved.service
    # Stop the service
    sudo systemctl stop systemd-resolved.service
    # Remove the link to /run/systemd/resolve/stub-resolv.conf in /etc/resolv.conf
    sudo rm /etc/resolv.conf
    # Add a manually created resolv.conf in /etc/
    sudo touch /etc/resolv.conf
    # Add a prefered DNS server there
    echo "nameserver $DNS_NAMESERVER" | sudo tee -a /etc/resolv.conf > /dev/null
    ```

## Install VBox Guest

Before run the commands below, please **`Insert Guest Addition CD Image CD...`**

Open **Terminal** and run the following commands.

- Install VBox Guest Addition
    ```bash
    # Update the packages index and install the dependencies of VBox Guest Addition
    sudo apt update
    sudo apt install gcc make
    # Instal VBox Guest Addtion
    cd /media/dev/VBox_GAs_6.1.26/
    sudo ./autorun.sh
    ```
- Add `$USER` to the `vboxsf` group.
    ```bash
    sudo adduser $USER vboxsf
    ```
- Reboot the system
    ```bash
    # Reboot the system
    sudo reboot now
    ```
    
After finish installing, please remove the **`Guest Addition CD Image`**

## Init Setup

- Create sudo user
    ```bash
    # Create the user
    sudo adduser $NEW_USERNAME
    # Add to sudo group
    sudo usermod -aG sudo $NEW_USERNAME
    ```
- Copy SSH authorized keys
    ```bash
    mkdir /home/$NEW_USERNAME/.ssh
    cp /root/.ssh/authorized_keys /home/$NEW_USERNAME/.ssh/
    chown -R $NEW_USERNAME:$NEW_USERNAME /home/$NEW_USERNAME/.ssh/
    ```
- Set timezone
    ```bash
    # Set timezone
    timedatectl set-timezone $TIMEZONE
    ```
- Update and upgrade the packages
    ```bash
    # Update the package lists that need upgrading
    sudo apt update
    # Upgrade packages and its dependencies
    sudo apt dist-upgrade
    ```

## Install Required Applications

### Dev Tools

- Install Visual Studio Code
    ```bash
    # Install the dependencies
    sudo apt install software-properties-common apt-transport-https wget
    # Import the Microsoft GPG key
    wget -q https://packages.microsoft.com/keys/microsoft.asc -O- | sudo apt-key add -
    # Enable the repository and update the package index
    sudo add-apt-repository "deb [arch=amd64] https://packages.microsoft.com/repos/vscode stable main"
    sudo apt update
    # Install the package
    sudo apt install code
    ```
- [Install SQLite Browser](https://sqlitebrowser.org/dl/)
    ```bash
    # Install SQLite Browser
    sudo apt install sqlitebrowser
    ```
- [Install MySQL Workbench](https://dev.mysql.com/downloads/workbench/)
    ```bash
    # Install the dependencies of MySQL Workbench
    sudo apt install libopengl0 libpcrecpp0v5 libproj15 libzip5
    # Download installer
    wget https://dev.mysql.com/get/Downloads/MySQLGUITools/mysql-workbench-community_8.0.26-1ubuntu20.04_amd64.deb
    # Install the MySQL Workbench
    sudo dpkg -i mysql-*
    # Remove the installer after installation finish
    rm mysql-*

    ```
- [Install Postman](https://speedysense.com/install-postman-on-ubuntu-20-04/)
    ```bash
    # Download Postman installer
    wget --content-disposition https://dl.pstmn.io/download/latest/linux
    # Extract Postman package
    tar -xzf Postman-linux-*
    # Move Postman directory to `opt/` directory
    sudo mv Postman /opt
    # Create a Symbolic Links
    sudo ln -s /opt/Postman/Postman /usr/local/bin/postman
    # Create a desktop file for Postman app
    DESKTOP_FILE="/usr/share/applications/postman.desktop"
    echo "[Desktop Entry]" >> $DESKTOP_FILE
    echo "Type=Application" >> $DESKTOP_FILE
    echo "Name=Postman" >> $DESKTOP_FILE
    echo "Icon=/opt/Postman/app/resources/app/assets/icon.png" >> $DESKTOP_FILE
    echo "Exec=\"/opt/Postman/Postman\"" >> $DESKTOP_FILE
    echo "Comment=Postman GUI" >> $DESKTOP_FILE
    echo "Categories=Development;Code;" >> $DESKTOP_FILE
    # Remove the installer after installation finish
    rm Postman-linux-*
    ```

### Others

- Install OpenSSH
    ```bash
    # Install OpenSSH
    sudo apt install openssh-server
    ``` 
- Install htop
    ```bash
    # Install htop
    sudo apt install htop
    ```
- Install net-tools
    ```bash
    # Install net tools
    sudo apt install net-tools
    ```
- Install tree
    ```bash
    # Install tree
    sudo apt install tree
    ```
- Install rename
    ```bash
    # Install rename
    sudo apt install rename
    ```
- Install Imagemagick
    ```bash
    # Install Imagemagick
    sudo apt install imagemagick
    ```
- Install FileZilla
    ```bash
    # Install FileZilla
    sudo apt install filezilla
    ```
- Install Git
    ```bash
    # Install git
    sudo apt install git
    ```
- Install Python dependencies
    ```bash
    # Install Python environment
    sudo apt install python3.8-venv
    # Install PIP
    sudo apt install python3-pip
    # Install Django Admin
    sudo apt install python3-django
    ```
- Install Docker
    ```bash
    # Install the dependencies of Docker
    sudo apt install apt-transport-https ca-certificates curl gnupg lsb-release
    # Add Docker’s official GPG key
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
    # Set up the stable repository of Docker and update the package index
    echo "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
    sudo apt update
    # Install the latest version of Docker Engine and container
    sudo apt install docker-ce docker-ce-cli containerd.io
    # Install Docker Compose
    sudo apt install docker-compose
    # Adding user to the Docker group
    sudo usermod -a -G docker $USER
    ```
- Install NGINX
    ```bash
    # Install NGINX
    sudo apt install nginx
    ```
- Install Certbot and it’s NGINX plugin
    ```bash
    # Install Certbot and it’s NGINX plugin
    sudo apt install certbot python3-certbot-nginx
    ```
- Install Redis
    ```bash
    # Install Redis
    sudo apt install redis-server
    ```

## End Setup

- Enable the firewall
    ```bash
    # Enable the Uncomplicated Firewall (UFW)
    sudo ufw enable
    # Allow OpenSSH
    sudo ufw allow OpenSSH
    # Allow NGINX
    sudo ufw allow 'Nginx Full'
    ```
- Reboot the system
    ```bash
    # Reboot the system
    # Some settings or installation need reboot to be affected.
    sudo reboot now
    ```

## Notes

- VirtualBox 6.1.26 r145957 (Qt5.6.2)
