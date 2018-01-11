# Makefile to build Linux Simple I/O Library

# Copyright (C)2016-2018, Philip Munts, President, Munts AM Corp.
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

AR		= $(CROSS_COMPILE)ar
CC		= $(CROSS_COMPILE)gcc
CFLAGS		= -Wall -fPIC -I. $(DEBUGFLAGS) -DWAIT_GPIO_LINK

ifeq ($(BOARDNAME),)
# Definitions for compiling for native Linux

DESTDIR		?= /usr/local

OSNAME		?= unknown
PKGNAME		:= munts-libsimpleio
PKGVERSION	:= $(shell date +%Y.%j)
PKGARCH		:= $(shell dpkg --print-architecture)
PKGDIR		:= $(PKGNAME)-$(PKGVERSION)-$(OSNAME)-$(PKGARCH)
PKGFILE		:= $(PKGDIR).deb
else
# Definitions for cross-compiling for MuntsOS embedded Linux

EMBLINUXBASE	?= $(HOME)/arm-linux-mcu
include $(EMBLINUXBASE)/include/$(BOARDNAME).mk

OSNAME		?= unknown
PKGNAME		:= $(TOOLCHAIN_NAME)-libsimpleio
PKGVERSION	:= $(shell date +%Y.%j)
PKGARCH		:= all
PKGDIR		:= $(PKGNAME)-$(PKGVERSION)-$(OSNAME)-$(PKGARCH)
PKGFILE		:= $(PKGDIR).deb
endif

default: package.deb

SIMPLEIO_COMPONENTS	= errmsg.o libevent.o libgpio.o libhidraw.o libi2c.o
SIMPLEIO_COMPONENTS	+= libserial.o libspi.o liblinux.o liblinx.o
SIMPLEIO_COMPONENTS	+= libpwm.o libipv4.o libstream.o libwatchdog.o
SIMPLEIO_COMPONENTS	+= libadc.o

# Create static libarary

libsimpleio.a: $(SIMPLEIO_COMPONENTS)
	$(AR) rcs $@ $^

# Create shared library

libsimpleio.so: $(SIMPLEIO_COMPONENTS)
	$(CC) -shared -o $@ $^

# Install headers and library files

install: libsimpleio.a libsimpleio.so
	mkdir -p				$(DESTDIR)/include
	mkdir -p				$(DESTDIR)/lib
	mkdir -p				$(DESTDIR)/share/libsimpleio/ada
	mkdir -p				$(DESTDIR)/share/libsimpleio/csharp
	mkdir -p				$(DESTDIR)/share/libsimpleio/pascal
	mkdir -p				$(DESTDIR)/share/libsimpleio/java/com/munts/libsimpleio
	mkdir -p				$(DESTDIR)/share/libsimpleio/pascal
	mkdir -p				$(DESTDIR)/share/man/man2
	install -cm 0644 *.h			$(DESTDIR)/include
	install -cm 0644 *.a			$(DESTDIR)/lib
	install -cm 0755 *.so			$(DESTDIR)/lib
	install -cm 0644 doc/UserManual.pdf	$(DESTDIR)/share/libsimpleio
	install -cm 0644 ada/*			$(DESTDIR)/share/libsimpleio/ada
	install -cm 0644 csharp/libsimpleio.*	$(DESTDIR)/share/libsimpleio/csharp
	install -cm 0644 java/*.java		$(DESTDIR)/share/libsimpleio/java/com/munts/libsimpleio
	install -cm 0644 pascal/*		$(DESTDIR)/share/libsimpleio/pascal
	cp -R -P c++				$(DESTDIR)/share/libsimpleio
	install -cm 0644 doc/*.2		$(DESTDIR)/share/man/man2

# Create Debian package file

$(PKGDIR):
	mkdir -p				$(PKGDIR)/DEBIAN
	install -cm 0644 control		$(PKGDIR)/DEBIAN
	sed -i s/@@ARCH@@/$(PKGARCH)/g		$(PKGDIR)/DEBIAN/control
	sed -i s/@@NAME@@/$(PKGNAME)/g		$(PKGDIR)/DEBIAN/control
	sed -i s/@@VERSION@@/$(PKGVERSION)/g	$(PKGDIR)/DEBIAN/control
ifeq ($(BOARDNAME),)
# Native package for Debian Linux et al
	$(MAKE) install DESTDIR=$(PKGDIR)/usr/local
	mkdir -p				$(PKGDIR)/etc/udev/rules.d
	install -cm 0644 udev/60-gpio.rules	$(PKGDIR)/etc/udev/rules.d
	mkdir -p				$(PKGDIR)/usr/local/libexec
	install -cm 0755 udev/gpio-udev-helper	$(PKGDIR)/usr/local/libexec
	chmod -R ugo-w $(PKGDIR)/etc
else
# Cross-compiled package for MuntsOS embedded Linux
	$(MAKE) install DESTDIR=$(PKGDIR)$(GCCSYSROOT)/usr
endif

$(PKGFILE): $(PKGDIR)
	chmod -R ugo-w $(PKGDIR)/usr
	fakeroot dpkg-deb --build $(PKGDIR)
	chmod -R u+w $(PKGDIR)

package.deb: $(PKGFILE)

# Remove working files

clean:
	-rm -rf *.a *.deb *.o *.so $(PKGDIR)

reallyclean: clean

distclean: reallyclean
