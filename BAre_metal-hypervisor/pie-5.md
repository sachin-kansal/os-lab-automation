<H1> Rasberry pie initial setup <H1>


## Network basic
Finding ip on which pie is running

`bash
nmap -sn 192.168.31.0/22
`bash

Make the IP static

``` yaml
network:
  version: 2
  ethernets:
    eth0:
      optional: true
      dhcp4: false
      dhcp6: false
      addresses:
        - 192.168.31.50/24
      routes:
        - to : default
          via: 192.168.31.1
          metric: 100
  wifis:
    wlan0:
      optional: true
      dhcp4: false
      regulatory-domain: "IN"
      addresses:
        - 192.168.31.51/24
      routes:
        - to: default
          via: 192.168.31.1
          metric: 600
      nameservers:
        addresses:
          - 8.8.8.8
          - 1.1.1.1
      access-points:
        "Sachin fiber":
          auth:
            key-management: "psk"
            password: "<wifi-password>"

```

# Storage file system 

## i am adding a toshiba  hdd  to my pie 

to read and write and increase on hdd instead of sd which can wear off.


umount /dev/sda1 2>/dev/null

fdisk /dev/sda1
Welcome to fdisk (util-linux 2.39.3).
Changes will remain in memory only, until you decide to write them.
Be careful before using the write command.


Command (m for help): p
Disk /dev/sda: 298.09 GiB, 320072933376 bytes, 625142448 sectors
Disk model: Tech
Units: sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 4096 bytes
I/O size (minimum/optimal): 4096 bytes / 4096 bytes
Disklabel type: dos
Disk identifier: 0xef7d31bf

Device     Boot Start      End  Sectors  Size Id Type
/dev/sda1        2048 26990591 26988544 12.9G 27 Hidden NTFS WinRE

Command (m for help): d
Selected partition 1
Partition 1 has been deleted.

Command (m for help): n
Partition type
   p   primary (0 primary, 0 extended, 4 free)
   e   extended (container for logical partitions)
Select (default p): p
Partition number (1-4, default 1): 1
First sector (2048-625142447, default 2048):
Last sector, +/-sectors or +/-size{K,M,G,T,P} (2048-625142447, default 625142447):

Created a new partition 1 of type 'Linux' and of size 298.1 GiB.
Partition #1 contains a ntfs signature.

Do you want to remove the signature? [Y]es/[N]o: y

The signature will be removed by a write command.

Command (m for help): w
The partition table has been altered.
Calling ioctl() to re-read partition table.
Syncing disks.



mount /dev/sda1 /srv

mount --bind /srv/libvirt /var/lib/libvirt

