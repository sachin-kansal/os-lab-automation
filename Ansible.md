# basic play run command
ansible-playbook --inventory Ansible_redhat_linux9_hardening\inventory\hosts

ansible-playbook -i Ansible_redhat_linux9_hardening/inventory/hosts Ansible_practice/practice_playbook.yaml -vv --ask-become-pass

if no certs setup

ansible-playbook -i Ansible_redhat_linux9_hardening/inventory/hosts Ansible_practice/practice_playbook.yaml -vv --ask-become-pass --ask-pass

# one of the condition

failed_when: false or true
If the expression evaluates to true, Ansible marks the task as failed — even if it didn't crash.
If it evaluates to false, Ansible marks it as successful — even if the command had a non-zero exit code.

so case like checking if file exist or nit can be used to run further task even exit code 1 for non present file

## for user
generate_ssh_key : true 
genreates the ssh key for the user each time run so add a check if key exist or not it doesnot override it though.
public key present in output

"ssh_public_key": "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDZ+F7aptYMTYG5sX3uXBaAfpKzQaCbeBkEWWyeL8or1j1FDHQsHmUPRP4/9ihU2SInb2v+8aoDP90crT4/4yioN+KzfxXb124oZ/ifaJ+40vN4ThNS19vTa3bbD9StZXafWr2c4K7aU4u1AeFGkkyofv1AjhVO5mRec2Dh89MT4lfielpgFNZ+DnG1wmNfuQQkmPIC+jDNsOeGG7S94ElFh2582O7lG7sJyI8eUyi1CMh92h9daKutEoGeZ0NCu4E92EvTsnKI8TU3LScz2o+VfQnxQIPCxu1BPKd+YlDCUE/F+/HVzYuleiJ4angeyd2ciiFbWVZ3vd2a+60e/QSrV5L/IlJ18XYgu+cK6tm06TFZqEC2Tdnw2wF31vL9GwRPB934JHesxDfDIAX+CL2cc0vbZ6eq4io1k7cZXQkFK0+wb34cYZqP7e4GDhrfM0x+yBKA6+xo17Da+vfTXLf/NnIlHTyq2g2ajG1m82K6g2tXOk90w3RAWwfjZxxwoHs= ansible-generated on redhat-lab"


# modules 

Ansible comes with a rich set of built-in modules to manage systems and applications efficiently. These modules are the building blocks of Ansible playbooks.

Here are the major built-in Ansible module categories and popular modules under each:

1. System Modules

Used for user, group, service, and file system management.

Module	|Description|
-----| ---|
user |	Manage user accounts
group |	Manage groups
hostname |	Set system hostname
service / systemd	| Manage services (start/stop/enable)
cron	| Manage cron jobs
timezone  |Set system time zone
sysctl	|Manage sysctl settings

2. File Modules

Handle files, directories, permissions, and content.

| Module	| Description |
| ------ | -----|
copy	|Copy files to remote hosts
template	|Use Jinja2 templates
file	|Change file properties
lineinfile|	Add/update/remove lines in files
blockinfile|	Add a block of lines in a file
replace|	Replace patterns in files
assemble|	Combine fragments into one file

3. Command & Shell Modules

Run shell or command-line utilities.

Module	| Description |
--- | --- |
command	| Run shell commands (no shell features like `
shell	| Run shell commands with shell features
raw	 | Send raw command (used for bootstrapping)
script|	Upload and execute a local script

4. Package Management Modules

Manage software packages.

OS Type |	Module	|Description |
--- | --- | ---|
Debian/Ubuntu	|apt	|Manage apt packages
RHEL/CentOS|	yum / dnf|	Manage RPM packages
SUSE	|zypper	|Manage SUSE packages

All	package	Generic package handler

Python	pip	Manage Python packages

5. Networking Modules

Configure network settings or services.

Module	Description
firewalld	Manage firewall rules
ufw	Manage uncomplicated firewall
nmcli	Manage network using NetworkManager CLI
iptables	Manage iptables rules

 6. Storage Modules

Manage disks, filesystems, and mounts.

Module	Description
mount	Mount or unmount a filesystem
lvg	Create/manage LVM volume groups
lv	Create/manage LVM logical volumes
parted	Create partitions

7. Identity Modules

Manage authentication and identity systems.

Module	Description
authorized_key	Manage SSH authorized keys
openssh_keypair	Generate SSH key pairs (newer versions)
seboolean	Manage SELinux booleans
selinux	Manage SELinux state

8. Archive & Compression

Handle archive files.

Module	Description
unarchive	Unpack archive files (e.g., tar.gz, zip)
archive	Create archive files

9. Facts & Setup

Gather system information.

Module	Description
setup	Gather facts about the system
ansible_facts	Access facts in playbooks

10. Cloud Modules

Manage cloud resources (via collections):

Cloud	Module Examples
AWS	ec2, s3_bucket, rds (via amazon.aws)
Azure	azure_rm_* modules (via azure.azcollection)
GCP	gcp_* modules (via google.cloud)

11. Others
Module	Description
get_url	Download files from a URL
uri	Interact with web services (HTTP requests)
wait_for	Wait for conditions (e.g., port, file)
pause	Pause execution (prompt/wait)
debug	Print variables or messages
set_fact	Set custom facts (variables)