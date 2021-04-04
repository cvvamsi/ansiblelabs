#!/bin/bash
echo "creating the user demo on the remote managed nodes"
ansible all -m user -a "name=demo password='{{'P@ssw0rd' | password_hash('sha512') }}' state=present" -u root

echo "Copying the demo user's public key on to the remote managed node"
ansible all -m authorized_key -a "user=demo state=present key='{{ lookup('file','/home/demo/.ssh/id_rsa.pub') }}' path='/home/demo/.ssh/authorized_keys'" -u root

echo "Adding the demo user to sudoers file"
ansible all -m lineinfile -a "path=/etc/sudoers line='demo ALL=(ALL) NOPASSWD: ALL' state=present" -u root
