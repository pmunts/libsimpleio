# Makefile for building the Remote I/O Library for .Net

# Copyright (C)2018, Philip Munts, President, Munts AM Corp.
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

# Override the following macro to build out of tree

CSHARPSRC	?= ..

CONFIGURATION	= Release

ILMERGE		?= ilmerge

# Build the projects

libremoteio.dll:
	"$(MSBUILD)" $(MSBUILDTARGET) $(MSBUILDFLAGS) libremoteio.csproj
ifeq ($(OS),Windows_NT)
ifeq ($(CONFIGURATION), Release)
	"$(MSBUILD)" libremoteio.shfbproj
endif
endif

# Release the assembly and help file

ifeq ($(OS),Windows_NT)
ifeq ($(CONFIGURATION), Release)
release: libremoteio.dll
	mv libremoteio.dll libremoteio-orig.dll
	$(ILMERGE) /v4 /out:libremoteio.dll libremoteio-orig.dll HidSharp.dll
	cp libremoteio.dll libremoteio.xml libremoteio.chm ..
endif
endif

# Remove working files

clean: csharp_mk_clean
	rm -rf IO.Devices
	rm -rf IO.Interfaces
	rm -rf IO.Objects
	rm -rf IO.Remote
	rm -rf IO.SPIAgent

# Include subordinate makefiles

include $(CSHARPSRC)/include/csharp.mk
