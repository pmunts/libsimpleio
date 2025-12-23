# Makefile to build the Linux Simple I/O Library

# Copyright (C)2016-2025, Philip Munts dba Munts Technologies.
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions are met:
#
# * Redistributions of source code must retain the above copyright notice,
#   this list of conditions and the following disclaimer.
#
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
# AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
# IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
# ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE
# LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
# CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
# SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
# INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
# CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
# ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
# POSSIBILITY OF SUCH DAMAGE.

LIBSIMPLEIO	?= $(shell pwd)

AR		?= ar
CC		?= gcc
RANLIB		?= ranlib

CFLAGS		= -Wall -fPIC -I. -I.. $(DEBUGFLAGS)

LIBARCH		?= $(shell gcc -dumpmachine)
DESTDIR		?= /usr/local
ETCDIR		?= /etc

BUILDNUM	?= 1
OSNAME		?= unknown
PKGNAME		:= munts-libsimpleio
PKGVERSION	:= $(shell date +%Y.%j).$(BUILDNUM)
PKGARCH		:= $(shell dpkg --print-architecture)
PKGDIR		:= $(PKGNAME)-$(PKGVERSION)-$(OSNAME)-$(PKGARCH)
PKGFILE		:= $(PKGDIR).deb

include include/dpkg.mk

default: checks package.deb

SIMPLEIO_COMPONENTS	= errmsg.o libevent.o libgpio.o libhidraw.o libi2c.o
SIMPLEIO_COMPONENTS	+= libserial.o libspi.o liblinux.o liblinx.o
SIMPLEIO_COMPONENTS	+= libpwm.o libipv4.o libstream.o libwatchdog.o
SIMPLEIO_COMPONENTS	+= libadc.o

# Perform some checks for beginning the build

checks:
ifneq ($(BOARDNAME),)
	@echo "You munts unset BOARDNAME before building libsimpleio!"
	@false
endif

# Compile C and C++ source files

compile.done:
	ln -s c libsimpleio
	rm -rf obj
	mkdir obj
	for F in c/*.c ada/rabbitmq/*.c ; do $(CC) $(CFLAGS) -c -o obj/`basename $$F .c`.o $$F ; done
	touch $@

# Build libremoteio.so

libremoteio.so:
	$(MAKE) -C ada/shared-libs/libremoteio
	cp ada/shared-libs/libremoteio/libremoteio.so .

# Build libsimpleio.a

libsimpleio.a: compile.done
	$(AR) rcs $@ obj/*.o

# Build libsimpleio.so

libsimpleio.so: compile.done
	$(CC) -shared -o $@ obj/*.o

# Build libwioe5ham1.so

libwioe5ham1.so:
	$(MAKE) -C ada/shared-libs/libwioe5ham1
	cp ada/shared-libs/libwioe5ham1/lib/libwioe5ham1.so .

# Build libwioe5ham2.so

libwioe5ham2.so:
	$(MAKE) -C ada/shared-libs/libwioe5ham2
	cp ada/shared-libs/libwioe5ham2/lib/libwioe5ham2.so .

# Build libwioe5p2p.so

libwioe5p2p.so:
	$(MAKE) -C ada/shared-libs/libwioe5p2p
	cp ada/shared-libs/libwioe5p2p/lib/libwioe5p2p.so .

# Precompile Ada library projects

adalibs.done:
	$(MAKE) -C ada/lib
	touch $@

# Build libsimpleiogm2.a

gm2libs.done:
	$(MAKE) -R -C gm2/lib LIBSIMPLEIO=`pwd` LIBSIMPLEIOGM2=`pwd`/libsimpleiogm2.a
	touch $@

# Install headers and library files

install: libremoteio.so libsimpleio.a libsimpleio.so libwioe5ham1.so libwioe5ham2.so libwioe5p2p.so adalibs.done gm2libs.done
	mkdir -p				$(ETCDIR)/udev/rules.d
	install -cm 0644 hotplug/linux/*.conf	$(ETCDIR)
	install -cm 0644 hotplug/linux/*.rules	$(ETCDIR)/udev/rules.d
	mkdir -p				$(DESTDIR)/include/libsimpleio
	install -cm 0644 ada/shared-libs/*/*.h	$(DESTDIR)/include
	sed -i 's/"C" //g'			$(DESTDIR)/include/*.h
	install -cm 0644 c/*.h			$(DESTDIR)/include/libsimpleio
	mkdir -p				$(DESTDIR)/lib
	install -cm 0644 *.a			$(DESTDIR)/lib
	install -cm 0755 *.so			$(DESTDIR)/lib
	ln -s /usr/lib/$(LIBARCH)/libhidapi-hidraw.a $(DESTDIR)/lib/libhidapi.a
	ln -s /usr/lib/$(LIBARCH)/libhidapi-hidraw.so $(DESTDIR)/lib/libhidapi.so
	mkdir -p				$(DESTDIR)/libexec
	install -cm 0755 hotplug/linux/*helper*	$(DESTDIR)/libexec
	$(CC) -o$(DESTDIR)/libexec/usb-hid-hotplug-attach hotplug/linux/usb-hid-hotplug-attach.c -static
	$(CC) -o$(DESTDIR)/libexec/usb-hid-hotplug-detach hotplug/linux/usb-hid-hotplug-detach.c -static
	strip					$(DESTDIR)/libexec/usb-hid-hotplug*
	mkdir -p				$(DESTDIR)/share/libsimpleio
	cp -R -P -p ada				$(DESTDIR)/share/libsimpleio
	rm -rf					$(DESTDIR)/share/libsimpleio/ada/lib/Makefile
	rm -rf					$(DESTDIR)/share/libsimpleio/ada/lib/*.done
	rm -rf					$(DESTDIR)/share/libsimpleio/ada/lib/*.obj
	sed -i 's/building/using/g'		$(DESTDIR)/share/libsimpleio/ada/lib/*.gpr
	sed -i 's/false/true/g'			$(DESTDIR)/share/libsimpleio/ada/lib/*.gpr
	sed -i '/CUT HERE/,+5 d'		$(DESTDIR)/share/libsimpleio/ada/lib/*.gpr
	rm -f					$(DESTDIR)/share/libsimpleio/ada/rabbitmq/*.c
	rm -rf					$(DESTDIR)/share/libsimpleio/ada/shared-libs
	cp -R -P -p c++				$(DESTDIR)/share/libsimpleio
	rm -rf					$(DESTDIR)/share/libsimpleio/c++/visualstudio
	cp -R -P -p csharp			$(DESTDIR)/share/libsimpleio
	rm -rf					$(DESTDIR)/share/libsimpleio/csharp/programs/remoteio/win64
	cp -R -P -p freepascal			$(DESTDIR)/share/libsimpleio
	cp -R -P -p gm2				$(DESTDIR)/share/libsimpleio
	rm -rf					$(DESTDIR)/share/libsimpleio/gm2/lib
	cp -R -P -p go				$(DESTDIR)/share/libsimpleio
	cp -R -P -p include			$(DESTDIR)/share/libsimpleio
	cp -R -P -p python			$(DESTDIR)/share/libsimpleio
	mkdir -p				$(DESTDIR)/share/libsimpleio/doc
	install -cm 0644 COPYING		$(DESTDIR)/share/libsimpleio/doc
	install -cm 0644 doc/*.pdf		$(DESTDIR)/share/libsimpleio/doc
	cp -R -P -p doc/*.dll			$(DESTDIR)/share/libsimpleio/doc
	mkdir -p				$(DESTDIR)/share/man/man2
	install -cm 0644 doc/*.2		$(DESTDIR)/share/man/man2
	mkdir -p				$(PKGDIR)/usr/lib/python3/dist-packages
	ln -s /usr/local/share/libsimpleio/python/packages/munts $(PKGDIR)/usr/lib/python3/dist-packages/munts
	mkdir -p				$(PKGDIR)/usr/share/gpr
	ln -s /usr/local/share/libsimpleio/ada/lib/libsimpleio.gpr $(PKGDIR)/usr/share/gpr/libsimpleio.gpr

# Create Debian package file

$(PKGDIR):
	mkdir -p				$(PKGDIR)/DEBIAN
	install -cm 0644 control		$(PKGDIR)/DEBIAN
	sed -i s/@@ARCH@@/$(PKGARCH)/g		$(PKGDIR)/DEBIAN/control
	sed -i s/@@NAME@@/$(PKGNAME)/g		$(PKGDIR)/DEBIAN/control
	sed -i s/@@VERSION@@/$(PKGVERSION)/g	$(PKGDIR)/DEBIAN/control
	echo "/etc/hidraw.conf" >>		$(PKGDIR)/DEBIAN/conffiles
	echo "#! /bin/sh\n/sbin/ldconfig" >	$(PKGDIR)/DEBIAN/postinst
	chmod 755				$(PKGDIR)/DEBIAN/postinst
	echo "#! /bin/sh\n/sbin/ldconfig" >	$(PKGDIR)/DEBIAN/postrm
	chmod 755				$(PKGDIR)/DEBIAN/postrm
	$(MAKE) install DESTDIR=$(PKGDIR)/usr/local ETCDIR=$(PKGDIR)/etc

package.deb: $(PKGFILE)

# Remove working files

clean:
	$(MAKE) -C ada/lib clean
	$(MAKE) -C ada/shared-libs/libremoteio  clean
	$(MAKE) -C ada/shared-libs/libwioe5ham1 clean
	$(MAKE) -C ada/shared-libs/libwioe5ham2 clean
	$(MAKE) -C ada/shared-libs/libwioe5p2p  clean
	-rm -rf libsimpleio obj *.done *.a *.so $(PKGDIR) *.deb

reallyclean: clean

distclean: reallyclean
