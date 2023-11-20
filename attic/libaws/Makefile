# Build the AdaCore Ada Web Server Library for Debian 12, of which it is no
# longer a system package.

# Copyright (C)2023, Philip Munts dba Munts Technologies.
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

AWS_URL		?= https://github.com/AdaCore/aws
AWS_VER		?= 23.0.0
AWS_SRC		:= $(shell pwd)/aws.src
AWS_DST		:= $(shell pwd)/aws.dst

INSTALLDIR	:= /usr/local/libaws-$(AWS_VER)

BUILDNUM	?= 1
OSNAME		?= unknown
PKGNAME		:= munts-libaws
PKGARCH		:= $(shell dpkg --print-architecture)
PKGVERSION	:= $(AWS_VER)-$(shell date +%Y.%j).$(BUILDNUM)
PKGDIR		:= $(PKGNAME)-$(PKGVERSION)-$(OSNAME)-$(PKGARCH)
PKGFILE		:= $(PKGDIR).deb

default: $(PKGFILE)

###############################################################################

# Checkout AWS source code

$(AWS_SRC):
	git clone --recursive $(AWS_URL) --branch v$(AWS_VER) --depth 1 $(AWS_SRC)
	cp makefile.conf $(AWS_SRC)
	sed -i 's#@@INSTALLDIR@@#$(INSTALLDIR)#g' $(AWS_SRC)/makefile.conf
	touch $@

###############################################################################

# Build Debian package

$(PKGFILE): $(AWS_SRC)
	mkdir -p $(PKGDIR)/DEBIAN
	install -cm 0444 control		$(PKGDIR)/DEBIAN
	sed -i 's/@@ARCH@@/$(PKGARCH)/g'	$(PKGDIR)/DEBIAN/control
	sed -i 's/@@NAME@@/$(PKGNAME)/g'	$(PKGDIR)/DEBIAN/control
	sed -i 's/@@VERSION@@/$(PKGVERSION)/g'	$(PKGDIR)/DEBIAN/control
	cd $(AWS_SRC) && make setup build install DESTDIR=$(shell pwd)/$(PKGDIR)
	sed -i 's@\.\./\.\.@$(INSTALLDIR)@g'	$(PKGDIR)$(INSTALLDIR)/share/gpr/aws.gpr
	mkdir -p				$(PKGDIR)/usr/share/gpr
	ln -s $(INSTALLDIR)/share/gpr/aws.gpr	$(PKGDIR)/usr/share/gpr/aws.gpr
	chmod -R ugo-w $(PKGDIR)/usr
	fakeroot dpkg-deb --build $(PKGDIR)
	chmod -R u+w $(PKGDIR)/usr

###############################################################################

# Remove working files

clean:
	rm -rf $(AWS_DST) $(AWS_SRC) $(PKGDIR) $(PKGFILE)
