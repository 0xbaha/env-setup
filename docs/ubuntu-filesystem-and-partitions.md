# Ubuntu FileSystem and Partition

## FileSystem

|FILE SYSTEM|OPERATING SYSTEM|DESCRIPTION|
|:---:|:---:|:---|
|FAT|Legacy|Legacy File System that was universally adopted. Came in 12 FAT12, 16 FAT16, and 32 FAT32.|
|NTFS|Windows|New Tech File System - replaced FAT on Windows systems. It is still needed to read Windows partitions.|
|Ext2|Linux|Second Extended filesystem - used by many Linux distro's.|
|Ext3|Linux|Third Extended filesystem - default choice for Ubuntu distros. Journaling added.|
|Ext4|Linux|Fourth Extended filesystem - used by many Linux distro's. Extends storage limits.|
|JFS|Linux|Journaled File System - was introduced by IBM and is still supported, but has been replaced by Ext4.|
|XFS|Linux/Irix|64-bit option that is mostly supported now as an option in Red Hat.|
|ReiserFS|Linux/SUSE|This was a file format that was in use across several distros but has largely been replaced by Ext3.|

## Partition

Partition and Recommended Size

|PARTITION|SIZE|DESCRIPTION|
|:---:|:---:|:---|
|/| |The slash / alone stands for the root of the filesystem tree.|
|/bin|250 MB|This stands for binaries and contains the fundamental utilities that are needed by all users.|
|/boot|250 MB|This contains all the files that are needed for the booting process.|
|/dev|250 MB|This stands for devices, which contain files for peripheral devices and pseudo devices.|
|/etc|250 MB|This contains configuration files for the system and system databases.|
|/home|[[1]](#notes)|This holds all the home directories for the users.|
|/lib|5 GB|This is the system libraries and has files like the kernel modules and device drivers.|
|/lib64| |This is the system libraries and has files like the kernel modules and device drivers for 64-bit systems.|
|/media|[[2]](#notes)|This is the default mount point for removable devices like USB drives and media players.|
|/mnt|[[3]](#notes)|This stands for a mount and contains filesystem mount points. Used for multiple hard drives, multiple partitions, network filesystems, and CD ROMs and such.|
|/opt|0.5-5 GB|Contains add-on software, larger programs may install here rather than in /usr.|
|/proc| |This contains virtual filesystems describing the processes information as files.|
|/root| |This is the home location for the system administrator root. This accounts home directory is usually the root of the first partition.|
|/sbin|250 MB|This stands for System Binaries and contains the fundamental utilities that are needed to start, maintain, and recover the system.|
|/srv|100 MB|This one is server data which is data for services that are provided by the system.|
|/swap|[[4]](#notes)|The swap partition is where you extend the system memory by dedicating part of the hard drive to it.|
|/sys| |This contains a sysfs virtual filesystem which holds information that is related to the hardware operating system.|
|/tmp|[[5]](#notes)|This is a place for temporary files. tmpfs that is mounted on it or scripts on startup usually clear this at boot.|
|/usr|&gt;20 GB|This holds the executables and shared resources that are not system critical.|
|/var|2 GB|This stands for variable and is a place for files that are in a changeable state. Such as size going up and down.|

### Notes

1. Remaining Free Space after other partitions created or second drive.
2. 8 KB This contains subdirectories for mount points of removable media, such as CDs and USB flash drives.
3. 8 KB This is an empty partition that is used as a mount point for temporary files.
4. Twice as large as the amount of RAM in the PC.
5. Match this to the size of the Swap partition.

## References

1. [The types and definitions of Ubuntu Linux Partitions and Directories Explained](https://www.dell.com/support/kbdoc/en-id/000131456/the-types-and-definitions-of-ubuntu-linux-partitions-and-directories-explained)