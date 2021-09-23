# Dev Setup

Set up an environment for the development, testing, staging, and production.

- Virtual machine setup in VirtualBox 6.1[<sup>1</sup>](#footnotes) for **development** environment.
- Server setup in [DigitalOcean](https://m.do.co/c/d0e1521b9ceb) for **testing** and **staging** environment.
- Setup in dedicated/bare-metal server for **production** environment.

## How to Start

### VirtualBox

**Desktop**

1. Download and install the [guest OS](#virtualbox-1) (clean install).
1. [User Setup](#user-setup) in the **guest**.
1. [Install VBox Guest](#install-vbox-guest) in the **guest**.
1. [Download](https://github.com/ba1x/dev-setup/archive/refs/heads/main.zip) this project using the **host**.
1. Enable the **Shared Folders** from **host** to **guest**, then copy the downloaded file and extract it.
1. Run command [`sudo ./setup.sh`](setup.sh) and choose option `1. Vbox (Desktop)` to [initiate](docs/init-setup.md) the setup, install the [required applications](docs/install-required-applications.md), and [end up](docs/end-setup.md) the setup.

**Server**

1. Download and install the [guest OS](#virtualbox-1) ([clean install](docs/install-ubuntu-server.md)).
1. [User Setup](#user-setup) in the **guest**.
1. [Fix Error](#fix-error) in the **guest**.
1. Clone this project and open the folder.
    ```bash
    git clone https://github.com/ba1x/dev-setup.git
    cd dev-setup
    ```
1. Run command [`sudo ./setup.sh`](setup.sh) and choose option `2. Vbox/Bare-metal (Server)` to [initiate](docs/init-setup.md) the setup, install the [required applications](docs/install-required-applications.md), and [end up](docs/end-setup.md) the setup.

### DigitalOcean

1. Create a new droplet with the [required specification](#digitalocean-1).
1. Login to the server.
    ```bash
    ssh root@SERVER_IP_ADDRESS     # login using SSH
    ```
1. Clone this project and open the folder.
    ```bash
    git clone https://github.com/ba1x/dev-setup.git
    cd dev-setup
    ```
1. Run command [`./setup.sh`](setup.sh) and choose option `3. Cloud (DigitalOcean)` to [initiate](docs/init-setup.md) the setup, install the [required applications](docs/install-required-applications.md), and [end up](docs/end-setup.md) the setup.


### Dedicated/Bare-metal

1. Download and install the OS ([clean install](docs/install-ubuntu-server.md)).
1. [User Setup](#user-setup).
1. [Proxy Setup](#proxy-setup).
1. Clone this project and open the folder.
    ```bash
    git clone https://github.com/ba1x/dev-setup.git
    cd dev-setup
    ```
1. Run command [`sudo ./setup.sh`](setup.sh) and choose option `2. Vbox/Bare-metal (Server)` to [initiate](docs/init-setup.md) the setup, install the [required applications](docs/install-required-applications.md), and [end up](docs/end-setup.md) the setup. 

### (Optional) After Finish Setup

1. SSH manual [setup](https://gist.github.com/ba1x/38a6b359e2b4221b72adff201403045d) for using the existing key.
1. [Clear](https://gist.github.com/ba1x/35621c685282993146f6c51afd6f9bef) bash history if necessary.

## General Information

### VirtualBox

Operating system that already tested on VirtualBox:

1. [Ubuntu Desktop 20.04.3 LTS](https://ubuntu.com/download/desktop)[<sup>2</sup>](#footnotes)
1. [Ubuntu Server 20.04.3 LTS](https://ubuntu.com/download/server)[<sup>3</sup>](#footnotes)


**Settings**

| No | Type | CPU | RAM | HDD | VGA | Network | Tested? |
|:---:|---|---|---|---|---|:---:|:---:|
| 1 | Desktop | 2 CPUs | 4096 MB | 25 GB | 64 MB | NAT | ✅ |
| 2 | Server | 1 CPU | 1024 MB | 10 GB | 16 MB | Bridged | ✅ |

**Profile**

| No | VM Name | Name | Hostname | Username | Password |
|:---:|---|:---:|---|:---:|:---:|
| 1 | dev-labvm | dev | labvm | dev | dev |
| 2 | dev-labvm-server | dev | labvm-server | dev | dev | 

### DigitalOcean

Operating system that already tested on DigitalOcean:

1. [Ubuntu 20.04 (LTS) x64](https://ubuntu.com/download/server)

| No | Type | CPU | RAM | SSD | Tested? | 
|:---:|---|---|---|---|:---:|
| 1 | Shared CPU (Basic) | 1 CPU | 1 GB | 25 GB | ✅ |

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
3. [Partition](docs/ubuntu-filesystem-and-partitions.md)
    ```bash
    /        7.0 GB  ext4
    /boot    500 MB  ext4
    /home    500 MB  ext4
    /var     1.0 GB  ext4
    SWAP     1.0 GB  swap
    ```
