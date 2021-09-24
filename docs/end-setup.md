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
- Reboot the system
    ```bash
    # Reboot the system
    # Some settings or installation need reboot to be affected.
    sudo reboot now
    ```