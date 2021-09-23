# Install Required Applications

## Dev Tools

- Install Visual Studio Code
    ```bash
    # Install the dependencies
    sudo apt install software-properties-common apt-transport-https wget
    # Import the Microsoft GPG key
    wget -q https://packages.microsoft.com/keys/microsoft.asc -O- | sudo apt-key add -
    # Enable the repository and update the package index
    sudo add-apt-repository "deb [arch=amd64] https://packages.microsoft.com/repos/vscode stable main"
    sudo apt update
    # Install the package
    sudo apt install code
    ```
- [Install SQLite Browser](https://sqlitebrowser.org/dl/)
    ```bash
    # Install SQLite Browser
    sudo apt install sqlitebrowser
    ```
- [Install MySQL Workbench](https://dev.mysql.com/downloads/workbench/)
    ```bash
    # Install the dependencies of MySQL Workbench
    sudo apt install libopengl0 libpcrecpp0v5 libproj15 libzip5
    # Download installer
    wget https://dev.mysql.com/get/Downloads/MySQLGUITools/mysql-workbench-community_8.0.26-1ubuntu20.04_amd64.deb
    # Install the MySQL Workbench
    sudo dpkg -i mysql-*
    # Remove the installer after installation finish
    rm mysql-*

    ```
- [Install Postman](https://speedysense.com/install-postman-on-ubuntu-20-04/)
    ```bash
    # Download Postman installer
    wget --content-disposition https://dl.pstmn.io/download/latest/linux
    # Extract Postman package
    tar -xzf Postman-linux-*
    # Move Postman directory to `opt/` directory
    sudo mv Postman /opt
    # Create a Symbolic Links
    sudo ln -s /opt/Postman/Postman /usr/local/bin/postman
    # Create a desktop file for Postman app
    DESKTOP_FILE="/usr/share/applications/postman.desktop"
    echo "[Desktop Entry]" >> $DESKTOP_FILE
    echo "Type=Application" >> $DESKTOP_FILE
    echo "Name=Postman" >> $DESKTOP_FILE
    echo "Icon=/opt/Postman/app/resources/app/assets/icon.png" >> $DESKTOP_FILE
    echo "Exec=\"/opt/Postman/Postman\"" >> $DESKTOP_FILE
    echo "Comment=Postman GUI" >> $DESKTOP_FILE
    echo "Categories=Development;Code;" >> $DESKTOP_FILE
    # Remove the installer after installation finish
    rm Postman-linux-*
    ```

## Others

- Install OpenSSH
    ```bash
    # Install OpenSSH
    sudo apt install openssh-server
    ``` 
- Install htop
    ```bash
    # Install htop
    sudo apt install htop
    ```
- Install net-tools
    ```bash
    # Install net tools
    sudo apt install net-tools
    ```
- Install tree
    ```bash
    # Install tree
    sudo apt install tree
    ```
- Install rename
    ```bash
    # Install rename
    sudo apt install rename
    ```
- Install Imagemagick
    ```bash
    # Install Imagemagick
    sudo apt install imagemagick
    ```
- Install FileZilla
    ```bash
    # Install FileZilla
    sudo apt install filezilla
    ```
- Install Git
    ```bash
    # Install git
    sudo apt install git
    ```
- Install Python dependencies
    ```bash
    # Install Python environment
    sudo apt install python3.8-venv
    # Install PIP
    sudo apt install python3-pip
    # Install Django Admin
    sudo apt install python3-django
    ```
- Install Docker
    ```bash
    # Install the dependencies of Docker
    sudo apt install apt-transport-https ca-certificates curl gnupg lsb-release
    # Add Docker’s official GPG key
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
    # Set up the stable repository of Docker and update the package index
    echo "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
    sudo apt update
    # Install the latest version of Docker Engine and container
    sudo apt install docker-ce docker-ce-cli containerd.io
    # Install Docker Compose
    sudo apt install docker-compose
    # Adding user to the Docker group
    sudo usermod -a -G docker $USER
    ```
- Install NGINX
    ```bash
    # Install NGINX
    sudo apt install nginx
    ```
- Install Certbot and it’s NGINX plugin
    ```bash
    # Install Certbot and it’s NGINX plugin
    sudo apt install certbot python3-certbot-nginx
    ```
- Install Redis
    ```bash
    # Install Redis
    sudo apt install redis-server
    ```
- Install PostgreSQL
    ```bash
    # Install PostgreSQL
    sudo apt install libpq-dev postgresql postgresql-contrib
    ```
