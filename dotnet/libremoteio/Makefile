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

BUILDNUM	= 1
LIBNAME		= libremoteio
VERSION		= 2.`date '+%Y.%j'`.$(BUILDNUM)
CONFIGURATION	= Release

# Include subordinate makefiles

include ../../csharp/include/csharp.mk

# Build the projects

default:
	BUILDVERSION=$(VERSION) dotnet pack $(LIBNAME).csproj -c $(CONFIGURATION)
	cp bin/$(CONFIGURATION)/*.nupkg .
ifeq ($(OS),Windows_NT)
ifeq ($(CONFIGURATION), Release)
	"$(MSBUILD)" $(LIBNAME).shfbproj
	install -cm 0644 Help/$(LIBNAME).chm ../../doc
endif
endif

# Remove working files

clean: csharp_mk_clean
	rm -rf bin obj *.nupkg
