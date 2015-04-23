#Makefile 

.PHONY		: ept-get help
.DEFAULT	: all

all		: ept-get

ept-get		: ept-get.pas args.pas unixtools.pas
		fpc ept-get.pas

help            :
		@echo "usage:";
		@echo "make all         compile"
		@echo "make clean       clean"
		@echo "make help        help"

clean           :
		rm *.o
		rm *.ppu
install		:
		cp ept-get /usr/bin/
uninstall	:
		rm /usr/bin/ept-get
		

