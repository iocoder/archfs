# ArchFS: (Arch) Linux (F)rom (S)cratch

Arch Linux is cool, but it uses systemd. In this tutorial, I will show
how to install Arch Linux from scratch - a very clean setup with pacman
used as a package manager, and without systemd.


[See my video here (English subtitles provided)](https://www.youtube.com/watch?v=_TvaIUD2K2Y?hl=en&cc_lang_pref=en&cc=1):

[![How to build Linux from scratch](http://img.youtube.com/vi/_TvaIUD2K2Y/0.jpg)](https://www.youtube.com/watch?v=_TvaIUD2K2Y?hl=en&cc_lang_pref=en&cc=1)


## 1. Download Arch Linux Live Disk

You need a live cd-rom to continue.

Boot up the system and expand the live image:
```
$ mount -o remount,size=8G /run/archiso/cowspace
```

Execute wifi-menu to connect to wifi
```
$ wifi-menu
```

Now you need to choose a mirror for the live pacman
```
$ vim /etc/pacman.d/mirrorlist
```

Next, update the live system's repository database
```
$ pacman -Sy
```

Now you need to install packages that we will need later on for the 
live system:
```
$ pacman -S git fakeroot binutils
```

Finally, make a clone of our archfs repo:
```
$ git clone https://github.com/iocoder/archfs
```

Open the README file in your terminal
```
$ cd archfs
$ vim README.md
```

You can use ALT+F1 and ALT+F2 to switch between vtty1 and vtty2 so that
you can follow the instructions and at the same time you execute them
on vtty2's console.

Press ALT+F2 to switch to vtty2. Type `root` and press Enter in order
to login. Now press ALT+F1 again to return to vtty1. Now you can continue 
reading section 2 from your live system's vtty1, and executing
the commands by switching to vtty2.

## 2. Create System Partition

Use the live cd-rom to create an ext4fs partition for the new
system:

- BIOS System Partition
- UEFI System Partition
- Linux swap partition
- Linux system
- ...
- Linux /home partion

You can use `gdisk` command if your disk is not partitioned yet. You also need
to install filesystem to any unformatted partitions.

## 3. Mount the target system

```
$ mount /dev/sda4 /mnt
```

```
$ mkdir /mnt/boot
$ mkdir /mnt/tmp
$ mkdir /mnt/run
$ mkdir /mnt/dev
$ mkdir /mnt/sys
$ mkdir /mnt/proc 
$ mkdir /mnt/home
```

```
$ mount /dev/sda2 /mnt/boot
$ mount /dev/sda8 /mnt/home
$ swapon /dev/sda3
```

```
$ mount --bind /tmp /mnt/tmp
$ mount --bind /run /mnt/run
$ mount --bind /dev /mnt/dev
$ mount --bind /sys /mnt/sys
$ mount --bind /proc /mnt/proc
$ mount --bind /sys/firmware/efi/efivars /mnt/sys/firmware/efi/efivars
```

## 4. Install pacman database

```
$ mkdir -p /mnt/var/lib/pacman
$ pacman -Sy -r /mnt
```

## 5. Install pseudo systemd

### Pseudo systemd
```
$ cd /tmp
$ mkdir systemd
$ chmod a+rw systemd
$ cd systemd
$ vim PKGBUILD
pkgname=('systemd' 'systemd-libs' 'libsystemd' 'systemd-resolvconf' 'systemd-sysvcompat')
pkgver=500.0
pkgrel=1
arch=('any')
package_systemd() {
    echo;
}
package_systemd-libs() {
    echo;
}
package_libsystemd() {
    echo;
}
package_systemd-resolvconf() {
    echo;
}
package_systemd-sysvcompat() {
    echo;
}
$ su -s /bin/bash nobody makepkg
$ pacman -Ur /mnt *.xz
$ cp *.xz /mnt/var/lib/pacman/
$ cd ~
```

### Libsystemd.so

```
$ mkdir -p /mnt/usr/lib
$ cd /mnt/usr/lib
$ cp /usr/lib/libsystemd.so.0.*.0 .
$ ln -sv libsystemd.so.0.*.0 libsystemd.so.0
$ ln -sv libsystemd.so.0 libsystemd.so
$ cd ~
```

## 6. Install the base system

BTW, while you are installing these packages (below), you can pause at
any time and chroot to /mnt to see the fruits of your labor.

### Filesystem tree
```
$ pacman -Sr /mnt iana-etc
$ pacman -Sr /mnt tzdata
$ pacman -Sr /mnt filesystem
```

### C library
```
$ pacman -Sr /mnt linux-api-headers
$ pacman -Sr /mnt glibc
$ pacman -Sr /mnt gcc-libs
```

### Shell
```
$ pacman -Sr /mnt ncurses
$ pacman -Sr /mnt readline
$ pacman -Sr /mnt bash
```

### POSIX capabilities
```
$ pacman -Sr /mnt attr
$ pacman -Sr /mnt acl
$ pacman -Sr /mnt libcap
$ pacman -Sr /mnt libcap-ng
```

### Perl language
```
$ pacman -Sr /mnt db
$ pacman -Sr /mnt gdbm
$ pacman -Sr /mnt perl
```

### Filesystem
```
$ pacman -Sr /mnt libutil-linux
$ pacman -Sr /mnt e2fsprogs
$ pacman -Sr /mnt dosfstools
```

### Crypto
```
$ pacman -Sr /mnt gmp
$ pacman -Sr /mnt openssl
$ pacman -Sr /mnt openssl-1.0
$ pacman -Sr /mnt libsasl
$ pacman -Sr /mnt libgpg-error
$ pacman -Sr /mnt libgcrypt
$ pacman -Sr /mnt nettle
```

### Compression
```
$ pacman -Sr /mnt zlib
$ pacman -Sr /mnt bzip2
$ pacman -Sr /mnt lz4
$ pacman -Sr /mnt xz
$ pacman -Sr /mnt pcre
$ pacman -Sr /mnt pcre2
$ pacman -Sr /mnt less
$ pacman -Sr /mnt gzip
$ pacman -Sr /mnt zip
```

## Archiving
```
$ pacman -Sr /mnt expat
$ pacman -Sr /mnt tar
$ pacman -Sr /mnt zstd
$ pacman -Sr /mnt libarchive
$ pacman -Sr /mnt cpio
```

### Coreutils
```
$ pacman -Sr /mnt coreutils
$ pacman -Sr /mnt findutils
```

### Binutils
```
$ pacman -Sr /mnt libelf
$ pacman -Sr /mnt binutils
```

### Glib2
```
$ pacman -Sr /mnt libffi
$ pacman -Sr /mnt glib2
```

### Text processing
```
$ pacman -Sr /mnt mpfr
$ pacman -Sr /mnt gawk
$ pacman -Sr /mnt grep
$ pacman -Sr /mnt sed
```

### Passwords
```
$ pacman -Sr /mnt keyutils
$ pacman -Sr /mnt cracklib
```

### Kerberos
```
$ pacman -Sr /mnt libldap
$ pacman -Sr /mnt krb5
$ pacman -Sr /mnt libtirpc
$ pacman -Sr /mnt libnsl
```

### User management
```
$ pacman -Sr /mnt pambase
$ pacman -Sr /mnt pam
$ pacman -Sr /mnt shadow
```

### More utility commands
```
$ pacman -Sr /mnt util-linux
$ pacman -Sr /mnt diffutils
$ pacman -Sr /mnt patch
$ pacman -Sr /mnt procps
$ pacman -Sr /mnt psmisc
$ pacman -Sr /mnt sudo
```

### Sqlite
```
$ pacman -Sr /mnt sqlite
$ pacman -Sr /mnt yajl
```

### PKCS modules
```
$ pacman -Sr /mnt libtasn1
$ pacman -Sr /mnt p11-kit
```

### Certificates
```
$ pacman -Sr /mnt ca-certificates-utils
$ pacman -Sr /mnt ca-certificates-mozilla
$ pacman -Sr /mnt ca-certificates
```

### Internationalization
```
$ pacman -Sr /mnt perl-xml-parser
$ pacman -Sr /mnt libunistring
$ pacman -Sr /mnt intltool
$ pacman -Sr /mnt icu
$ pacman -Sr /mnt libxml2
$ pacman -Sr /mnt libcroco
$ pacman -Sr /mnt gettext
```

### Domain Names
```
$ pacman -Sr /mnt libidn
$ pacman -Sr /mnt libidn2
$ pacman -Sr /mnt libpsl
```

### Web fetching
```
$ pacman -Sr /mnt libssh2
$ pacman -Sr /mnt libnghttp2
$ pacman -Sr /mnt curl
```

### GNU TLS
```
$ pacman -Sr /mnt gnutls
```

### Assuan Protocol
```
$ pacman -Sr /mnt libassuan
$ pacman -Sr /mnt libsecret
$ pacman -Sr /mnt pinentry
```

### GNU PG
```
$ pacman -Sr /mnt libksba
$ pacman -Sr /mnt npth
$ pacman -Sr /mnt gnupg
$ pacman -Sr /mnt gpgme
```

### Pacman
```
$ pacman -Sr /mnt fakeroot
$ pacman -Sr /mnt archlinux-keyring
$ pacman -Sr /mnt pacman-mirrorlist
$ pacman -Sr /mnt pacman
$ pacman -Sr /mnt arch-install-scripts
```

### Text Editor
```
$ pacman -Sr /mnt file
$ pacman -Sr /mnt nano
$ pacman -Sr /mnt gpm
$ pacman -Sr /mnt vim-runtime
$ pacman -Sr /mnt vim
```

### Message passing
```
$ pacman -Sr /mnt audit
$ pacman -Sr /mnt dbus
```

### USB
```
$ pacman -Sr /mnt hwids
$ pacman -Sr /mnt libusb
$ pacman -Sr /mnt usbutils
```

### PCI
```
$ pacman -Sr /mnt kbd 
$ pacman -Sr /mnt kmod
$ pacman -Sr /mnt pciutils
```

### Packet capturing
```
$ pacman -Sr /mnt libnl
$ pacman -Sr /mnt libpcap
```

### Routing
```
$ pacman -Sr /mnt libmnl
$ pacman -Sr /mnt libnftnl
$ pacman -Sr /mnt libnfnetlink
$ pacman -Sr /mnt libnetfilter_conntrack
$ pacman -Sr /mnt iptables
$ pacman -Sr /mnt iproute2
```

### Network tools
```
$ pacman -Sr /mnt iputils
$ pacman -Sr /mnt inetutils
$ pacman -Sr /mnt net-tools
$ pacman -Sr /mnt wpa_supplicant
```

### ssh
```
$ pacman -Sr /mnt dnssec-anchors
$ pacman -Sr /mnt ldns
$ pacman -Sr /mnt libedit
$ pacman -Sr /mnt openssh
```

### Internet
```
$ pacman -Sr /mnt dhclient
$ pacman -Sr /mnt wget
$ pacman -Sr /mnt lynx
$ pacman -Sr /mnt lighttpd
```

### GNU Package Conf tools
```
$ pacman -Sr /mnt m4
$ pacman -Sr /mnt autoconf 
$ pacman -Sr /mnt automake 
$ pacman -Sr /mnt pkg-config 
$ pacman -Sr /mnt libtool
$ pacman -Sr /mnt which
```

### C/C++ Compiler
```
$ pacman -Sr /mnt libmpc
$ pacman -Sr /mnt gcc
$ pacman -Sr /mnt libatomic_ops
$ pacman -Sr /mnt gc
```

### Make utility
```
$ pacman -Sr /mnt texinfo
$ pacman -Sr /mnt guile
$ pacman -Sr /mnt make
```

### Python
```
$ pacman -Sr /mnt python2
$ pacman -Sr /mnt python3
$ pacman -Sr /mnt python2-pip
$ pacman -Sr /mnt python-pip
```

### Ruby
```
$ pacman -Sr /mnt libyaml
$ pacman -Sr /mnt ruby rubygems
```

### NetworkManager
```
$ pacman -Sr /mnt networkmanager
```

### Firewall
```
$ pacman -Sr /mnt ufw
```

### Git
```
$ pacman -Sr /mnt git
```

### ALSA
```
$ pacman -Sr /mnt moc alsaplayer alsa-tools alsa-utils alsa-firmware
```

## 7. Chrooting to the installed system

### Chroot
```
$ chroot /mnt /usr/bin/bash
```

### Connect to the internet in chroot'd env
```
$ vim /etc/resolv.conf
nameserver 8.8.8.8
```

### Generate locale
```
$ vim /etc/locale.gen
$ locale-gen
```

### Time
```
$ ln -sf /usr/share/zoneinfo/Canada/Eastern /etc/localtime
```

### Host name
```
$ echo archfs > /etc/hostname
```

### Initialize pacman
```
$ vim /etc/pacman.d/mirrorlist
$ pacman-key --init
$ pacman-key --populate archlinux
```
### Add system groups
```
$ groupadd users
$ groupadd tty
$ groupadd uucp
$ groupadd kmem
$ groupadd input
$ groupadd audio
$ groupadd video
$ groupadd storage
$ groupadd disk
$ groupadd optical
$ groupadd network
$ groupadd rfkill
$ groupadd lp
```

### Add system users
```
$ useradd avahi
$ useradd polkitd
$ useradd colord
$ useradd nobody
$ useradd http
```

### Create login user
```
$ useradd -s /bin/bash -d /home/iocoder -m iocoder
$ passwd root
$ passwd iocoder
$ chmod +w /etc/sudoers
$ vim /etc/sudoers
```

### Add login user to system groups
```
$ usermod -a -G tty iocoder
$ usermod -a -G input iocoder
$ usermod -a -G audio iocoder
$ usermod -a -G video iocoder
$ usermod -a -G storage iocoder
$ usermod -a -G disk iocoder
$ usermod -a -G optical iocoder
$ usermod -a -G network iocoder
$ usermod -a -G lp iocoder
```

### Switch to the new user
```
$ su iocoder
$ cd ~
$ sudo su
$ exit
```

### Install package-query (for yaourt)
```
$ wget https://aur.archlinux.org/cgit/aur.git/snapshot/package-query.tar.gz
$ tar -xzf package-query.tar.gz
$ cd package-query
$ makepkg
$ sudo pacman -U package-query*.xz
$ cd ..
$ rm -rf package-query*
```

### Install yaourt
```
$ wget https://aur.archlinux.org/cgit/aur.git/snapshot/yaourt.tar.gz
$ tar -xzf yaourt.tar.gz
$ cd yaourt
$ makepkg
$ sudo pacman -U yaourt*.xz
$ cd ..
$ rm -rf yaourt*
```

### Now use yaourt to install eudev
```
$ yaourt eudev
```

### Generate fstab
```
$ sudo su
$ genfstab / > /etc/fstab
$ cat /etc/fstab
$ exit
```

### Procps-ng-nosystemd
```
$ yaourt procps-ng-nosystemd
```

### Dbus-nosystemd:
```
$ yaourt dbus-nosystemd # edit PKGBUILD to remove git commit
$ sudo su
$ dbus-uuidgen > /etc/machine-id
$ exit
```

## cups-nosystemd:
```
$ yaourt cups-nosystemd
$ sudo su
$ vim /etc/nsswitch.conf
hosts: ... mdns_minimal [NOTFOUND=return] resolve [!UNAVAIL=return] dns ...
$ exit
```

## Configure ssh:
```
$ sudo su
$ ssh-keygen -t rsa -f /etc/ssh/ssh_host_rsa_key
$ ssh-keygen -t ecdsa -f /etc/ssh/ssh_host_ecdsa_key
$ ssh-keygen -t ed25519 -f /etc/ssh/ssh_host_ed25519_key
$ chmod 0600 /etc/ssh/ssh_host_rsa_key
$ chmod 0600 /etc/ssh/ssh_host_ecdsa_key
$ chmod 0600 /etc/ssh/ssh_host_ed25519_key
$ exit
```

## Configure http
```
$ sudo su
$ chown http /var/log/lighttpd
$ chown http /srv/http
$ exit
```

## 8. Install the kernel!

### Install mkinitcpio
```
$ sudo pacman -S mkinitcpio-busybox
$ sudo pacman -S mkinitcpio
```

### Install linux
```
$ sudo pacman -S linux-firmware
$ sudo pacman -S linux
$ sudo pacman -S linux-headers
```

### Install the init script (or create your own if you like)
```
$ git clone https://github.com/iocoder/archfs
$ cd archfs
$ sudo cp init /usr/bin
$ sudo cp lastmins /usr/bin
$ sudo cp reboot /usr/bin
$ sudo cp respawn /usr/bin
$ sudo cp shutdown /usr/bin
$ sudo cp uptime2 /usr/bin
$ cd ..
```

## 9. Install the bootloader

If your firmware supports UEFI standard, you can simply use "efibootmgr"
to add an entry to your NVRAM for the kernel (vmlinuz-linux), with 
`initrd=initramfs-linux.img root=/dev/sda4 rw` as command line.

```
$ sudo pacman -S efivar efibootmgr
$ sudo efibootmgr -d /dev/sda -p 2 -c -L "Arch Linux" -l /vmlinuz-linux \
                  -u 'root=/dev/sda4 rw initrd=\initramfs-linux.img'
```

If you are using virtualbox, you need to use startup.nsh because
the nvram of virtualbox is non-persistent:

```
$ sudo su
$ echo 'vmlinuz-linux root=/dev/sda4 rw initrd=\initramfs-linux.img' > /boot/startup.nsh
$ exit
```

## 10. Virtualization
```
$ sudo pacman -S virtualbox
$ sudo pacman -S qemu
```

## 11. Reboot ^_^
```
$ exit
$ exit
$ reboot
```

### ENJOY YOUR SYSTEM!
