# ansible-playbook-shim

This is a working shim which allows using ansible provisioner with Vagrant 1.7.3+ on a Windows OS.
Installing Ansible on Windows is not covered by this help. Please refer to any of the multiple tutorials
in internet, for example [this one](https://chrisgilbert1.wordpress.com/2015/06/17/install-a-babun-cygwin-shell-and-ansible-for-windows/)


# Usage

We assume you have Cygwin or Babun installed. 

Clone the latest source and create a symlink in your cygwin path space
```
git clone https://github.com/rivaros/ansible-playbook-shim.git
ln -s $PWD/ansible-playbook-shim.sh /usr/local/bin/ansible-playbook-shim.sh
```

Copy ansible-playbook.bat somewhere within your Windows path.
For example C:\Users\%username%\\.babun\


# How it works

The ansible-playbook.bat file is called by Vagrant provisioner instead of the original ansible-playbook.
This allows us to replace the default Vagrant shell with Babun/Cygwin.

Later ansible-playbook-shim.sh comes into action. Script analizes the parameters for inventory file
location, extracts the private keys to cygwin home folder, which makes it possible to use them
with Babun ansible installation.

Anny comments/PRs are welcome.


