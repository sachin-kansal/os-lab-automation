# File system hardening

linux systems come with many modules attached on kernel level. can be checked at
cd /usr/lib/modules/<kernel release>/kernel/fs/

modprobe cmd utility is used for managing these
at boot level /etc/modprobe.d/*.conf file are read and applied 

blacklisting and asking to run /bin/false at startup is best practice to secure it.

sample:
    cat cramfs.conf 
        blacklist cramfs --> blacklist cramfs 
        install cramfs /bin/false --> run /bin/false

modprobe -r udf 2>/dev/null; rmmod udf 2>/dev/null
modprobe -n -v squashfs --  to verify
rmmod udf

why disable unwanted filesystem ??
Many attackers can add malacious script in these paths and run them at boot up.

afs - CVE-2022-37402 
ceph - CVE-2022-0670 
cifs - CVE-2022-29869 
exfat CVE-2022-29973 
ext CVE-2022-1184 
fat CVE-2022-22043 
fscache CVE-2022-3630 
fuse CVE-2023-0386 
gfs2 CVE-2023-3212 
nfs_common CVE-2023-6660 
nfsd CVE-2022-43945 
smbfs_common CVE-2022-2585
cramfs
freevxfs
hfs
hfsplus
jffs2
squashfs
udf
usb-storage

cramfs.conf  firewalld-sysctls.conf  freevxfs.conf  hfs.conf  hfsplus.conf  jffs2.conf  squashfs.conf  udf.conf  usb-storage.conf

squashfs
udf



# Re-partitioning the linux system can be further secured by segragating the system file from user files



tmpfs put all the data in virtual cache, it is the ram space.
get emptied on reboot
live completely on swap 
pages are shown as shared uisng command `free` or as shmem in `/proc/meminfo`

free
cat /proc/meminfo

tmpfs has 3 mount option size, nr_blocks, nr_inodes

/tmp and /dev/shm 
these 2 should be mounted on tmpfs granting 50% of size limit
noexec, nodev, nosuid, seclabel(/dev/shm), relatime, size=50%

entry to be updated on /etc/fstab for auto configure during reboot.

mount -t tmpfs -o rw,nosuid,nodev,noexec,relatime,size=50%,seclabel tmpfs /dev/shm

tmpfs /dev/shm tmpfs          rw,nosuid,nodev,noexec,relatime,seclabel,size=50% 0 0
mount -a
reboot

 mount -o remount /home
 lsblk
 vgs
 free -h

fdisk /dev/sdb
blkid /dev/sdb1
sed -i.bak 's|^/dev/sdb1[[:space:]]\+/home|UUID=4f9c0385-56cb-4f91-b249-33b9b6ac2de0 /home|' /etc/fstab

mkfs.xfs /dev/sdc1 -L var
mkfs.xfs /dev/sdc2 -L varlog
mkfs.xfs /dev/sdc3 -L varlogaudit
mkfs.ext4 /dev/sdc4 -L vartmp


cat <<EOF>> /etc/fstab
LABEL=var /var xfs defaults,nodev,nosuid 0 0
LABEL=varlog /var/log xfs defaults,nodev,nosuid,noexec 0 0
LABEL=varlogaudit /var/log/audit xfs defaults,nodev,nosuid,noexec 0 0
LABEL=vartmp /var/tmp ext4 defaults,nodev,nosuid,noexec 0 0
EOF


## DNF and package management 
All the dnf and yum repo's gpg key must be valid and pointing to a link
gpgcheck should be enabled on all

cat <<EOF>> /etc/dnf/dnf.conf
repo_gpgcheck=1
EOF

cat <<EOF>> /etc/sysctl.conf 
kernel.yama.ptrace_scope = 1
EOF

sed -i 's/^ProcessSizeMax=.*/ProcessSizeMax=0/' ./coredump.conf
sed -i 's/^#Storage=.*/Storage=none/' ./coredump.conf


sudo tee /etc/issue > /dev/null <<'EOF'
###########################################################
#           WELCOME TO OS LAB HARDENING MACHINE          #
#          Red Hat Enterprise Linux 9 - Secure           #
#       Authorized Access Only. All activity logged.     #
###########################################################
EOF

sudo tee /etc/issue.net > /dev/null <<'EOF'
###########################################################
#           WELCOME TO OS LAB HARDENING MACHINE          #
#          Red Hat Enterprise Linux 9 - Secure           #
#       Authorized Access Only. All activity logged.     #
###########################################################
EOF

sed -i '/#Banner[[:space:]]none/Banner[[:space:]]/\etc/\issue.net'

cat <<EOF>> /etc/modprobe.d/dccp.conf
blacklist dccp
install dccp /bin/false
EOF

cat <<EOF>> /etc/modprobe.d/dccp.conf
blacklist dccp
install dccp /bin/false
EOF

cat <<EOF>> /etc/modprobe.d/tipc.conf
blacklist tipc
install tipc /bin/false
EOF

cat <<EOF>> /etc/modprobe.d/rds.conf
blacklist rds
install rds /bin/false
EOF


cat <<EOF>> /etc/modprobe.d/sctp.conf
blacklist sctp
install sctp /bin/false
EOF


cat <<EOF>> /etc/sysctl.d/99-sysctl.conf
net.ipv4.conf.default.send_redirects = 0
net.ipv4.conf.all.send_redirects = 0
EOF

net.ipv4.route.flush=1

cat <<EOF>> /etc/sysctl.d/99-sysctl.conf
net.ipv4.conf.all.accept_redirects = 0 
net.ipv4.conf.default.accept_redirects = 0 
net.ipv6.conf.all.accept_redirects = 0 
net.ipv6.conf.default.accept_redirects = 0
EOF

cat <<EOF>> /etc/sysctl.d/99-sysctl.conf
net.ipv4.conf.all.secure_redirects = 0 
net.ipv4.conf.default.secure_redirects = 0 
EOF

cat <<EOF>> /etc/sysctl.d/99-sysctl.conf
net.ipv4.conf.all.rp_filter = 1 
EOF

cat <<EOF>> /etc/sysctl.d/99-sysctl.conf
net.ipv4.conf.all.log_martians = 1
net.ipv4.conf.default.log_martians = 1
EOF

cat <<EOF>> /etc/sysctl.d/99-sysctl.conf
net.ipv6.conf.all.accept_ra = 0 
net.ipv6.conf.default.accept_ra = 0
EOF

## crypro policies check alwasy enable FIPS
awk -F= '($1~/(hash|sign)/ && $2~/SHA1/ && $2!~/^\s*\-
\s*([^#\n\r]+)?SHA1/){print}' /etc/crypto-policies/state/CURRENT.pol 
Nothing should be returned 
Run the following command to verify that sha1_in_certs = 0 (disabled): 
# grep -Psi -- '^\h*sha1_in_certs\h*=\h*' /etc/crypto-
policies/state/CURRENT.pol 
 
sha1_in_certs = 0 

sudo sed -i 's/^\(net.ipv4.conf.all.log_martians\s*=\s*\)0/\11/' /etc/sysctl.d/99-sysctl.conf
sudo sed -i 's/^\(net.ipv4.conf.default.log_martians\s*=\s*\)0/\11/' /etc/sysctl.d/99-sysctl.conf


sudo oscap xccdf eval \
  --profile xccdf_org.ssgproject.content_profile_cis \
  --results cis_results.xml \
  --report cis_report.html \
  /usr/share/xml/scap/ssg/content/ssg-rhel9-ds.xml

scp sachin@192.168.31.56:/root/cis_report.html ./report_5.html

### host based Firewall 

cat <<EOF>> /etc/firewalld/zones/securezone.xml
<?xml version="1.0" encoding="utf-8"?>
<zone target="DROP">
  <short>Secure Zone</short>
  <description>
    CIS Linux Benchmark-compliant secure zone.
    Default action: DROP all incoming traffic.
    Only explicitly allowed services (SSH, ELK, Nginx, DHCPv6) are permitted.
  </description>

  <!-- Allowed Services -->
  <service name="ssh"/>
  <service name="dhcpv6-client"/>
  <service name="http"/>     <!-- Nginx HTTP -->
  <service name="https"/>    <!-- Nginx HTTPS -->
  
  <!-- ELK Stack Ports -->
  <port port="5601" protocol="tcp"/>   <!-- Kibana -->
  <port port="9200" protocol="tcp"/>   <!-- Elasticsearch -->
  <port port="5044" protocol="tcp"/>   <!-- Logstash Beats input -->

  <!-- Block certain ICMP types for added security -->
  <icmp-block name="destination-unreachable"/>
  <icmp-block name="packet-too-big"/>
  <icmp-block name="time-exceeded"/>
  <icmp-block name="parameter-problem"/>
  <icmp-block name="neighbour-advertisement"/>
  <icmp-block name="neighbour-solicitation"/>
  <icmp-block name="router-advertisement"/>
  <icmp-block name="router-solicitation"/>

  <!-- Protect loopback addresses (localhost spoofing protection) -->
  <rule family="ipv4">
    <source address="127.0.0.1"/>
    <destination address="127.0.0.1" invert="True"/>
    <drop/>
  </rule>
  <rule family="ipv6">
    <source address="::1"/>
    <destination address="::1" invert="True"/>
    <drop/>
  </rule>

  <icmp-block-inversion/>
</zone>
EOF

firewall-cmd --permanent --zone=securezone --change-interface=enp0s3

firewall-cmd --list-all --zone="$(firewall-cmd --list-all | awk '/\(active\)/ { print $1 }')" | grep -P -- '^\h*(services:|ports:)'



sshd -T | grep -Pi -- '^ciphers\h+\"?([^#\n\r]+,)?((3des|blowfish|cast128|aes(128|192|256))-cbc|arcfour(128|256)?|rijndael-cbc@lysator\.liu\.se|chacha20-poly1305@openssh\.com)\b' 

sshd -T | grep -Pi -- 'kexalgorithms\h+([^#\n\r]+,)?(diffie-hellman-group1-sha1|diffie-hellman-group14-sha1|diffie-hellman-group-exchange-sha1)\b'

sshd -T | grep -Pi -- 'macs\h+([^#\n\r]+,)?(hmac-md5|hmac-md5-96|hmac-ripemd160|hmac-sha1-96|umac-64@openssh\.com|hmac-md5-etm@openssh\.com|hmac-md5-96-etm@openssh\.com|hmac-ripemd160-etm@openssh\.com|hmac-sha1-96-etm@openssh\.com|umac-64-etm@openssh\.com|umac-128-etm@openssh\.com)\b'


cat <<EOF>> /etc/ssh/sshd_config
AllowUsers sachin
EOF

cat <<EOF>> /etc/ssh/sshd_config
ClientAliveInterval 60
ClientAliveCountMax 3
EOF
cat <<EOF>> /etc/ssh/sshd_config
DisableForwarding yes
EOF

cat <<EOF>> /etc/ssh/sshd_config
GSSAPIAuthentication no
EOF

cat <<EOF>> /etc/ssh/sshd_config
LoginGraceTime 60 
EOF

cat <<EOF>> /etc/ssh/sshd_config
MaxStartups 10:30:60
EOF

cat <<EOF>> /etc/ssh/sshd_config
PermitRootLogin no
EOF

sudo sed -i 's/^\(GSSAPIAuthentication[[:space:]]\+\)yes/\1no/' /etc/ssh/sshd_config.d/50-redhat.conf



subscription-manager register --username sachinkansal --password fAT8h_.6w3hAUq8