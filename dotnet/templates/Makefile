# Copyright (C)2020, Philip Munts, President, Munts AM Corp.
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

VERSION		= 1.0.`date '+%Y.%j'`
CONFIGURATION	= Release

# Build all NuGet packages

default:
	$(MAKE) build LIBNAME=libremoteio-templates && rm -rf bin obj
	$(MAKE) build LIBNAME=libsimpleio-templates && rm -rf bin obj

# Build a NuGet package containing the specified project templates

build:
	BUILDVERSION=$(VERSION) dotnet pack $(LIBNAME).csproj -c $(CONFIGURATION)
	cp bin/Release/*.nupkg .

# Remove working files

clean:
	rm -rf bin obj *.nupkg

# Install templates from libsimpleio installation or source checkout

install:
	dotnet new -i ./csharp_console_libremoteio
	dotnet new -i ./csharp_console_libsimpleio
