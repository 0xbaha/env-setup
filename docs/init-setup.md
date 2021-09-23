# Init Setup

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