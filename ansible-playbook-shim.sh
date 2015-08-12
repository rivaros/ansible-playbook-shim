#!/bin/bash

# This shim works only with modern versions of Vagrant 1.7.3 +
#

echo "Parameters received: $@"

# Get inventory file from ansible-playbook parameters
INVENTORY_FILE=`echo $@ | sed -E 's/.*--inventory-file=([^ ]*).*/\1\/vagrant_ansible_inventory/'`

# Process inventory file
# Copy private keys to Cygwin/Babun folders, change permissions
# Modify original inventory file with new key pathes
while IFS='' read -r line; do
    if [[ $line == *"ansible_ssh_private_key_file"* ]]
    then
        HOSTNAME=$(echo $line | sed -E 's/([^ ]*)([ ]+).*/\1/')
        ORIG_PRIV_KEY=$(echo $line | sed -E 's/.*ansible_ssh_private_key_file=([^ ]*).*/\1/')
        #copy key files to host folders, chmod files
        mkdir -p $HOME/.ssh/vagrant/$HOSTNAME
        NEW_PRIV_KEY="$HOME/.ssh/vagrant/$HOSTNAME/private_key"
        cp $(cygpath -u $ORIG_PRIV_KEY) $NEW_PRIV_KEY
        setfacl -s user::r--,group::---,other::--- $NEW_PRIV_KEY
        echo `echo $line | sed -E "s|ansible_ssh_private_key_file=([^ ]*)|ansible_ssh_private_key_file=$NEW_PRIV_KEY|"`
    else
        echo $line
    fi
done < $INVENTORY_FILE > inventory.tmp
cp inventory.tmp $INVENTORY_FILE && rm inventory.tmp

# Disable ControlMaster, as it's not working on Windows
export ANSIBLE_SSH_ARGS='-o ControlMaster=no'

# Finally run ansible-playbook with original parameters
ansible-playbook $@


