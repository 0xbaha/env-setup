# Environment Setup

This repository contain a [script](setup.sh) that can be used to set up an environment for [web development](#web-development) and [mail server](#mail-server).

### Web Development

- [Virtual machine](#virtual-machine) setup in VirtualBox 6.1[<sup>1</sup>](#footnotes) for **development** environment.
- [Cloud](#cloud) setup in [DigitalOcean](https://m.do.co/c/d0e1521b9ceb) and [Hostwinds](https://www.hostwinds.com/) for **testing** and **staging** environment.
- [Bare-metal (physical server)](#physical-server) setup for **production** environment.

### Mail Server

- Set up a mail server in cloud.

## How to Start

### Virtual Machine

The virtual machine that will be used is [VirtualBox](https://www.virtualbox.org/).

#### Desktop

1. Download and install[<sup>2</sup>](#footnotes) the [guest OS](#virtualbox).
1. [User Setup](#user-setup) in the **guest**.
1. [Install VBox Guest](#install-vbox-guest) in the **guest**.
1. [Download](https://github.com/ba1x/env-setup/archive/refs/heads/main.zip) this project using the **host**.
1. Enable the **Shared Folders** from **host** to **guest**, then copy the downloaded file and extract it.
1. Run command [`sudo ./setup.sh`](setup.sh) and choose option `1. Vbox (Desktop)` to [initiate](docs/init-setup.md) the setup, install the [required applications](docs/install-required-applications.md), and [end up](docs/end-setup.md) the setup.

#### Server

1. Download and [install](docs/install-ubuntu-server.md)[<sup>3</sup>](#footnotes) the [guest OS](#virtualbox).
1. [User Setup](#user-setup) in the **guest**.
1. [Fix Error](#fix-error) in the **guest**.
1. Clone this project and open the folder.
    ```bash
    git clone https://github.com/ba1x/env-setup.git
    cd env-setup
    ```
1. Run command [`sudo ./setup.sh`](setup.sh) and choose option `2. Vbox (Server)` to [initiate](docs/init-setup.md) the setup, install the [required applications](docs/install-required-applications.md), and [end up](docs/end-setup.md) the setup.

### Cloud

Make sure to add the `SSH keys` in the **Client Area** before starting the setup below.

#### DigitalOcean

1. Create a new droplet with the [required specification](#digitalocean-1) and choose `SSH Keys` (that already added) for the **Authentication**.
1. Login to the server.
    ```bash
    ssh root@SERVER_IP_ADDRESS     # login using SSH
    ```
1. Clone this project and open the folder.
    ```bash
    git clone https://github.com/ba1x/env-setup.git
    cd env-setup
    ```
1. Run command [`./setup.sh`](setup.sh) and choose option `3. Cloud (DigitalOcean/Hostwinds)` to [initiate](docs/init-setup.md) the setup, install the [required applications](docs/install-required-applications.md), and [end up](docs/end-setup.md) the setup.

#### Hostwinds

1. Create an [unmanage Linux VPS hosting](https://www.hostwinds.com/vps/unmanaged-linux) with the [required specification](#hostwinds-1) and choose `SSH Keys` (that already added) for the **Authentication**.


1. Log in to the server using SSH:
    ```bash
     ssh root@SERVER_IP_ADDRESS     # login using SSH
    ```
1. Download and install the prerequisite apps (Git and UFW).
    ```bash
    sudo apt update && sudo apt install git ufw -y
    ```
1. Clone this project and open the folder.
     ```bash
    git clone https://github.com/ba1x/env-setup.git
    cd env-setup
    ```
1. Run command `./setup.sh` and choose option `3. Cloud (DigitalOcean/Hostwinds)` to [initiate](docs/init-setup.md) the setup, install the [required applications](docs/install-required-applications.md), and [end up](docs/end-setup.md) the setup.

### Physical Server

1. Download and [install](docs/install-ubuntu-server.md)[<sup>4</sup>](#footnotes) the OS.
1. [User Setup](#user-setup).
1. (Optional) [Proxy Setup](#proxy-setup).
1. Clone this project and open the folder.
    ```bash
    git clone https://github.com/ba1x/env-setup.git
    cd env-setup
    ```
1. Run command [`sudo ./setup.sh`](setup.sh) and choose option `4. Physical Server` to [initiate](docs/init-setup.md) the setup, install the [required applications](docs/install-required-applications.md), and [end up](docs/end-setup.md) the setup. 

### (Optional) After Finish Setup

1. SSH manual [setup](docs/ssh-manual-setup.md) for using the existing key.
1. [Clear](docs/clear-bash-history.md) bash history if necessary.

## General Information

### VirtualBox

Operating system that already tested on VirtualBox:

1. [Ubuntu Desktop 20.04.3 LTS](https://ubuntu.com/download/desktop)[<sup>2</sup>](#footnotes)
1. [Ubuntu Server 20.04.3 LTS](https://ubuntu.com/download/server)[<sup>3</sup>](#footnotes)


#### Settings

| No | Type | CPU | RAM | HDD | VGA | Network | Tested? |
|:---:|---|---|---|---|---|:---:|:---:|
| 1 | Desktop | 2 CPUs | 4096 MB | 25 GB | 64 MB | NAT | ✅ |
| 2 | Server | 1 CPU | 1024 MB | 10 GB | 16 MB | Bridged | ✅ |

#### Profile

| No | VM Name | Name | Hostname | Username | Password |
|:---:|---|:---:|---|:---:|:---:|
| 1 | dev-labvm | dev | labvm | dev | dev |
| 2 | dev-labvm-server | dev | labvm-server | dev | dev | 

### DigitalOcean

Operating system that already tested on DigitalOcean:

1. [Ubuntu 20.04 (LTS) x64](https://ubuntu.com/download/server)

| No | Product | CPU | RAM | SSD | Tested? | 
|:---:|---|---|---|---|:---:|
| 1 | Shared CPU (Basic) | 1 CPU | 1 GB | 25 GB | ✅ |

### Hostwinds

Operating system that already tested on Hostwinds:

1. [Ubuntu 20.04 (LTS) x64](https://ubuntu.com/download/server)

| No | Product | CPU | RAM | SSD | Tested? | 
|:---:|---|---|---|---|:---:|
| 1 | Unmanaged SSD Cloud 1 | 1 Core | 1 GB | 30 GB | ✅ |

### Physical Server

Operating system that already tested on physical server:

1. [Ubuntu Server 20.04.3 LTS](https://ubuntu.com/download/server)

| No | Type | CPU | RAM | HDD | Tested? | 
|:---:|---|---|---|---|:---:|
| 1 | Server | 8 CPUs | 8 GB | 1 TB | ✅ |

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
    # Add a prefered DNS server there, eg. 208.67.222.222 (OpenDNS)
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


## Proxy Setup

- Open environment file
    ```bash
    sudo nano /etc/environment
    ```
    Then, add the following codes:
    ```bash
    http_proxy="http://$USERNAME:$PASSWORD@$SERVER:8080/"
    https_proxy="http://$USERNAME:$PASSWORD@$SERVER:8080/"
    ftp_proxy="http://$USERNAME:$PASSWORD@$SERVER:8080/"
    no_proxy="127.0.0.1,localhost"
    ```

## Footnotes

1. [VirtualBox 6.1.26 r145957 (Qt5.6.2)](https://www.virtualbox.org/wiki/Downloads)
2. Minimal Installation
3. [Partition](docs/ubuntu-filesystem-and-partitions.md) for `10 GB` HDD/SSD and `1 GB` RAM.
    ```bash
    /        7.0 GB  ext4
    /boot    500 MB  ext4
    /home    500 MB  ext4
    /var     1.0 GB  ext4
    SWAP     1.0 GB  swap
    ```
3. [Partition](docs/ubuntu-filesystem-and-partitions.md) for `1 TB` HDD/SSD and `8GB` RAM.
    ```bash
    /           240 GB  ext4
    /boot       2.5 GB  ext4
    /home       500 GB  ext4
    /srv        2.5 GB  ext4
    /usr        100 GB  ext4
    /var         20 GB  ext4
    /var/lib     50 GB  ext4
    SWAP         16 GB  swap
    ```
