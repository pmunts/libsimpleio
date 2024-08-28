# Makefile for building a .Net Core application program

# Copyright (C)2018-2024, Philip Munts dba Munts Technologies.
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

COREAPPTARGET	?= net8.0

COREAPPNAME	:= $(shell basename *.csproj .csproj)
COREAPPPROJ	:= $(COREAPPNAME).csproj
COREAPPPUB	:= bin/$(CONFIGURATION)/$(COREAPPTARGET)/publish
COREAPPDEST	:= /usr/local
COREAPPLIB	:= $(COREAPPDEST)/lib/$(COREAPPNAME)
COREAPPBIN	:= $(COREAPPDEST)/bin

# Use DOTNETARCH defined by MuntsOS Embedded Linux

ifneq ($(BOARDNAME),)
MUNTSOS		?= /usr/local/share/muntsos
include $(MUNTSOS)/include/$(BOARDNAME).mk
endif

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

# Install architecture independent deliverables

coreapp_mk_install: coreapp_mk_build
ifneq ($(wildcard S[0-9][0-9]$(COREAPPNAME)),)
	mkdir -p						$(DESTDIR)/etc/rc.d
	install -cm 0755 S[0-9][0-9]$(COREAPPNAME)		$(DESTDIR)/etc/rc.d
endif
	mkdir -p 						$(DESTDIR)/$(COREAPPBIN)
	echo exec dotnet $(COREAPPLIB)/$(COREAPPNAME).dll '"$$@"' >$(DESTDIR)/$(COREAPPBIN)/$(COREAPPNAME)
	chmod 755						$(DESTDIR)/$(COREAPPBIN)/$(COREAPPNAME)
	mkdir -p 						$(DESTDIR)/$(COREAPPLIB)
	cp -R -P -p $(COREAPPPUB)/*.dll				$(DESTDIR)/$(COREAPPLIB)
	cp -R -P -p $(COREAPPPUB)/*.json			$(DESTDIR)/$(COREAPPLIB)
	rm -f							$(DESTDIR)/$(COREAPPLIB)/*deps.json
	rm -f							$(DESTDIR)/$(COREAPPLIB)/*dev.json
	$(FIND) $(DESTDIR)/$(COREAPPLIB) -type d -exec chmod 755 "{}" ";"
	$(FIND) $(DESTDIR)/$(COREAPPLIB) -type f -exec chmod 644 "{}" ";"

# Build a single file deliverable without runtime.  Interesting values for
# DOTNETFLAGS include: -p:PublishReadyToRun

coreapp_mk_single:
	dotnet publish $(COREAPP_SINGLE_FLAGS) $(COREAPPPROJ)
	cp bin/$(CONFIGURATION)/$(COREAPPTARGET)/$(DOTNETARCH)/publish/$(COREAPPNAME) .

# Build a single file deliverable including runtime.  Interesting values for
# DOTNETFLAGS include: -p:PublishReadyToRun -p:PublishTrimmed

coreapp_mk_selfcontained:
	dotnet publish $(COREAPP_SELFCONTAINED_FLAGS) $(COREAPPPROJ)
	cp bin/$(CONFIGURATION)/$(COREAPPTARGET)/$(DOTNETARCH)/publish/$(COREAPPNAME) .

# Build an architecture independent NuGet package file (mostly useful for
# MuntsOS Embedded Linux.  See https://github.com/pmunts/muntsos).

coreapp_mk_nupkg:
	dotnet pack -c $(CONFIGURATION) $(DOTNETFLAGS) $(COREAPPPROJ)
	cp bin/$(CONFIGURATION)/*.nupkg .

ifeq ($(shell uname), Linux)
# Build an architecture independent Debian package file (mostly useful for
# MuntsOS Embedded Linux.  See https://github.com/pmunts/muntsos).

include $(LIBSIMPLEIO)/include/dpkg.mk

DEBNAME		:= $(shell echo $(COREAPPNAME) | tr '[_]' '[\-]')
DEBVERSION	:= $(shell date +%Y.%j)
DEBARCH		:= all
DEBDIR		:= $(DEBNAME)-$(DEBARCH)
DEBFILE		:= $(DEBDIR).deb

$(DEBDIR):
	$(MAKE) coreapp_mk_install DESTDIR=$(DEBDIR)
	mkdir -p							$(DEBDIR)/DEBIAN
	install -cm 0644 $(LIBSIMPLEIO)/csharp/include/coreapp.control	$(DEBDIR)/DEBIAN/control
	$(SED) -i s/@@NAME@@/$(DEBNAME)/g				$(DEBDIR)/DEBIAN/control
	$(SED) -i s/@@VERSION@@/$(DEBVERSION)/g				$(DEBDIR)/DEBIAN/control
	touch $@

coreapp_mk_deb: $(DEBFILE)
endif

# Build an architecture independent RPM package file (mostly useful for
# MuntsOS Embedded Linux.  See https://github.com/pmunts/muntsos).

include $(LIBSIMPLEIO)/include/rpm.mk

RPMNAME		:= $(shell echo $(COREAPPNAME) | tr '[_]' '[\-]')
RPMVERSION	:= $(shell date +%Y.%j)
RPMARCH		:= noarch
RPMDIR		:= $(RPMNAME)-$(RPMARCH)
RPMFILE		:= $(RPMDIR).rpm

$(RPMDIR):
	$(MAKE) coreapp_mk_install DESTDIR=$(RPMDIR)
	touch $@

coreapp_mk_rpm: $(RPMFILE)

# Build an architecture independent tarball file (mostly useful for
# MuntsOS Embedded Linux.  See https://github.com/pmunts/muntsos).

include $(LIBSIMPLEIO)/include/tarball.mk

TARNAME		:= $(COREAPPNAME)
TARDIR		:= $(TARNAME)
TARFILE		:= $(TARDIR).tgz

$(TARDIR):
	$(MAKE) coreapp_mk_install DESTDIR=$(TARDIR)
	touch $@

coreapp_mk_tarball: $(TARFILE)

# Remove working files

coreapp_mk_clean: csharp_mk_clean
	rm -rf $(COREAPPNAME) $(DEBDIR) $(RPMDIR) $(TARDIR) rpmbuild specfile *.deb *.rpm *.tgz
