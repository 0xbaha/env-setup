# SSH Manual Setup

```bash
#!/bin/bash

# create ssh directory
mkdir .ssh
chmod 700 .ssh

# create authorized_keys file
touch .ssh/authorized_keys
chmod 600 .ssh/authorized_keys

# create key files
touch ~/.ssh/id_rsa
touch ~/.ssh/id_rsa.pub

# change the permissions
chmod 600 .ssh/id_rsa
chmod 644 .ssh/id_rsa.pub

# add the value of private keys
vi ~/.ssh/id_rsa

# generate public key from private key
ssh-keygen -y -f ~/.ssh/id_rsa > ~/.ssh/id_rsa.pub
```