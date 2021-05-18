# Makefile to build Linux Simple I/O Library

# Copyright (C)2016-2021, Philip Munts, President, Munts AM Corp.
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

LIBSIMPLEIO	?= .

AR		= $(CROSS_COMPILE)ar
CC		= $(CROSS_COMPILE)gcc
CFLAGS		= -Wall -fPIC -I. -I.. $(DEBUGFLAGS)

BUILDNUM	?= 1

DESTDIR		?= /usr/local
ETCDIR		?= /etc

ifeq ($(BOARDNAME),)
# Definitions for compiling for native Linux

OSNAME		?= unknown
PKGNAME		:= munts-libsimpleio
PKGVERSION	:= $(shell date +%Y.%j).$(BUILDNUM)
PKGARCH		:= $(shell dpkg --print-architecture)
PKGDIR		:= $(PKGNAME)-$(PKGVERSION)-$(OSNAME)-$(PKGARCH)
DEBFILE		:= $(PKGDIR).deb
else
# Definitions for cross-compiling for MuntsOS embedded Linux

MUNTSOS		?= $(HOME)/muntsos
include $(MUNTSOS)/include/$(BOARDNAME).mk

OSNAME		?= unknown
PKGNAME		:= gcc-$(TOOLCHAIN_NAME)-libsimpleio
PKGVERSION	:= $(shell date +%Y.%j).$(BUILDNUM)
PKGARCH		:= all
PKGDIR		:= $(PKGNAME)-$(PKGVERSION)-$(OSNAME)-$(PKGARCH)
DEBFILE		:= $(PKGDIR).deb
endif

include include/dpkg.mk

default: package.deb

SIMPLEIO_COMPONENTS	= errmsg.o libevent.o libgpio.o libhidraw.o libi2c.o
SIMPLEIO_COMPONENTS	+= libserial.o libspi.o liblinux.o liblinx.o
SIMPLEIO_COMPONENTS	+= libpwm.o libipv4.o libstream.o libwatchdog.o
SIMPLEIO_COMPONENTS	+= libadc.o

# Compile C and C++ source files

compile.done:
	ln -s c libsimpleio
	rm -rf obj
	mkdir obj
	for F in c/*.c ; do $(CC) $(CFLAGS) -c -o obj/`basename $$F .c`.o $$F ; done
	touch $@

# Create static libarary

libsimpleio.a: compile.done
	$(AR) rcs $@ obj/*.o

# Create shared library

libsimpleio.so: compile.done
	$(CC) -shared -o $@ obj/*.o

# Install headers and library files

install: libsimpleio.a libsimpleio.so
	mkdir -p				$(DESTDIR)/include/libsimpleio
	mkdir -p				$(DESTDIR)/lib
	install -cm 0644 c/*.h			$(DESTDIR)/include/libsimpleio
	install -cm 0644 *.a			$(DESTDIR)/lib
	install -cm 0755 *.so			$(DESTDIR)/lib
ifneq ($(BOARDNAME),)
	mkdir -p				$(DESTDIR)/share/doc/libsimpleio
	install -cm 0644 COPYING		$(DESTDIR)/share/doc/libsimpleio
else
	mkdir -p				$(ETCDIR)/udev/rules.d
	mkdir -p				$(DESTDIR)/libexec
	mkdir -p				$(DESTDIR)/share/libsimpleio/doc
	mkdir -p				$(DESTDIR)/share/man/man2
	install -cm 0644 hotplug/linux/*.conf	$(ETCDIR)
	install -cm 0644 hotplug/linux/*.rules	$(ETCDIR)/udev/rules.d
	install -cm 0755 hotplug/linux/*helper*	$(DESTDIR)/libexec
	$(CC) -o$(DESTDIR)/libexec/usb-hid-hotplug-attach hotplug/linux/usb-hid-hotplug-attach.c
	$(CC) -o$(DESTDIR)/libexec/usb-hid-hotplug-detach hotplug/linux/usb-hid-hotplug-detach.c
	strip					$(DESTDIR)/libexec/usb-hid-hotplug*
	install -cm 0644 COPYING		$(DESTDIR)/share/libsimpleio/doc
	install -cm 0644 README.txt		$(DESTDIR)/share/libsimpleio/doc
	install -cm 0644 doc/*.pdf		$(DESTDIR)/share/libsimpleio/doc
	cp -R -P -p ada				$(DESTDIR)/share/libsimpleio
	cp -R -P -p c++				$(DESTDIR)/share/libsimpleio
	rm -rf					$(DESTDIR)/share/libsimpleio/c++/visualstudio
	cp -R -P -p csharp			$(DESTDIR)/share/libsimpleio
	cp -R -P -p freepascal			$(DESTDIR)/share/libsimpleio
	cp -R -P -p gm2				$(DESTDIR)/share/libsimpleio
	cp -R -P -p go				$(DESTDIR)/share/libsimpleio
	cp -R -P -p include			$(DESTDIR)/share/libsimpleio
	cp -R -P -p java			$(DESTDIR)/share/libsimpleio
	cp -R -P -p mybasic			$(DESTDIR)/share/libsimpleio
	cp -R -P -p nuget			$(DESTDIR)/share/libsimpleio
	cp -R -P -p python			$(DESTDIR)/share/libsimpleio
	install -cm 0644 doc/*.2		$(DESTDIR)/share/man/man2
endif

# Create Debian package file

$(PKGDIR):
	mkdir -p				$(PKGDIR)/DEBIAN
ifeq ($(BOARDNAME),)
	install -cm 0644 control		$(PKGDIR)/DEBIAN
else
	install -cm 0644 control.muntsos	$(PKGDIR)/DEBIAN/control
	sed -i s/@@BOARDNAME@@/$(BOARDBASE)/g	$(PKGDIR)/DEBIAN/control
endif
	sed -i s/@@ARCH@@/$(PKGARCH)/g		$(PKGDIR)/DEBIAN/control
	sed -i s/@@NAME@@/$(PKGNAME)/g		$(PKGDIR)/DEBIAN/control
	sed -i s/@@VERSION@@/$(PKGVERSION)/g	$(PKGDIR)/DEBIAN/control
ifeq ($(BOARDNAME),)
# Native package for Debian Linux et al
	echo "/etc/hidraw.conf" >>		$(PKGDIR)/DEBIAN/conffiles
	echo "Depends: libhidapi-dev, libusb-1.0-0-dev" >> $(PKGDIR)/DEBIAN/control
	install -cm 0755 postinst.native	$(PKGDIR)/DEBIAN/postinst
	install -cm 0755 postrm.native		$(PKGDIR)/DEBIAN/postrm
	$(MAKE) install DESTDIR=$(PKGDIR)/usr/local ETCDIR=$(PKGDIR)/etc
else
# Cross-compiled package for MuntsOS embedded Linux
	$(MAKE) install DESTDIR=$(PKGDIR)$(GCCSYSROOT)/usr
endif

package.deb: $(DEBFILE)

# Remove working files

clean:
	-rm -rf libsimpleio obj *.done *.a *.so $(PKGDIR) *.deb

reallyclean: clean

distclean: reallyclean
