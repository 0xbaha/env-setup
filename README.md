# Environment Setup

This repository contain a [script](setup.sh) that can be used to set up an environment for:

1. **web development**, includes:
    - [virtual machine](#virtual-machine) setup in VirtualBox 6.1[^1] for **development** environment
    - [cloud](#cloud) setup in [DigitalOcean](https://m.do.co/c/d0e1521b9ceb) and [Hostwinds](https://www.hostwinds.com/) for **testing** and **staging** environment
    - [bare-metal (physical server)](#physical-server) setup for **production** environment
1. **mail server**, includes:
    - set up a mail server in cloud

## Virtual Machine

The virtual machine that will be used is [VirtualBox](https://www.virtualbox.org/).

### Desktop

1. Download and install[^2] the [guest OS](docs/general-information.md#virtualbox).
1. [User Setup](docs/user-setup.md) in the **guest**.
1. [Install VBox Guest](docs/install-vbox-guest.md) in the **guest**.
1. [Download](https://github.com/ba1x/env-setup/archive/refs/heads/main.zip) this project using the **host**.
1. Enable the **Shared Folders** from **host** to **guest**, then copy the downloaded file and extract it.
1. Run command [`sudo ./setup.sh`](setup.sh) and choose option `1. Vbox (Desktop)` to [initiate](docs/init-setup.md) the setup, install the [required applications](docs/install-required-applications.md), and [end up](docs/end-setup.md) the setup.

### Server

1. Download and [install](docs/install-ubuntu-server.md)[^3] the [guest OS](docs/general-information.md#virtualbox).
1. [User Setup](docs/user-setup.md) in the **guest**.
1. [Fix Error](docs/fix-error.md) in the **guest**.
1. Clone this project and open the folder.
    ```bash
    git clone https://github.com/ba1x/env-setup.git
    cd env-setup
    ```
1. Run command [`sudo ./setup.sh`](setup.sh) and choose option `2. Vbox (Server)` to [initiate](docs/init-setup.md) the setup, install the [required applications](docs/install-required-applications.md), and [end up](docs/end-setup.md) the setup.

## Cloud

Make sure to add the `SSH keys` in the **Client Area** before starting the setup below.

### DigitalOcean

1. Create a new droplet with the [required specification](docs/general-information.md#digitalocean) and choose `SSH Keys` (that already added) for the **Authentication**.
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

### Hostwinds

1. Create an [unmanage Linux VPS hosting](https://www.hostwinds.com/vps/unmanaged-linux) with the [required specification](docs/general-information.md#hostwinds) and choose `SSH Keys` (that already added) for the **Authentication**.


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

## Physical Server

1. Download and [install](docs/install-ubuntu-server.md)[^4] the OS.
1. [User Setup](docs/user-setup.md).
1. (Optional) [Proxy Setup](docs/proxy-setup.md).
1. Clone this project and open the folder.
    ```bash
    git clone https://github.com/ba1x/env-setup.git
    cd env-setup
    ```
1. Run command [`sudo ./setup.sh`](setup.sh) and choose option `4. Physical Server` to [initiate](docs/init-setup.md) the setup, install the [required applications](docs/install-required-applications.md), and [end up](docs/end-setup.md) the setup. 

## (Optional) After Finish Setup

1. SSH manual [setup](docs/ssh-manual-setup.md) for using the existing key.
1. [Clear](docs/clear-bash-history.md) bash history if necessary.

## Footnotes

[^1]: [VirtualBox 6.1.26 r145957 (Qt5.6.2)](https://www.virtualbox.org/wiki/Downloads)

[^2]: Minimal Installation

[^3]: [Partition](docs/ubuntu-filesystem-and-partitions.md) for `10 GB` HDD/SSD and `1 GB` RAM.
    ```bash
    /        7.0 GB  ext4
    /boot    500 MB  ext4
    /home    500 MB  ext4
    /var     1.0 GB  ext4
    SWAP     1.0 GB  swap
    ```

[^4]: [Partition](docs/ubuntu-filesystem-and-partitions.md) for `1 TB` HDD/SSD and `8GB` RAM.
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
