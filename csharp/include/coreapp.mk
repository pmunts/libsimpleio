# Makefile for building a .Net Core application package or tarball

# Copyright (C)2018-2020, Philip Munts, President, Munts AM Corp.
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
COREAPPPUB	?= bin/$(CONFIGURATION)/netcoreapp3.1/publish
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

SED		?= sed

# Set a reasonable default architecture for single file deliverables

ifeq ($(shell uname), Darwin)
DOTNETARCH	?= osx-x64
endif

ifeq ($(shell uname), Linux)
ifeq ($(shell uname -m), aarch64)
DOTNETARCH	?= linux-arm64
endif
ifeq ($(shell uname -m), armhf)
DOTNETARCH	?= linux-arm
endif
ifeq ($(shell uname -m), x86_64)
DOTNETARCH	?= linux-x64
endif
endif

ifeq ($(OS), Windows_NT)
DOTNETARCH	?= win-x64
endif

# Compile the application

coreapp_mk_build:
	dotnet publish -c $(CONFIGURATION) $(DOTNETFLAGS) $(COREAPPPROJ)

# Build a single file deliverable without runtime included

coreapp_mk_single:
	dotnet publish -c $(CONFIGURATION) $(DOTNETFLAGS) -r $(DOTNETARCH) /p:PublishSingleFile=true --self-contained false $(COREAPPPROJ)
	cp bin/$(CONFIGURATION)/netcoreapp3.1/$(DOTNETARCH)/publish/$(COREAPPNAME) .

# Build a single file deliverable with runtime include

coreapp_mk_selfcontained:
	dotnet publish -c $(CONFIGURATION) $(DOTNETFLAGS) -r $(DOTNETARCH) /p:PublishSingleFile=true --self-contained true $(COREAPPPROJ)
	cp bin/$(CONFIGURATION)/netcoreapp3.1/$(DOTNETARCH)/publish/$(COREAPPNAME) .

# Pack the application into a Debian package file

$(PKGDIR): coreapp_mk_build
	mkdir -p						$(PKGDIR)/DEBIAN
	install -cm 0644 $(LIBSIMPLEIO)/csharp/include/coreapp.control	$(PKGDIR)/DEBIAN/control
	$(SED) -i s/@@NAME@@/$(PKGNAME)/g				$(PKGDIR)/DEBIAN/control
	$(SED) -i s/@@VERSION@@/$(PKGVERSION)/g			$(PKGDIR)/DEBIAN/control
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

# Build an application NuGet package (aka glorified zip file)

coreapp_mk_nupkg:
	dotnet pack -c $(CONFIGURATION) $(DOTNETFLAGS) $(COREAPPPROJ)
	cp bin/$(CONFIGURATION)/*.nupkg .

# Remove working files

coreapp_mk_clean: csharp_mk_clean
	rm -rf $(COREAPPNAME) $(PKGDIR) rpmbuild specfile *.deb *.rpm *.tgz
