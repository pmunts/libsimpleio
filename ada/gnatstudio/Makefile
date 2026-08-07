# Makefile to build AdaCore GNAT Studio package for Debian

# Copyright (C)2026, Philip Munts dba Munts Technologies.
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

BUILDNUM	?= 1

DISTNAME	:= gnatstudio
DISTVERSION	?= 2026.2-20260409
DISTARCH	?= x86_64
DISTDIR		:= $(DISTNAME)-$(DISTVERSION)-$(DISTARCH)-linux-bin
DISTURL		:= https://github.com/AdaCore/$(DISTNAME)/releases/download/$(DISTNAME)-$(DISTVERSION)/$(DISTDIR).tar.gz
DISTFILE	:= /tmp/$(DISTDIR).tar.gz

PKGNAME		:= $(DISTNAME)
ifeq ($(DISTARCH), x86_64)
PKGARCH		:= amd64
else ifeq ($(DISTARCH), aarch64)
PKGARCH		:= arm64
else
PKGARCH		:= $(shell dpkg --print-architecture)
endif
PKGVERSION	:= $(DISTVERSION)-$(BUILDNUM)
PKGDIR		:= $(PKGNAME)-$(PKGVERSION)-$(OSNAME)-$(PKGARCH)
PKGFILE		:= $(PKGDIR).deb

default: $(PKGFILE)

# Download distribution tarball

$(DISTFILE):
	wget -nv -P $(TEMP) $(DISTURL)

# Unpack distribution tarball

$(DISTDIR): $(DISTFILE)
	tar xzf $(DISTFILE)
	touch $@

# Populate Debian package directory tree

$(PKGDIR): $(DISTDIR)
	mkdir -p				$(PKGDIR)/DEBIAN
	install -cm 644 control			$(PKGDIR)/DEBIAN
	sed -i s/@@ARCH@@/$(PKGARCH)/g		$(PKGDIR)/DEBIAN/control
	sed -i s/@@NAME@@/$(PKGNAME)/g		$(PKGDIR)/DEBIAN/control
	sed -i s/@@VERSION@@/$(PKGVERSION)/g	$(PKGDIR)/DEBIAN/control
	cd $(DISTDIR) && ./doinstall		$(shell pwd)/$(PKGDIR)/usr/local/gnatstudio
	sed -i 's@$$(basename "$$0")@gnatstudio@g' $(PKGDIR)/usr/local/gnatstudio/bin/gnatstudio
	sed -i 's@$$(dirname "$$0")@/usr/local/gnatstudio/bin@g' $(PKGDIR)/usr/local/gnatstudio/bin/gnatstudio
	mkdir -p				$(PKGDIR)/usr/local/bin
	ln -s ../gnatstudio/bin/gnatstudio	$(PKGDIR)/usr/local/bin/gnatstudio
	mkdir -p				$(PKGDIR)/usr/local/share/applications
	install -cm 0644 gnatstudio.desktop	$(PKGDIR)/usr/local/share/applications

# Build Debian package file

$(PKGFILE): $(PKGDIR)
	chmod -R ugo-w $(PKGDIR)/usr
	fakeroot dpkg-deb --build $(PKGDIR)
	chmod -R u+w $(PKGDIR)
ifneq ($(SERVERDIR),)
	scp $(PKGFILE) $(SERVERDIR)
endif

clean:
	chmod -R u+w $(PKGDIR)
	rm -rf $(DISTDIR) $(PKGDIR) $(PKGFILE)

reallyclean: clean

distclean: reallyclean
	rm -f $(DISTFILE)
