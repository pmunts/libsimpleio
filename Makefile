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
CFLAGS		= -Wall -fPIC -I. -I.. $(DEBUGFLAGS) -DWAIT_DEV_LINK

ifeq ($(BOARDNAME),)
# Definitions for compiling for native Linux

DESTDIR		?= /usr/local

OSNAME		?= unknown
PKGNAME		:= munts-libsimpleio
PKGVERSION	:= $(shell date +%Y.%j)$(BUILDNUM)
PKGARCH		:= $(shell dpkg --print-architecture)
PKGDIR		:= $(PKGNAME)-$(PKGVERSION)-$(OSNAME)-$(PKGARCH)
PKGFILE		:= $(PKGDIR).deb
else
# Definitions for cross-compiling for MuntsOS embedded Linux

EMBLINUXBASE	?= $(HOME)/muntsos
include $(EMBLINUXBASE)/include/$(BOARDNAME).mk

OSNAME		?= unknown
PKGNAME		:= gcc-$(TOOLCHAIN_NAME)-libsimpleio
PKGVERSION	:= $(shell date +%Y.%j)$(BUILDNUM)
PKGARCH		:= all
PKGDIR		:= $(PKGNAME)-$(PKGVERSION)-$(OSNAME)-$(PKGARCH)
PKGFILE		:= $(PKGDIR).deb
endif

include make/dpkg.mk

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
	mkdir -p				$(DESTDIR)/share/libsimpleio/ada
	mkdir -p				$(DESTDIR)/share/libsimpleio/c++
	mkdir -p				$(DESTDIR)/share/libsimpleio/csharp
	mkdir -p				$(DESTDIR)/share/libsimpleio/doc
	mkdir -p				$(DESTDIR)/share/libsimpleio/java/com/munts/libsimpleio
	mkdir -p				$(DESTDIR)/share/libsimpleio/make
	mkdir -p				$(DESTDIR)/share/libsimpleio/modula2
	mkdir -p				$(DESTDIR)/share/libsimpleio/pascal
	mkdir -p				$(DESTDIR)/share/man/man2
	install -cm 0644 c/*.h			$(DESTDIR)/include/libsimpleio
	install -cm 0644 *.a			$(DESTDIR)/lib
	install -cm 0755 *.so			$(DESTDIR)/lib
	cp -R -P -p ada				$(DESTDIR)/share/libsimpleio
	cp -R -P -p basic			$(DESTDIR)/share/libsimpleio
	cp -R -P -p c++				$(DESTDIR)/share/libsimpleio
	cp -R -P -p csharp			$(DESTDIR)/share/libsimpleio
	cp -R -P -p java			$(DESTDIR)/share/libsimpleio
	cp -R -P -p make			$(DESTDIR)/share/libsimpleio
	cp -R -P -p modula2			$(DESTDIR)/share/libsimpleio
	cp -R -P -p pascal			$(DESTDIR)/share/libsimpleio
	install -cm 0644 COPYING		$(DESTDIR)/share/libsimpleio/doc
	install -cm 0644 README.txt		$(DESTDIR)/share/libsimpleio/doc/README
	install -cm 0644 doc/*.pdf		$(DESTDIR)/share/libsimpleio/doc
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
	install -cm 0644 udev/*.rules		$(PKGDIR)/etc/udev/rules.d
	mkdir -p				$(PKGDIR)/usr/local/libexec
	install -cm 0755 udev/udev-helper-*	$(PKGDIR)/usr/local/libexec
else
# Cross-compiled package for MuntsOS embedded Linux
	$(MAKE) install DESTDIR=$(PKGDIR)$(GCCSYSROOT)/usr
endif

package.deb: $(PKGFILE)

# Remove working files

clean:
	-rm -rf libsimpleio obj *.done *.a *.so $(PKGDIR) *.deb

reallyclean: clean

distclean: reallyclean
