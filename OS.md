DAY 1
i setup the vm and install the os
task done : 
    networking changes --> change network adapter from NAT to bridge for ssh
                        make the ip static by changing valid_lft to forever and preferred_lft forever 
        commands run : 
        sudo nmcli con modify enp0s3 ipv4.addresses 192.168.31.56/24  -- assign static ip wth subnet --> 255.255.255.0
        sudo nmcli con modify enp0s3 ipv4.gateway 192.168.31.1 -- default IPv4 gateway for the connection enp0s3 to 192.168.31.1
        sudo nmcli con modify enp0s3 ipv4.dns "192.168.31.1 8.8.8.8" -- Sets the DNS servers for the connection (router google)
        sudo nmcli con modify enp0s3 ipv4.method manual -- dhcp to manual
        sudo nmcli con up enp0s3 -- bring up the new changes
    
    enable root sudo:
    during installation root was locked hence the sudo with it.
    to make above changes sudo was requried hence unlocked the root.
    step 1 
      restart machine adn press `e` at during startup --> grub will open --> eddit the line starting with linux by adding rd.break
      press ctrl+X --> opens emergency shell --> 
      remount root directory
            mount -o remount,rw /sysroot
            chroot /sysroot
      reset password 
            passwd root
      Create an autorelabel file to ensure SELinux labels are fixed on reboot:
            touch /.autorelabel
      exit exit

Day 2:
Setup the SSH keys and wsl

task: 
ssh-keygen --> generates the ssh key for authentication
ssh-copy-id -i <.pub file path> user@IPadderess ~/.ssh (create ~/.ssh if not present)
ssh -i ~/.ssh/redhat_lab sachin@192.168.31.56


Day3: Users and password

in linux passwords are stored in 
/etc/passwd
      --> jane:x:1001:1001:Jane Doe:/home/jane:/bin/bash
      jane : user
      x: password
      1001 --> user uid (
            uid == 0 : root
            uid >0 and uid <1000 : system users
            uid > 1000 : simple users
      )
      1001 --> group gid
      Jane Doe --> fullname or description
      /home/jane --> home directory
      /bin/bash --> default shell      
/etc/shadow
  openssl passwd -6 "user1
  creates hash for the password "user1" random each time and cannot be reverted
  $<id>$<salt>$<hashed_password>
  $6$5.d75mHmaoRHlKkk$GwKTTXjted7EvZbtxp2nsCNCK8vH6.QRWOLHMTIAAOl7fkt9bx/JMKOFb/xzFRbZu47yzvSN3ThiTw/ufxEiI0

/etc/group
 --> group info
/etc/gshadow
 --> group passwords

profile are the basic files every user have

packagemanager and repos
yum, apt are manager and they install repos into /etc/yum.repos.d/<reponame>.repo
which consists of information of repos mantained by the distributer.
these repo consists of .rpm file for redhat just like .exe
which are used to install the binaries or code.

dbf install <software/package name>
dnf search <package>
dnf list installed
dnf list recent
dnf remove <package>



ssh sachin@192.168.31.185
ssh sachin@192.168.31.56

logserver
ping 192.168.31.185

redhat
ping 192.168.31.56


56 --> 185 working
185 --> 56 not working
