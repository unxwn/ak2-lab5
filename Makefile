# normal makefile
KDIR ?= /lib/modules/`uname -r`/build

default:
	$(MAKE) -C $(KDIR) M=$$PWD

clean:
	$(MAKE) -C $(KDIR) M=$$PWD clean
	rm -f *.o *.ko *.mod.* *.order *.symvers .*.cmd

.PHONY: default clean
