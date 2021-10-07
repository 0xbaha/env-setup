# Install VBox Guest

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
