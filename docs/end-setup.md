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
- Change SSH Port
    ```bash
    sudo sed -i "s/#Port 22/Port $NEW_SSH_PORT/g" /etc/ssh/sshd_config
    sudo ufw allow $NEW_SSH_PORT/tcp
    sudo systemctl restart ssh
    ```
- Reboot the system
    ```bash
    # Reboot the system
    # Some settings or installation need reboot to be affected.
    sudo reboot now
    ```