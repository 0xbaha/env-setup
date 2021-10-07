# Fix Error

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