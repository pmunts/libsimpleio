# Makefile definitions for C# programming

# Copyright (C)2014-2023, Philip Munts dba Munts Technologies.
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

CONFIGURATION	?= Release
CSC		?= C:/PROGRA~1/Microsoft Visual Studio/2022/Community/MSBuild/Current/Bin/Roslyn/csc.exe
MSBUILD		?= C:/PROGRA~1/Microsoft Visual Studio/2022/Community/MSBuild/Current/Bin/MSBuild.exe
MSBUILDTARGET	?= /t:Build
MSBUILDFLAGS	?= /p:Configuration=$(CONFIGURATION)
MSBUILDPROJECT	?=
NUGET		?= nuget.exe

# Define a pattern rule to compile a C# application with csc command line
# compiler (obsolete, but still works).

%.exe: %.cs
	"$(CSC)" $(CSCFLAGS) $^

# Placeholder default target

csharp_mk_default: default

# Restore NuGet packages

csharp_mk_restore:
	"$(NUGET)" restore $(MSBUILDPROJECT)

# Build Visual Studio C# project with MSBuild

csharp_mk_build:
	"$(MSBUILD)" $(MSBUILDTARGET) $(MSBUILDFLAGS) $(MSBUILDPROJECT)

# Clean out working files

csharp_mk_clean:
	rm -rf *.chm *.dll *.exe *.log *.mdb *.nupkg *.pdb *.runtimeconfig.json *.xml *~ Help packages
	$(LIBSIMPLEIO)/include/vsclean.sh
