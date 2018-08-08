# Makefile definitions for C# programming

# Copyright (C)2014-2018, Philip Munts, President, Munts AM Corp.
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

# Pick Visual Studio or Mono compiler

ifeq ($(OS), Windows_NT)
CSC		?= C:/PROGRA~2/MSBuild/14.0/Bin/csc.exe
MSBUILD		?= C:/PROGRA~2/MSBuild/14.0/Bin/MSBuild.exe
MSBUILDTARGET	?= /t:Build
MSBUILDFLAGS	?= /p:Configuration=$(CONFIGURATION) /p:CSHARPSRC=$(CSHARPSRC)
MSBUILDPROJECT	?=
else
CSC		?= mcs
MSBUILD		?= msbuild
MSBUILDTARGET	?= /t:Build
MSBUILDFLAGS	?= /p:Configuration=$(CONFIGURATION) /p:CSHARPSRC=$(CSHARPSRC)
MSBUILDPROJECT	?=
endif

# Don't delete intermediate files

.SECONDARY:

# C# pattern rules

%.exe: %.cs
	"$(CSC)" $(CSCFLAGS) $^

# This default target placeholder depends on the default target
# in the superordinate Makefile

csharp_mk_default: default

# Clean out working files

csharp_mk_clean:
	rm -rf *.chm *.dll *.exe *.log *.mdb *.nupkg *.pdb *.xml *~ Help
	-$(CSHARPSRC)/include/vsclean.sh

# Build Visual Studio C# project with MSBuild

csharp_mk_build:
	"$(MSBUILD)" $(MSBUILDTARGET) $(MSBUILDFLAGS) $(MSBUILDPROJECT)

# Include subordinate makefiles

ifeq ($(shell uname), Darwin)
sinclude $(CSHARPSRC)/MacOS/MonoApp.mk
endif
