# Makefile for building a .Net Framework application

# Copyright (C)2019, Philip Munts, President, Munts AM Corp.
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

MONOAPPNAME	?= $(shell basename *.elements .elements)
MONOAPPPROJ	?= $(MONOAPPNAME).elements
MONOAPPRELEASE	?= .
MONOAPPDEST	?= /usr/local
MONOAPPLIB	?= $(MONOAPPDEST)/lib/$(MONOAPPNAME)
MONOAPPBIN	?= $(MONOAPPDEST)/bin

PKGCONTROL	= $(ELEMENTSSRC)/dotnet/include/monoapp.control
PKGNAME		= $(shell echo $(MONOAPPNAME) | tr '[_]' '[\-]')
PKGVERSION	= $(shell date +%Y.%j)
PKGARCH		= all
PKGDIR		= $(PKGNAME)-$(PKGVERSION)-$(PKGARCH)
PKGFILE		= $(PKGDIR).deb

TAR		?= tar
TARROOT		?= fakeroot
TARFLAGS	?= --owner=root --group=root --mode=ugo-w

# Pack the application into a Debian package file

$(PKGDIR): elements_mk_default
	mkdir -p						$(PKGDIR)/DEBIAN
	install -cm 0644 $(PKGCONTROL)				$(PKGDIR)/DEBIAN/control
	sed -i s/@@NAME@@/$(PKGNAME)/g				$(PKGDIR)/DEBIAN/control
	sed -i s/@@VERSION@@/$(PKGVERSION)/g			$(PKGDIR)/DEBIAN/control
	mkdir -p 						$(PKGDIR)/$(MONOAPPBIN)
	echo exec mono $(MONOAPPLIB)/$(MONOAPPNAME).exe '"$$@"' >$(PKGDIR)/$(MONOAPPBIN)/$(MONOAPPNAME)
	chmod 755						$(PKGDIR)/$(MONOAPPBIN)/$(MONOAPPNAME)
	mkdir -p 						$(PKGDIR)/$(MONOAPPLIB)
	cp -R -P -p $(MONOAPPRELEASE)/*.exe			$(PKGDIR)/$(MONOAPPLIB)
	cp -R -P -p $(MONOAPPRELEASE)/*.dll			$(PKGDIR)/$(MONOAPPLIB)
	find $(PKGDIR)/$(MONOAPPLIB) -type d -exec chmod 755 "{}" ";"
	find $(PKGDIR)/$(MONOAPPLIB) -type f -exec chmod 644 "{}" ";"
	touch $@

$(PKGFILE): $(PKGDIR)
	chmod -R ugo-w $(PKGDIR)/usr
	fakeroot dpkg-deb -Zgzip --build $(PKGDIR)
	chmod -R u+w $(PKGDIR)/usr

monoapp_mk_deb: $(PKGFILE)

# Pack the application into a distribution tarball

monoapp_mk_tarball: elements_mk_default
	mkdir -p 						$(TARROOT)/$(MONOAPPBIN)
	echo exec mono $(MONOAPPLIB)/$(MONOAPPNAME).exe '"$$@"' >$(TARROOT)/$(MONOAPPBIN)/$(MONOAPPNAME)
	chmod 755						$(TARROOT)/$(MONOAPPBIN)/$(MONOAPPNAME)
	mkdir -p 						$(TARROOT)/$(MONOAPPLIB)
	cp -R -P -p $(MONOAPPRELEASE)/*.exe			$(TARROOT)/$(MONOAPPLIB)
	cp -R -P -p $(MONOAPPRELEASE)/*.dll			$(TARROOT)/$(MONOAPPLIB)
	find $(TARROOT)/$(MONOAPPLIB) -type d -exec chmod 755 "{}" ";"
	find $(TARROOT)/$(MONOAPPLIB) -type f -exec chmod 644 "{}" ";"
	cd $(TARROOT) && $(TAR) czf ../$(MONOAPPNAME).tgz * $(TARFLAGS)

# Remove working files

monoapp_mk_clean:
	rm -rf $(PKGDIR) $(TARROOT) *.tgz *.deb
