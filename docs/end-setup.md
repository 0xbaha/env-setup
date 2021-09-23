# End Setup

- Enable the firewall
    ```bash
    # Enable the Uncomplicated Firewall (UFW)
    sudo ufw enable
    # Allow OpenSSH
    sudo ufw allow OpenSSH
    # Allow NGINX
    sudo ufw allow 'Nginx Full'
    ```
- (Optional) Change the SSH Port
    ```bash
    # Change the default value
    sudo sed -i "s/#Port 22/Port $NEW_SSH_PORT/g" /etc/ssh/sshd_config
    # Allow the new port in firewall
    sudo ufw allow $NEW_SSH_PORT/tcp
    # Restart the service
    sudo systemctl restart ssh
    ```
- Reboot the system
    ```bash
    # Reboot the system
    # Some settings or installation need reboot to be affected.
    sudo reboot now
    ```