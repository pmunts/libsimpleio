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

ifeq ($(shell uname), Darwin)
EBUILDFLAGS	+= --setting:AdditionalReferencePaths=/Applications/Fire.app/Contents/Resources/References
endif

COREAPPNAME	?= $(shell basename *.elements .elements)
COREAPPPROJ	?= $(COREAPPNAME).elements
COREAPPPUB	?= Bin/Release
COREAPPDEST	?= /usr/local
COREAPPLIB	?= $(COREAPPDEST)/lib/$(COREAPPNAME)
COREAPPBIN	?= $(COREAPPDEST)/bin

PKGNAME		= $(shell echo $(COREAPPNAME) | tr '[_]' '[\-]')
PKGVERSION	= $(shell date +%Y.%j)
PKGARCH		= all
PKGDIR		= $(PKGNAME)-$(PKGVERSION)-$(PKGARCH)
DEBFILE		= $(PKGDIR).deb
RPMFILE		= $(PKGDIR).rpm
TARFILE		= $(PKGDIR).tgz

# Compile the application

coreapp_mk_build: elements_mk_build
	cp Bin/$(CONFIGURATION)/*.dll .
	cp Bin/$(CONFIGURATION)/*.runtimeconfig.json .

# Pack the application into a Debian package file

$(PKGDIR): coreapp_mk_build
	mkdir -p						$(PKGDIR)/DEBIAN
	install -cm 0644 $(ELEMENTSSRC)/dotnet/include/coreapp.control	$(PKGDIR)/DEBIAN/control
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

# Build a Debian package file

include $(LIBSIMPLEIO)/include/dpkg.mk

coreapp_mk_deb: $(DEBFILE)

# Build an RPM package file

include $(LIBSIMPLEIO)/include/rpm.mk

coreapp_mk_rpm: $(RPMFILE)

# Build an application tarball file

include $(LIBSIMPLEIO)/include/tarball.mk

coreapp_mk_tarball: $(TARFILE)

# Remove working files

coreapp_mk_clean: elements_mk_clean
	rm -rf $(PKGDIR) packages rpmbuild specfile *.deb *.rpm *.tgz
