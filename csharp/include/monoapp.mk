# Makefile for building a .Net Framework applicaiton for Mono

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

# Pick Visual Studio or Mono compiler

ifeq ($(OS), Windows_NT)
CSC		?= C:/PROGRA~2/Microsoft Visual Studio/2019/Community/MSBuild/Current/Bin/Roslyn/csc.exe
MSBUILD		?= C:/PROGRA~2/Microsoft Visual Studio/2019/Community/MSBuild/Current/Bin/MSBuild.exe
MSBUILDTARGET	?= /t:Build
MSBUILDFLAGS	?= /p:Configuration=$(CONFIGURATION)
MSBUILDPROJECT	?=
else
CSC		?= csc
MSBUILD		?= msbuild
MSBUILDTARGET	?= -t:Build
MSBUILDFLAGS	?= -p:Configuration=$(CONFIGURATION)
MSBUILDPROJECT	?=
endif

CSCFLAGS	+= -lib:$(LIBSIMPLEIO)/dotnet

# Compile C# application with csc

%.exe: %.cs
	$(LIBSIMPLEIO)/csharp/include/monolibs.sh $(CSCFLAGS)
	"$(CSC)" $(CSCFLAGS) $^

# Build Visual Studio C# project with MSBuild

monoapp_mk_build:
	"$(MSBUILD)" $(MSBUILDTARGET) $(MSBUILDFLAGS) $(MSBUILDPROJECT)

# Clean out working files

monoapp_mk_clean: csharp_mk_clean
