# Makefile to build the Linux Simple I/O Library

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

LIBSIMPLEIO	?= $(shell pwd)

AR		?= ar
CC		?= gcc
RANLIB		?= ranlib

CFLAGS		= -Wall -fPIC -I. -I.. $(DEBUGFLAGS)

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

# Precompile Ada library projects

adalibs.done:
	$(MAKE) -C ada/lib/native LIBSIMPLEIO=$(LIBSIMPLEIO)
	touch $@

# Install headers and library files

install: libsimpleio.a libsimpleio.so adalibs.done
	mkdir -p				$(ETCDIR)/udev/rules.d
	install -cm 0644 hotplug/linux/*.conf	$(ETCDIR)
	install -cm 0644 hotplug/linux/*.rules	$(ETCDIR)/udev/rules.d
	mkdir -p				$(DESTDIR)/include/libsimpleio
	install -cm 0644 c/*.h			$(DESTDIR)/include/libsimpleio
	mkdir -p				$(DESTDIR)/lib
	install -cm 0644 *.a			$(DESTDIR)/lib
	install -cm 0755 *.so			$(DESTDIR)/lib
	mkdir -p				$(DESTDIR)/libexec
	install -cm 0755 hotplug/linux/*helper*	$(DESTDIR)/libexec
	$(CC) -o$(DESTDIR)/libexec/usb-hid-hotplug-attach hotplug/linux/usb-hid-hotplug-attach.c
	$(CC) -o$(DESTDIR)/libexec/usb-hid-hotplug-detach hotplug/linux/usb-hid-hotplug-detach.c
	strip					$(DESTDIR)/libexec/usb-hid-hotplug*
	mkdir -p				$(DESTDIR)/share/libsimpleio
	cp -R -P -p ada				$(DESTDIR)/share/libsimpleio
	cp ada/lib/native/libsimpleio.gpr	$(DESTDIR)/share/libsimpleio/ada/lib
	rm -rf					$(DESTDIR)/share/libsimpleio/ada/lib/cross
	rm -rf					$(DESTDIR)/share/libsimpleio/ada/lib/gnat-gpl
	rm -rf					$(DESTDIR)/share/libsimpleio/ada/lib/muntsos
	rm -rf					$(DESTDIR)/share/libsimpleio/ada/lib/native
	rm -rf					$(DESTDIR)/share/libsimpleio/ada/lib/*.done
	rm -rf					$(DESTDIR)/share/libsimpleio/ada/lib/*.obj
	sed -i 's/false/true/g'			$(DESTDIR)/share/libsimpleio/ada/lib/*.gpr
	sed -i '/Object_Dir/,+1 d'		$(DESTDIR)/share/libsimpleio/ada/lib/*.gpr
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
	mkdir -p				$(DESTDIR)/share/libsimpleio/doc
	install -cm 0644 COPYING		$(DESTDIR)/share/libsimpleio/doc
	install -cm 0644 README.txt		$(DESTDIR)/share/libsimpleio/doc
	install -cm 0644 doc/*.pdf		$(DESTDIR)/share/libsimpleio/doc
	mkdir -p				$(DESTDIR)/share/man/man2
	install -cm 0644 doc/*.2		$(DESTDIR)/share/man/man2
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
	install -cm 0755 postinst		$(PKGDIR)/DEBIAN/postinst
	install -cm 0755 postrm			$(PKGDIR)/DEBIAN/postrm
	$(MAKE) install DESTDIR=$(PKGDIR)/usr/local ETCDIR=$(PKGDIR)/etc

package.deb: $(PKGFILE)

# Remove working files

clean:
	$(MAKE) -C ada/lib/native clean LIBSIMPLEIO=$(LIBSIMPLEIO)
	-rm -rf libsimpleio obj *.done *.a *.so $(PKGDIR) *.deb

reallyclean: clean

distclean: reallyclean
