# Makefile for building a .Net Core application package or tarball

# Copyright (C)2018-2023, Philip Munts, President, Munts AM Corp.
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
COREAPPPUB	?= bin/$(CONFIGURATION)/net7.0/publish
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

# Set a reasonable default architecture for single file deliverables

ifeq ($(shell uname), Darwin)
ifeq ($(shell uname -m), arm64)
DOTNETARCH	?= osx-arm64
else
DOTNETARCH	?= osx-x64
endif
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

# dotnet command line flags for the various kinds of deliverables

COREAPP_BUILD_FLAGS		?= -c $(CONFIGURATION)
COREAPP_SINGLE_FLAGS		?= -c $(CONFIGURATION) -r $(DOTNETARCH) -p:PublishSingleFile=true --self-contained false $(DOTNETFLAGS)
COREAPP_SELFCONTAINED_FLAGS	?= -c $(CONFIGURATION) -r $(DOTNETARCH) -p:PublishSingleFile=true --self-contained true  $(DOTNETFLAGS)

# Build architecture independent deliverables (i.e. dotnet run myapp.dll).

coreapp_mk_build:
	dotnet publish $(COREAPP_BUILD_FLAGS) $(COREAPPPROJ)
	cp $(COREAPPPUB)/*.dll .
	cp $(COREAPPPUB)/*.runtimeconfig.json .

# Build a single file deliverable without runtime.  Interesting values for
# DOTNETFLAGS include: -p:PublishReadyToRun

coreapp_mk_single:
	dotnet publish $(COREAPP_SINGLE_FLAGS) $(COREAPPPROJ)
	cp bin/$(CONFIGURATION)/net7.0/$(DOTNETARCH)/publish/$(COREAPPNAME) .

# Build a single file deliverable including runtime.  Interesting values for
# DOTNETFLAGS include: -p:PublishReadyToRun -p:PublishTrimmed

coreapp_mk_selfcontained:
	dotnet publish $(COREAPP_SELFCONTAINED_FLAGS) $(COREAPPPROJ)
	cp bin/$(CONFIGURATION)/net7.0/$(DOTNETARCH)/publish/$(COREAPPNAME) .

# Build an architecture independent NuGet package file (mostly useful for
# MuntsOS Embedded Linux.  See https://github.com/pmunts/muntsos).

coreapp_mk_nupkg:
	dotnet pack -c $(CONFIGURATION) $(DOTNETFLAGS) $(COREAPPPROJ)
	cp bin/$(CONFIGURATION)/*.nupkg .

# Build an architecture independent Debian package file (mostly useful for
# MuntsOS Embedded Linux.  See https://github.com/pmunts/muntsos).

$(PKGDIR):
	$(MAKE) coreapp_mk_build
	echo DEBUG: $@ $^ $* $(MAKECMDGOALS)
	mkdir -p						$(PKGDIR)/DEBIAN
	install -cm 0644 $(LIBSIMPLEIO)/csharp/include/coreapp.control	$(PKGDIR)/DEBIAN/control
	$(SED) -i s/@@NAME@@/$(PKGNAME)/g			$(PKGDIR)/DEBIAN/control
	$(SED) -i s/@@VERSION@@/$(PKGVERSION)/g			$(PKGDIR)/DEBIAN/control
ifneq ($(wildcard S[0-9][0-9]$(COREAPPNAME)),)
	mkdir -p						$(PKGDIR)/etc/rc.d
	install -cm 0755 S[0-9][0-9]$(COREAPPNAME)		$(PKGDIR)/etc/rc.d
endif
	mkdir -p 						$(PKGDIR)/$(COREAPPBIN)
	echo exec dotnet $(COREAPPLIB)/$(COREAPPNAME).dll '"$$@"' >$(PKGDIR)/$(COREAPPBIN)/$(COREAPPNAME)
	chmod 755						$(PKGDIR)/$(COREAPPBIN)/$(COREAPPNAME)
	mkdir -p 						$(PKGDIR)/$(COREAPPLIB)
	cp -R -P -p $(COREAPPPUB)/*.dll				$(PKGDIR)/$(COREAPPLIB)
	cp -R -P -p $(COREAPPPUB)/*.json			$(PKGDIR)/$(COREAPPLIB)
	rm -f							$(PKGDIR)/$(COREAPPLIB)/*deps.json
	rm -f							$(PKGDIR)/$(COREAPPLIB)/*dev.json
	$(FIND) $(PKGDIR)/$(COREAPPLIB) -type d -exec chmod 755 "{}" ";"
	$(FIND) $(PKGDIR)/$(COREAPPLIB) -type f -exec chmod 644 "{}" ";"
	touch $@

include $(LIBSIMPLEIO)/include/dpkg.mk

coreapp_mk_deb: $(DEBFILE)

# Build an architecture independent RPM package file (mostly useful for
# MuntsOS Embedded Linux.  See https://github.com/pmunts/muntsos).

include $(LIBSIMPLEIO)/include/rpm.mk

coreapp_mk_rpm: $(RPMFILE)

# Build an architecture independent tarball file

include $(LIBSIMPLEIO)/include/tarball.mk

coreapp_mk_tarball: $(TARFILE)

# Remove working files

coreapp_mk_clean: csharp_mk_clean
	rm -rf $(COREAPPNAME) $(PKGDIR) rpmbuild specfile *.deb *.rpm *.tgz
