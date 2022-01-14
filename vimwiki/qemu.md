##QEMU

```bash
qemu-img create myimage.img 2G
qemu-img create myimage.qcow2 2G -f qcow2
qemu-system-x86_64 -nodisplay -cdrom mycdrom.iso -hda myhd.img
# HW accel (enable KVM in BIOS on Limnux)
qemu -accel hvf

qemu -enable-kvm -cpu host


```
```
QEMU emulator version 6.2.0
Copyright (c) 2003-2021 Fabrice Bellard and the QEMU Project developers
usage: qemu-system-x86_64 [options] [disk_image]

'disk_image' is a raw hard disk image for IDE hard disk 0

Standard options:
-h or -help     display this help and exit
-version        display version information and exit
-machine [type=]name[,prop[=value][,...]]
                selects emulated machine ('-machine help' for list)
                property accel=accel1[:accel2[:...]] selects accelerator
                supported accelerators are kvm, xen, hax, hvf, nvmm, whpx or tcg (default: tcg)
                vmport=on|off|auto controls emulation of vmport (default: auto)
                dump-guest-core=on|off include guest memory in a core dump (default=on)
                mem-merge=on|off controls memory merge support (default: on)
                aes-key-wrap=on|off controls support for AES key wrapping (default=on)
                dea-key-wrap=on|off controls support for DEA key wrapping (default=on)
                suppress-vmdesc=on|off disables self-describing migration (default=off)
                nvdimm=on|off controls NVDIMM support (default=off)
                memory-encryption=@var{} memory encryption object to use (default=none)
                hmat=on|off controls ACPI HMAT support (default=off)
                memory-backend='backend-id' specifies explicitly provided backend for main RAM (default=none)
                sgx-epc.0.memdev=memid
-cpu cpu        select CPU ('-cpu help' for list)
-accel [accel=]accelerator[,prop[=value][,...]]
                select accelerator (kvm, xen, hax, hvf, nvmm, whpx or tcg; use 'help' for a list)
                igd-passthru=on|off (enable Xen integrated Intel graphics passthrough, default=off)
                kernel-irqchip=on|off|split controls accelerated irqchip support (default=on)
                kvm-shadow-mem=size of KVM shadow MMU in bytes
                split-wx=on|off (enable TCG split w^x mapping)
                tb-size=n (TCG translation block cache size)
                dirty-ring-size=n (KVM dirty ring GFN count, default 0)
                thread=single|multi (enable multi-threaded TCG)
-smp [[cpus=]n][,maxcpus=maxcpus][,sockets=sockets][,dies=dies][,cores=cores][,threads=threads]
                set the number of CPUs to 'n' [default=1]
                maxcpus= maximum number of total CPUs, including
                offline CPUs for hotplug, etc
                sockets= number of discrete sockets in the system
                dies= number of CPU dies on one socket (for PC only)
                cores= number of CPU cores on one socket (for PC, it's on one die)
                threads= number of threads on one CPU core
-numa node[,mem=size][,cpus=firstcpu[-lastcpu]][,nodeid=node][,initiator=node]
-numa node[,memdev=id][,cpus=firstcpu[-lastcpu]][,nodeid=node][,initiator=node]
-numa dist,src=source,dst=destination,val=distance
-numa cpu,node-id=node[,socket-id=x][,core-id=y][,thread-id=z]
-numa hmat-lb,initiator=node,target=node,hierarchy=memory|first-level|second-level|third-level,data-type=access-latency|read-latency|write-latency[,latency=lat][,bandwidth=bw]
-numa hmat-cache,node-id=node,size=size,level=level[,associativity=none|direct|complex][,policy=none|write-back|write-through][,line=size]
-add-fd fd=fd,set=set[,opaque=opaque]
                Add 'fd' to fd 'set'
-set group.id.arg=value
                set <arg> parameter for item <id> of type <group>
                i.e. -set drive.$id.file=/path/to/image
-global driver.property=value
-global driver=driver,property=property,value=value
                set a global default for a driver property
-boot [order=drives][,once=drives][,menu=on|off]
      [,splash=sp_name][,splash-time=sp_time][,reboot-timeout=rb_time][,strict=on|off]
                'drives': floppy (a), hard disk (c), CD-ROM (d), network (n)
                'sp_name': the file's name that would be passed to bios as logo picture, if menu=on
                'sp_time': the period that splash picture last if menu=on, unit is ms
                'rb_timeout': the timeout before guest reboot when boot failed, unit is ms
-m [size=]megs[,slots=n,maxmem=size]
                configure guest RAM
                size: initial amount of guest memory
                slots: number of hotplug slots (default: none)
                maxmem: maximum amount of guest memory (default: none)
NOTE: Some architectures might enforce a specific granularity
-mem-path FILE  provide backing storage for guest RAM
-mem-prealloc   preallocate guest memory (use with -mem-path)
-k language     use keyboard layout (for example 'fr' for French)
-audio-help     show -audiodev equivalent of the currently specified audio settings
-audiodev [driver=]driver,id=id[,prop[=value][,...]]
                specifies the audio backend to use
                id= identifier of the backend
                timer-period= timer period in microseconds
                in|out.mixing-engine= use mixing engine to mix streams inside QEMU
                in|out.fixed-settings= use fixed settings for host audio
                in|out.frequency= frequency to use with fixed settings
                in|out.channels= number of channels to use with fixed settings
                in|out.format= sample format to use with fixed settings
                valid values: s8, s16, s32, u8, u16, u32, f32
                in|out.voices= number of voices to use
                in|out.buffer-length= length of buffer in microseconds
-audiodev none,id=id,[,prop[=value][,...]]
                dummy driver that discards all output
-audiodev coreaudio,id=id[,prop[=value][,...]]
                in|out.buffer-count= number of buffers
-audiodev wav,id=id[,prop[=value][,...]]
                path= path of wav file to record
-soundhw c1,... enable audio support
                and only specified sound cards (comma separated list)
                use '-soundhw help' to get the list of supported cards
                use '-soundhw all' to enable all of them
-device driver[,prop[=value][,...]]
                add device (based on driver)
                prop=value,... sets driver properties
                use '-device help' to print all possible drivers
                use '-device driver,help' to print all possible properties
-name string1[,process=string2][,debug-threads=on|off]
                set the name of the guest
                string1 sets the window title and string2 the process name
                When debug-threads is enabled, individual threads are given a separate name
                NOTE: The thread names are for debugging and not a stable API.
-uuid %08x-%04x-%04x-%04x-%012x
                specify machine UUID

Block device options:
-fda/-fdb file  use 'file' as floppy disk 0/1 image
-hda/-hdb file  use 'file' as IDE hard disk 0/1 image
-hdc/-hdd file  use 'file' as IDE hard disk 2/3 image
-cdrom file     use 'file' as IDE cdrom image (cdrom is ide1 master)
-blockdev [driver=]driver[,node-name=N][,discard=ignore|unmap]
          [,cache.direct=on|off][,cache.no-flush=on|off]
          [,read-only=on|off][,auto-read-only=on|off]
          [,force-share=on|off][,detect-zeroes=on|off|unmap]
          [,driver specific parameters...]
                configure a block backend
-drive [file=file][,if=type][,bus=n][,unit=m][,media=d][,index=i]
       [,cache=writethrough|writeback|none|directsync|unsafe][,format=f]
       [,snapshot=on|off][,rerror=ignore|stop|report]
       [,werror=ignore|stop|report|enospc][,id=name]
       [,aio=threads|native|io_uring]
       [,readonly=on|off][,copy-on-read=on|off]
       [,discard=ignore|unmap][,detect-zeroes=on|off|unmap]
       [[,bps=b]|[[,bps_rd=r][,bps_wr=w]]]
       [[,iops=i]|[[,iops_rd=r][,iops_wr=w]]]
       [[,bps_max=bm]|[[,bps_rd_max=rm][,bps_wr_max=wm]]]
       [[,iops_max=im]|[[,iops_rd_max=irm][,iops_wr_max=iwm]]]
       [[,iops_size=is]]
       [[,group=g]]
                use 'file' as a drive image
-mtdblock file  use 'file' as on-board Flash memory image
-sd file        use 'file' as SecureDigital card image
-pflash file    use 'file' as a parallel flash image
-snapshot       write to temporary files instead of disk image files
-fsdev local,id=id,path=path,security_model=mapped-xattr|mapped-file|passthrough|none
 [,writeout=immediate][,readonly=on][,fmode=fmode][,dmode=dmode]
 [[,throttling.bps-total=b]|[[,throttling.bps-read=r][,throttling.bps-write=w]]]
 [[,throttling.iops-total=i]|[[,throttling.iops-read=r][,throttling.iops-write=w]]]
 [[,throttling.bps-total-max=bm]|[[,throttling.bps-read-max=rm][,throttling.bps-write-max=wm]]]
 [[,throttling.iops-total-max=im]|[[,throttling.iops-read-max=irm][,throttling.iops-write-max=iwm]]]
 [[,throttling.iops-size=is]]
-fsdev proxy,id=id,socket=socket[,writeout=immediate][,readonly=on]
-fsdev proxy,id=id,sock_fd=sock_fd[,writeout=immediate][,readonly=on]
-fsdev synth,id=id
-virtfs local,path=path,mount_tag=tag,security_model=mapped-xattr|mapped-file|passthrough|none
        [,id=id][,writeout=immediate][,readonly=on][,fmode=fmode][,dmode=dmode][,multidevs=remap|forbid|warn]
-virtfs proxy,mount_tag=tag,socket=socket[,id=id][,writeout=immediate][,readonly=on]
-virtfs proxy,mount_tag=tag,sock_fd=sock_fd[,id=id][,writeout=immediate][,readonly=on]
-virtfs synth,mount_tag=tag[,id=id][,readonly=on]
-iscsi [user=user][,password=password]
       [,header-digest=CRC32C|CR32C-NONE|NONE-CRC32C|NONE
       [,initiator-name=initiator-iqn][,id=target-iqn]
       [,timeout=timeout]
                iSCSI session parameters

USB convenience options:
-usb            enable on-board USB host controller (if not enabled by default)
-usbdevice name add the host or guest USB device 'name'

Display options:
-display vnc=<display>[,<optargs>]
-display curses[,charset=<encoding>]
-display none
                select display backend type
                The default display is equivalent to
                "-display cocoa"
-nographic      disable graphical output and redirect serial I/Os to console
-curses         shorthand for -display curses
-alt-grab       use Ctrl-Alt-Shift to grab mouse (instead of Ctrl-Alt)
-ctrl-grab      use Right-Ctrl to grab mouse (instead of Ctrl-Alt)
-no-quit        disable SDL/GTK window close capability (deprecated)
-sdl            shorthand for -display sdl
-spice [port=port][,tls-port=secured-port][,x509-dir=<dir>]
       [,x509-key-file=<file>][,x509-key-password=<file>]
       [,x509-cert-file=<file>][,x509-cacert-file=<file>]
       [,x509-dh-key-file=<file>][,addr=addr]
       [,ipv4=on|off][,ipv6=on|off][,unix=on|off]
       [,tls-ciphers=<list>]
       [,tls-channel=[main|display|cursor|inputs|record|playback]]
       [,plaintext-channel=[main|display|cursor|inputs|record|playback]]
       [,sasl=on|off][,disable-ticketing=on|off]
       [,password=<string>][,password-secret=<secret-id>]
       [,image-compression=[auto_glz|auto_lz|quic|glz|lz|off]]
       [,jpeg-wan-compression=[auto|never|always]]
       [,zlib-glz-wan-compression=[auto|never|always]]
       [,streaming-video=[off|all|filter]][,disable-copy-paste=on|off]
       [,disable-agent-file-xfer=on|off][,agent-mouse=[on|off]]
       [,playback-compression=[on|off]][,seamless-migration=[on|off]]
       [,gl=[on|off]][,rendernode=<file>]
   enable spice
   at least one of {port, tls-port} is mandatory
-portrait       rotate graphical output 90 deg left (only PXA LCD)
-rotate <deg>   rotate graphical output some deg left (only PXA LCD)
-vga [std|cirrus|vmware|qxl|xenfb|tcx|cg3|virtio|none]
                select video card type
-full-screen    start in full screen
-vnc <display>  shorthand for -display vnc=<display>

i386 target only:
-win2k-hack     use it when installing Windows 2000 to avoid a disk full bug
-no-fd-bootchk  disable boot signature checking for floppy disks
-no-acpi        disable ACPI
-no-hpet        disable HPET
-acpitable [sig=str][,rev=n][,oem_id=str][,oem_table_id=str][,oem_rev=n][,asl_compiler_id=str][,asl_compiler_rev=n][,{data|file}=file1[:file2]...]
                ACPI table description
-smbios file=binary
                load SMBIOS entry from binary file
-smbios type=0[,vendor=str][,version=str][,date=str][,release=%d.%d]
              [,uefi=on|off]
                specify SMBIOS type 0 fields
-smbios type=1[,manufacturer=str][,product=str][,version=str][,serial=str]
              [,uuid=uuid][,sku=str][,family=str]
                specify SMBIOS type 1 fields
-smbios type=2[,manufacturer=str][,product=str][,version=str][,serial=str]
              [,asset=str][,location=str]
                specify SMBIOS type 2 fields
-smbios type=3[,manufacturer=str][,version=str][,serial=str][,asset=str]
              [,sku=str]
                specify SMBIOS type 3 fields
-smbios type=4[,sock_pfx=str][,manufacturer=str][,version=str][,serial=str]
              [,asset=str][,part=str][,max-speed=%d][,current-speed=%d]
                specify SMBIOS type 4 fields
-smbios type=11[,value=str][,path=filename]
                specify SMBIOS type 11 fields
-smbios type=17[,loc_pfx=str][,bank=str][,manufacturer=str][,serial=str]
               [,asset=str][,part=str][,speed=%d]
                specify SMBIOS type 17 fields
-smbios type=41[,designation=str][,kind=str][,instance=%d][,pcidev=str]
                specify SMBIOS type 41 fields

Network options:
-netdev user,id=str[,ipv4=on|off][,net=addr[/mask]][,host=addr]
         [,ipv6=on|off][,ipv6-net=addr[/int]][,ipv6-host=addr]
         [,restrict=on|off][,hostname=host][,dhcpstart=addr]
         [,dns=addr][,ipv6-dns=addr][,dnssearch=domain][,domainname=domain]
         [,tftp=dir][,tftp-server-name=name][,bootfile=f][,hostfwd=rule][,guestfwd=rule][,smb=dir[,smbserver=addr]]
                configure a user mode network backend with ID 'str',
                its DHCP server and optional services
-netdev tap,id=str[,fd=h][,fds=x:y:...:z][,ifname=name][,script=file][,downscript=dfile]
         [,br=bridge][,helper=helper][,sndbuf=nbytes][,vnet_hdr=on|off][,vhost=on|off]
         [,vhostfd=h][,vhostfds=x:y:...:z][,vhostforce=on|off][,queues=n]
         [,poll-us=n]
                configure a host TAP network backend with ID 'str'
                connected to a bridge (default=br0)
                use network scripts 'file' (default=/usr/local/Cellar/qemu/6.2.0/etc/qemu-ifup)
                to configure it and 'dfile' (default=/usr/local/Cellar/qemu/6.2.0/etc/qemu-ifdown)
                to deconfigure it
                use '[down]script=no' to disable script execution
                use network helper 'helper' (default=/usr/local/Cellar/qemu/6.2.0/libexec/qemu-bridge-helper) to
                configure it
                use 'fd=h' to connect to an already opened TAP interface
                use 'fds=x:y:...:z' to connect to already opened multiqueue capable TAP interfaces
                use 'sndbuf=nbytes' to limit the size of the send buffer (the
                default is disabled 'sndbuf=0' to enable flow control set 'sndbuf=1048576')
                use vnet_hdr=off to avoid enabling the IFF_VNET_HDR tap flag
                use vnet_hdr=on to make the lack of IFF_VNET_HDR support an error condition
                use vhost=on to enable experimental in kernel accelerator
                    (only has effect for virtio guests which use MSIX)
                use vhostforce=on to force vhost on for non-MSIX virtio guests
                use 'vhostfd=h' to connect to an already opened vhost net device
                use 'vhostfds=x:y:...:z to connect to multiple already opened vhost net devices
                use 'queues=n' to specify the number of queues to be created for multiqueue TAP
                use 'poll-us=n' to specify the maximum number of microseconds that could be
                spent on busy polling for vhost net
-netdev bridge,id=str[,br=bridge][,helper=helper]
                configure a host TAP network backend with ID 'str' that is
                connected to a bridge (default=br0)
                using the program 'helper (default=/usr/local/Cellar/qemu/6.2.0/libexec/qemu-bridge-helper)
-netdev socket,id=str[,fd=h][,listen=[host]:port][,connect=host:port]
                configure a network backend to connect to another network
                using a socket connection
-netdev socket,id=str[,fd=h][,mcast=maddr:port[,localaddr=addr]]
                configure a network backend to connect to a multicast maddr and port
                use 'localaddr=addr' to specify the host address to send packets from
-netdev socket,id=str[,fd=h][,udp=host:port][,localaddr=host:port]
                configure a network backend to connect to another network
                using an UDP tunnel
-netdev vde,id=str[,sock=socketpath][,port=n][,group=groupname][,mode=octalmode]
                configure a network backend to connect to port 'n' of a vde switch
                running on host and listening for incoming connections on 'socketpath'.
                Use group 'groupname' and mode 'octalmode' to change default
                ownership and permissions for communication port.
-netdev vhost-user,id=str,chardev=dev[,vhostforce=on|off]
                configure a vhost-user network, backed by a chardev 'dev'
-netdev hubport,id=str,hubid=n[,netdev=nd]
                configure a hub port on the hub with ID 'n'
-nic [tap|bridge|user|vde|vhost-user|socket][,option][,...][mac=macaddr]
                initialize an on-board / default host NIC (using MAC address
                macaddr) and connect it to the given host network backend
-nic none       use it alone to have zero network devices (the default is to
                provided a 'user' network connection)
-net nic[,macaddr=mac][,model=type][,name=str][,addr=str][,vectors=v]
                configure or create an on-board (or machine default) NIC and
                connect it to hub 0 (please use -nic unless you need a hub)
-net [user|tap|bridge|vde|socket][,option][,option][,...]
                old way to initialize a host network interface
                (use the -netdev option if possible instead)

Character device options:
-chardev help
-chardev null,id=id[,mux=on|off][,logfile=PATH][,logappend=on|off]
-chardev socket,id=id[,host=host],port=port[,to=to][,ipv4=on|off][,ipv6=on|off][,nodelay=on|off]
         [,server=on|off][,wait=on|off][,telnet=on|off][,websocket=on|off][,reconnect=seconds][,mux=on|off]
         [,logfile=PATH][,logappend=on|off][,tls-creds=ID][,tls-authz=ID] (tcp)
-chardev socket,id=id,path=path[,server=on|off][,wait=on|off][,telnet=on|off][,websocket=on|off][,reconnect=seconds]
         [,mux=on|off][,logfile=PATH][,logappend=on|off][,abstract=on|off][,tight=on|off] (unix)
-chardev udp,id=id[,host=host],port=port[,localaddr=localaddr]
         [,localport=localport][,ipv4=on|off][,ipv6=on|off][,mux=on|off]
         [,logfile=PATH][,logappend=on|off]
-chardev msmouse,id=id[,mux=on|off][,logfile=PATH][,logappend=on|off]
-chardev vc,id=id[[,width=width][,height=height]][[,cols=cols][,rows=rows]]
         [,mux=on|off][,logfile=PATH][,logappend=on|off]
-chardev ringbuf,id=id[,size=size][,logfile=PATH][,logappend=on|off]
-chardev file,id=id,path=path[,mux=on|off][,logfile=PATH][,logappend=on|off]
-chardev pipe,id=id,path=path[,mux=on|off][,logfile=PATH][,logappend=on|off]
-chardev pty,id=id[,mux=on|off][,logfile=PATH][,logappend=on|off]
-chardev stdio,id=id[,mux=on|off][,signal=on|off][,logfile=PATH][,logappend=on|off]

TPM device options:
-tpmdev passthrough,id=id[,path=path][,cancel-path=path]
                use path to provide path to a character device; default is /dev/tpm0
                use cancel-path to provide path to TPM's cancel sysfs entry; if
                not provided it will be searched for in /sys/class/misc/tpm?/device
-tpmdev emulator,id=id,chardev=dev
                configure the TPM device using chardev backend

Linux/Multiboot boot specific:
-kernel bzImage use 'bzImage' as kernel image
-append cmdline use 'cmdline' as kernel command line
-initrd file    use 'file' as initial ram disk
-dtb    file    use 'file' as device tree image

Debug/Expert options:
-compat [deprecated-input=accept|reject|crash][,deprecated-output=accept|hide]
                Policy for handling deprecated management interfaces
-compat [unstable-input=accept|reject|crash][,unstable-output=accept|hide]
                Policy for handling unstable management interfaces
-fw_cfg [name=]<name>,file=<file>
                add named fw_cfg entry with contents from file
-fw_cfg [name=]<name>,string=<str>
                add named fw_cfg entry with contents from string
-serial dev     redirect the serial port to char device 'dev'
-parallel dev   redirect the parallel port to char device 'dev'
-monitor dev    redirect the monitor to char device 'dev'
-qmp dev        like -monitor but opens in 'control' mode
-qmp-pretty dev like -qmp but uses pretty JSON formatting
-mon [chardev=]name[,mode=readline|control][,pretty[=on|off]]
-debugcon dev   redirect the debug console to char device 'dev'
-pidfile file   write PID to 'file'
-singlestep     always run in singlestep mode
--preconfig     pause QEMU before machine is initialized (experimental)
-S              freeze CPU at startup (use 'c' to start execution)
-overcommit [mem-lock=on|off][cpu-pm=on|off]
                run qemu with overcommit hints
                mem-lock=on|off controls memory lock support (default: off)
                cpu-pm=on|off controls cpu power management (default: off)
-gdb dev        accept gdb connection on 'dev'. (QEMU defaults to starting
                the guest without waiting for gdb to connect; use -S too
                if you want it to not start execution.)
-s              shorthand for -gdb tcp::1234
-d item1,...    enable logging of specified items (use '-d help' for a list of log items)
-D logfile      output log to logfile (default stderr)
-dfilter range,..  filter debug output to range of addresses (useful for -d cpu,exec,etc..)
-seed number       seed the pseudo-random number generator
-L path         set the directory for the BIOS, VGA BIOS and keymaps
-bios file      set the filename for the BIOS
-enable-kvm     enable KVM full virtualization support
-xen-domid id   specify xen guest domain id
-xen-attach     attach to existing xen domain
                libxl will use this when starting QEMU
-xen-domid-restrict     restrict set of available xen operations
                        to specified domain id. (Does not affect
                        xenpv machine type).
-no-reboot      exit instead of rebooting
-no-shutdown    stop before shutdown
-action reboot=reset|shutdown
                   action when guest reboots [default=reset]
-action shutdown=poweroff|pause
                   action when guest shuts down [default=poweroff]
-action panic=pause|shutdown|none
                   action when guest panics [default=shutdown]
-action watchdog=reset|shutdown|poweroff|inject-nmi|pause|debug|none
                   action when watchdog fires [default=reset]
-loadvm [tag|id]
                start right away with a saved state (loadvm in monitor)
-daemonize      daemonize QEMU after initializing
-option-rom rom load a file, rom, into the option ROM space
-rtc [base=utc|localtime|<datetime>][,clock=host|rt|vm][,driftfix=none|slew]
                set the RTC base and clock, enable drift fix for clock ticks (x86 only)
-icount [shift=N|auto][,align=on|off][,sleep=on|off][,rr=record|replay,rrfile=<filename>[,rrsnapshot=<snapshot>]]
                enable virtual instruction counter with 2^N clock ticks per
                instruction, enable aligning the host and virtual clocks
                or disable real time cpu sleeping, and optionally enable
                record-and-replay mode
-watchdog model
                enable virtual hardware watchdog [default=none]
-watchdog-action reset|shutdown|poweroff|inject-nmi|pause|debug|none
                action when watchdog fires [default=reset]
-echr chr       set terminal escape character instead of ctrl-a
-incoming tcp:[host]:port[,to=maxport][,ipv4=on|off][,ipv6=on|off]
-incoming rdma:host:port[,ipv4=on|off][,ipv6=on|off]
-incoming unix:socketpath
                prepare for incoming migration, listen on
                specified protocol and socket address
-incoming fd:fd
-incoming exec:cmdline
                accept incoming migration on given file descriptor
                or from given external command
-incoming defer
                wait for the URI to be specified via migrate_incoming
-only-migratable     allow only migratable devices
-nodefaults     don't create default devices
-chroot dir     chroot to dir just before starting the VM
-runas user     change to user id user just before starting the VM
                user can be numeric uid:gid instead
-sandbox on[,obsolete=allow|deny][,elevateprivileges=allow|deny|children]
          [,spawn=allow|deny][,resourcecontrol=allow|deny]
                Enable seccomp mode 2 system call filter (default 'off').
                use 'obsolete' to allow obsolete system calls that are provided
                    by the kernel, but typically no longer used by modern
                    C library implementations.
                use 'elevateprivileges' to allow or deny the QEMU process ability
                    to elevate privileges using set*uid|gid system calls.
                    The value 'children' will deny set*uid|gid system calls for
                    main QEMU process but will allow forks and execves to run unprivileged
                use 'spawn' to avoid QEMU to spawn new threads or processes by
                     blocking *fork and execve
                use 'resourcecontrol' to disable process affinity and schedular priority
-readconfig <file>
-writeconfig <file>
                read/write config file (deprecated)
-no-user-config
                do not load default user-provided config files at startup
-trace [[enable=]<pattern>][,events=<file>][,file=<file>]
                specify tracing options
-plugin [file=]<file>[,<argname>=<argvalue>]
                load a plugin
-msg [timestamp[=on|off]][,guest-name=[on|off]]
                control error message format
                timestamp=on enables timestamps (default: off)
                guest-name=on enables guest name prefix but only if
                              -name guest option is set (default: off)
-dump-vmstate <file>
                Output vmstate information in JSON format to file.
                Use the scripts/vmstate-static-checker.py file to
                check for possible regressions in migration code
                by comparing two such vmstate dumps.
-enable-sync-profile
                enable synchronization profiling

Generic object creation:
-object TYPENAME[,PROP1=VALUE1,...]
                create a new object of type TYPENAME setting properties
                in the order they are specified.  Note that the 'id'
                property must be set.  These objects are placed in the
                '/objects' path.

During emulation, the following keys are useful:
ctrl-alt-f      toggle full screen
ctrl-alt-n      switch to virtual console 'n'
ctrl-alt        toggle mouse and keyboard grab

When using -nographic, press 'ctrl-a h' to get some help.

See <https://qemu.org/contribute/report-a-bug> for how to report bugs.
More information on the QEMU project at <https://qemu.org>.


qemu-img version 6.2.0
Copyright (c) 2003-2021 Fabrice Bellard and the QEMU Project developers
usage: qemu-img [standard options] command [command options]
QEMU disk image utility

    '-h', '--help'       display this help and exit
    '-V', '--version'    output version information and exit
    '-T', '--trace'      [[enable=]<pattern>][,events=<file>][,file=<file>]
                         specify tracing options

Command syntax:
  amend [--object objectdef] [--image-opts] [-p] [-q] [-f fmt] [-t cache] [--force] -o options filename
  bench [-c count] [-d depth] [-f fmt] [--flush-interval=flush_interval] [-i aio] [-n] [--no-drain] [-o offset] [--pattern=pattern] [-q] [-s buffer_size] [-S step_size] [-t cache] [-w] [-U] filename
  bitmap (--merge SOURCE | --add | --remove | --clear | --enable | --disable)... [-b source_file [-F source_fmt]] [-g granularity] [--object objectdef] [--image-opts | -f fmt] filename bitmap
  check [--object objectdef] [--image-opts] [-q] [-f fmt] [--output=ofmt] [-r [leaks | all]] [-T src_cache] [-U] filename
  commit [--object objectdef] [--image-opts] [-q] [-f fmt] [-t cache] [-b base] [-r rate_limit] [-d] [-p] filename
  compare [--object objectdef] [--image-opts] [-f fmt] [-F fmt] [-T src_cache] [-p] [-q] [-s] [-U] filename1 filename2
  convert [--object objectdef] [--image-opts] [--target-image-opts] [--target-is-zero] [--bitmaps] [-U] [-C] [-c] [-p] [-q] [-n] [-f fmt] [-t cache] [-T src_cache] [-O output_fmt] [-B backing_file [-F backing_fmt]] [-o options] [-l snapshot_param] [-S sparse_size] [-r rate_limit] [-m num_coroutines] [-W] [--salvage] filename [filename2 [...]] output_filename
  create [--object objectdef] [-q] [-f fmt] [-b backing_file] [-F backing_fmt] [-u] [-o options] filename [size]
  dd [--image-opts] [-U] [-f fmt] [-O output_fmt] [bs=block_size] [count=blocks] [skip=blocks] if=input of=output
  info [--object objectdef] [--image-opts] [-f fmt] [--output=ofmt] [--backing-chain] [-U] filename
  map [--object objectdef] [--image-opts] [-f fmt] [--start-offset=offset] [--max-length=len] [--output=ofmt] [-U] filename
  measure [--output=ofmt] [-O output_fmt] [-o options] [--size N | [--object objectdef] [--image-opts] [-f fmt] [-l snapshot_param] filename]
  snapshot [--object objectdef] [--image-opts] [-U] [-q] [-l | -a snapshot | -c snapshot | -d snapshot] filename
  rebase [--object objectdef] [--image-opts] [-U] [-q] [-f fmt] [-t cache] [-T src_cache] [-p] [-u] -b backing_file [-F backing_fmt] filename
  resize [--object objectdef] [--image-opts] [-f fmt] [--preallocation=prealloc] [-q] [--shrink] filename [+ | -]size

Command parameters:
  'filename' is a disk image filename
  'objectdef' is a QEMU user creatable object definition. See the qemu(1)
    manual page for a description of the object properties. The most common
    object type is a 'secret', which is used to supply passwords and/or
    encryption keys.
  'fmt' is the disk image format. It is guessed automatically in most cases
  'cache' is the cache mode used to write the output disk image, the valid
    options are: 'none', 'writeback' (default, except for convert), 'writethrough',
    'directsync' and 'unsafe' (default for convert)
  'src_cache' is the cache mode used to read input disk images, the valid
    options are the same as for the 'cache' option
  'size' is the disk image size in bytes. Optional suffixes
    'k' or 'K' (kilobyte, 1024), 'M' (megabyte, 1024k), 'G' (gigabyte, 1024M),
    'T' (terabyte, 1024G), 'P' (petabyte, 1024T) and 'E' (exabyte, 1024P)  are
    supported. 'b' is ignored.
  'output_filename' is the destination disk image filename
  'output_fmt' is the destination format
  'options' is a comma separated list of format specific options in a
    name=value format. Use -o ? for an overview of the options supported by the
    used format
  'snapshot_param' is param used for internal snapshot, format
    is 'snapshot.id=[ID],snapshot.name=[NAME]', or
    '[ID_OR_NAME]'
  '-c' indicates that target image must be compressed (qcow format only)
  '-u' allows unsafe backing chains. For rebasing, it is assumed that old and
       new backing file match exactly. The image doesn't need a working
       backing file before rebasing in this case (useful for renaming the
       backing file). For image creation, allow creating without attempting
       to open the backing file.
  '-h' with or without a command shows this help and lists the supported formats
  '-p' show progress of command (only certain commands)
  '-q' use Quiet mode - do not print any output (except errors)
  '-S' indicates the consecutive number of bytes (defaults to 4k) that must
       contain only zeros for qemu-img to create a sparse image during
       conversion. If the number of bytes is 0, the source will not be scanned for
       unallocated or zero sectors, and the destination image will always be
       fully allocated
  '--output' takes the format in which the output must be done (human or json)
  '-n' skips the target volume creation (useful if the volume is created
       prior to running qemu-img)

Parameters to bitmap subcommand:
  'bitmap' is the name of the bitmap to manipulate, through one or more
       actions from '--add', '--remove', '--clear', '--enable', '--disable',
       or '--merge source'
  '-g granularity' sets the granularity for '--add' actions
  '-b source' and '-F src_fmt' tell '--merge' actions to find the source
       bitmaps from an alternative file

Parameters to check subcommand:
  '-r' tries to repair any inconsistencies that are found during the check.
       '-r leaks' repairs only cluster leaks, whereas '-r all' fixes all
       kinds of errors, with a higher risk of choosing the wrong fix or
       hiding corruption that has already occurred.

Parameters to convert subcommand:
  '--bitmaps' copies all top-level persistent bitmaps to destination
  '-m' specifies how many coroutines work in parallel during the convert
       process (defaults to 8)
  '-W' allow to write to the target out of order rather than sequential

Parameters to snapshot subcommand:
  'snapshot' is the name of the snapshot to create, apply or delete
  '-a' applies a snapshot (revert disk to saved state)
  '-c' creates a snapshot
  '-d' deletes a snapshot
  '-l' lists all snapshots in the given image

Parameters to compare subcommand:
  '-f' first image format
  '-F' second image format
  '-s' run in Strict mode - fail on different image size or sector allocation

Parameters to dd subcommand:
  'bs=BYTES' read and write up to BYTES bytes at a time (default: 512)
  'count=N' copy only N input blocks
  'if=FILE' read from FILE
  'of=FILE' write to FILE
  'skip=N' skip N bs-sized blocks at the start of input

Supported formats: blkdebug blklogwrites blkverify bochs cloop compress copy-before-write copy-on-read dmg file ftp ftps host_device http https luks nbd null-aio null-co parallels preallocate qcow qcow2 qed quorum raw replication ssh throttle vdi vhdx vmdk vpc vvfat

See <https://qemu.org/contribute/report-a-bug> for how to report bugs.
More information on the QEMU project at <https://qemu.org>.
```
