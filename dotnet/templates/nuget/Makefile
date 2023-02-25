# Copyright (C)2020-2023, Philip Munts, President.
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

LIBNAME		?= UNDEFINEND
BUILDNUM	?= 1
VERSION		:= $(shell date '+2.%Y.%j.$(BUILDNUM)' | sed 's/\.0/./g')
CONFIGURATION	:= Release
NUGETDIR	:= ../../../nuget

FIND		?= find
MAKE		?= make
PANDOC		?= pandoc

# Build all NuGet packages

default:
	$(MAKE) build clean LIBNAME=libremoteio-templates
	$(MAKE) build clean LIBNAME=libsimpleio-templates

# Build a NuGet package containing the specified project templates

build:
	mkdir -p obj
	$(PANDOC) --wrap=none -f html -t markdown $(LIBNAME).html >obj/$(LIBNAME).md
	BUILDVERSION=$(VERSION) dotnet pack $(LIBNAME).csproj -c $(CONFIGURATION)
	-rm -rf $(NUGETDIR)/$(LIBNAME)/$(VERSION)
	-svn rm $(NUGETDIR)/$(LIBNAME)/*
	nuget add bin/$(CONFIGURATION)/*.nupkg -source $(NUGETDIR)
	$(FIND) $(NUGETDIR)/$(LIBNAME) -type f -exec chmod 644 {} ";"
	$(FIND) $(NUGETDIR)/$(LIBNAME) -type d -exec chmod 755 {} ";"
	-svn add $(NUGETDIR)/$(LIBNAME)/$(VERSION)
	cp bin/$(CONFIGURATION)/*.nupkg .

# Remove working files

clean:
	rm -rf bin obj *.nupkg

# Install templates from libsimpleio installation or source checkout

install:
	dotnet new install ./csharp_console_libremoteio.d
	dotnet new install ./csharp_console_libsimpleio.d
