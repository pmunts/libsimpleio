# Makefile for building libremoteio.dll for .Net Standard 2.0

# Copyright (C)2014-2020, Philip Munts, President, Munts AM Corp.
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

LIBSIMPLEIO	?= ../..

BUILDNUM	?= 1
LIBNAME		= libremoteio
VERSION		?= 2.`date '+%Y.%j'`.$(BUILDNUM)
CONFIGURATION	= Release
NUGETDIR	= ../../nuget

# Definitions for Calibre ebook-convert program
CONVERT		?= C:/Progra~1/Calibre2/ebook-convert
CONVERTFLAGS	+= --paper-size letter
CONVERTFLAGS	+= --pdf-add-toc
CONVERTFLAGS	+= --pdf-page-margin-top 54
CONVERTFLAGS	+= --pdf-page-margin-bottom 54
CONVERTFLAGS	+= --pdf-page-margin-right 54
CONVERTFLAGS	+= --pdf-page-margin-left 54
CONVERTFLAGS	+= --pdf-page-numbers
CONVERTFLAGS	+= --toc-title "Index"

# Include subordinate makefiles

include ../../csharp/include/csharp.mk

# Build the projects

default:
	BUILDVERSION=$(VERSION) dotnet build $(LIBNAME).csproj -c $(CONFIGURATION)
	BUILDVERSION=$(VERSION) "$(MSBUILD)" $(LIBNAME).shfbproj
	$(CONVERT) Help/$(LIBNAME).chm Help/$(LIBNAME).pdf $(CONVERTFLAGS)
	mv Help/$(LIBNAME).chm Help/$(LIBNAME).dll.chm
	mv Help/$(LIBNAME).pdf Help/$(LIBNAME).dll.pdf
	install -cm 0644 Help/$(LIBNAME).dll.chm ../../doc
	install -cm 0644 Help/$(LIBNAME).dll.pdf ../../doc
	BUILDVERSION=$(VERSION) dotnet pack $(LIBNAME).csproj -c $(CONFIGURATION)
	rm -rf $(NUGETDIR)/$(LIBNAME)
	nuget add bin/$(CONFIGURATION)/*.nupkg -source $(NUGETDIR)
	$(FIND) $(NUGETDIR)/$(LIBNAME) -type f -exec chmod 644 {} ";"
	$(FIND) $(NUGETDIR)/$(LIBNAME) -type d -exec chmod 755 {} ";"
	cp bin/$(CONFIGURATION)/*.nupkg .

# Remove working files

clean: csharp_mk_clean
	rm -rf bin obj *.nupkg
