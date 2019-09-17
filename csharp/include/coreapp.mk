# Makefile for building a .Net Core application package or tarball

# Copyright (C)2018-2019, Philip Munts, President, Munts AM Corp.
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

COREAPPNAME	?= $(shell basename *.csproj .csproj)
COREAPPPROJ	?= $(COREAPPNAME).csproj
COREAPPPUB	?= bin/$(CONFIGURATION)/netcoreapp2.2/publish
COREAPPDEST	?= /usr/local
COREAPPLIB	?= $(COREAPPDEST)/lib/$(COREAPPNAME)
COREAPPBIN	?= $(COREAPPDEST)/bin

PKGNAME		= $(shell echo $(COREAPPNAME) | tr '[_]' '[\-]')
PKGVERSION	= $(shell date +%Y.%j)
PKGARCH		= all
PKGDIR		= $(PKGNAME)-$(PKGVERSION)-$(PKGARCH)
PKGFILE		= $(PKGDIR).deb

TAR		?= tar
TARROOT		?= fakeroot
TARFLAGS	?= --owner=root --group=root --mode=ugo-w

# Compile the application

coreapp_mk_build:
	dotnet publish $(COREAPPPROJ) -c $(CONFIGURATION)

# Pack the application into a Debian package file

$(PKGDIR): coreapp_mk_build
	mkdir -p						$(PKGDIR)/DEBIAN
	install -cm 0644 $(CSHARPSRC)/include/coreapp.control	$(PKGDIR)/DEBIAN/control
	sed -i s/@@NAME@@/$(PKGNAME)/g				$(PKGDIR)/DEBIAN/control
	sed -i s/@@VERSION@@/$(PKGVERSION)/g			$(PKGDIR)/DEBIAN/control
	mkdir -p 						$(PKGDIR)/$(COREAPPBIN)
	echo exec dotnet $(COREAPPLIB)/$(COREAPPNAME).dll '"$$@"' >$(PKGDIR)/$(COREAPPBIN)/$(COREAPPNAME)
	chmod 755						$(PKGDIR)/$(COREAPPBIN)/$(COREAPPNAME)
	mkdir -p 						$(PKGDIR)/$(COREAPPLIB)
	cp -R -P -p $(COREAPPPUB)/*.dll				$(PKGDIR)/$(COREAPPLIB)
	cp -R -P -p $(COREAPPPUB)/*.json			$(PKGDIR)/$(COREAPPLIB)
	rm -f							$(PKGDIR)/$(COREAPPLIB)/*deps.json
	rm -f							$(PKGDIR)/$(COREAPPLIB)/*dev.json
	find $(PKGDIR)/$(COREAPPLIB) -type d -exec chmod 755 "{}" ";"
	find $(PKGDIR)/$(COREAPPLIB) -type f -exec chmod 644 "{}" ";"
	touch $@

include $(LIBSIMPLEIO)/include/dpkg.mk

coreapp_mk_deb: $(PKGFILE)

# Pack the application into a distribution tarball

coreapp_mk_tarball: coreapp_mk_build
	mkdir -p 						$(TARROOT)/$(COREAPPBIN)
	echo exec dotnet $(COREAPPLIB)/$(COREAPPNAME).dll '"$$@"' >$(TARROOT)/$(COREAPPBIN)/$(COREAPPNAME)
	chmod 755						$(TARROOT)/$(COREAPPBIN)/$(COREAPPNAME)
	mkdir -p 						$(TARROOT)/$(COREAPPLIB)
	cp -R -P -p $(COREAPPPUB)/*.dll				$(TARROOT)/$(COREAPPLIB)
	cp -R -P -p $(COREAPPPUB)/*.json			$(TARROOT)/$(COREAPPLIB)
	find $(TARROOT)/$(COREAPPLIB) -type d -exec chmod 755 "{}" ";"
	find $(TARROOT)/$(COREAPPLIB) -type f -exec chmod 644 "{}" ";"
	cd $(TARROOT) && $(TAR) czf ../$(COREAPPNAME).tgz * $(TARFLAGS)

# Remove working files

coreapp_mk_clean: csharp_mk_clean
	rm -rf $(PKGDIR) $(TARROOT) *.tgz *.deb
