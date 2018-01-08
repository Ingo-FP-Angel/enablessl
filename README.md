enablessh
=========

This is a collection of scripts to automate enabling SSH and transferring the correct public key to a smartphone running Ubuntu Touch.

So far only the unix/linux script exists. At least a windows script will follow (don't have access to mac...)

Inspired by the answer in https://askubuntu.com/a/599041

Prerequisites
-------------

- adb installed and in $PATH
- ssh key to be used is already created
- phone is in developer mode

Usage
-----

    enablessh_unix.sh <public key file to use>

Output will look like

	Connect phone with USB mode 'MTP' and 'USB debugging' enabled
	(CTRL-C to abort)
	
	Create /home/phablet/.ssh if necessary

	Transferring keyfile /home/user/.ssh/id_ecdsa.pub
	6 KB/s (267 bytes in 0.041s)

	Adding key to /home/phablet/.ssh/authorized_keys if necessary

	Enabling SSH
	ssh enabled

	Use the following IP(s) to connect
	192.168.1.33
