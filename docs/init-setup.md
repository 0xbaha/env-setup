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
- (Optional) SSH settings
    ```bash
    # Change the SSH Port
    sudo sed -i "s/#Port 22/Port $NEW_SSH_PORT/g" /etc/ssh/sshd_config
    # Allow the new port in firewall
    sudo ufw allow $NEW_SSH_PORT/tcp
    # Disable password authentication on SSH
    sudo sed -i "s/PasswordAuthentication yes/PasswordAuthentication no/g" /etc/ssh/sshd_config
    # Disable root login on SSH
    sudo sed -i "s/PermitRootLogin yes/PermitRootLogin no/g" /etc/ssh/sshd_config
    sudo sed -i "s/#PermitRootLogin prohibit-password/PermitRootLogin no/g" /etc/ssh/sshd_config
    # Restart the service
    sudo systemctl restart ssh
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