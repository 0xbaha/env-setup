# User Setup

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