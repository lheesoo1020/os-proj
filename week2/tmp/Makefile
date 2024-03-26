KDIR= /lib/modules/$(shell uname -r)/build
PWD= $(shell pwd)

obj-m := mymodule.o

default: 
	$(MAKE) -C $(KDIR) KBUILD_EXTMOD=$(PWD) modules
clean: 
	rm -rf *~
