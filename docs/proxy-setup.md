# Proxy Setup

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
