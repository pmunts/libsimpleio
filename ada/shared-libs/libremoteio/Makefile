# Copyright (C)2021-2023, Philip Munts dba Munts Technologies.
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

LIBSIMPLEIO	?= ../../..

.PHONY: build install clean

GPRBUILD	?= gprbuild

ifeq ($(OS), Windows_NT)
LIBFILE		:= libremoteio.dll
LIBDIR		:= $(LIBSIMPLEIO)/win64
INSTALL		:= install -cm 0644 libremoteio.dll libremoteio.lib $(LIBDIR)
VSTOOLS		:= C:/Program Files/Microsoft Visual Studio/2022/Community/VC/Tools/MSVC/14.38.33130/bin/Hostx64/x64
VSLIB		:= $(VSTOOLS)/lib
else
OS		:= Linux
LIBFILE		:= libremoteio.so
LIBDIR		:= /usr/local/lib
INSTALL		:= sudo install -cm 0444 libremoteio.h /usr/local/include && sudo install -cm 0555 $(LIBFILE) $(LIBDIR) && sudo ldconfig
endif

build:
	rm -rf obj
	sed -i 's/  PRAGMA Link_With/--PRAGMA Link_With/g' $(LIBSIMPLEIO)/ada/objects/hid-hidapi.ads
	LIBSIMPLEIO=$(LIBSIMPLEIO) OS=$(OS) $(GPRBUILD) -p
	sed -i 's/--PRAGMA Link_With/  PRAGMA Link_With/g' $(LIBSIMPLEIO)/ada/objects/hid-hidapi.ads
	cp obj/lib/$(LIBFILE) .
	rm -rf obj
ifeq ($(OS), Windows_NT)
	echo "EXPORTS" >libremoteio.def
	awk -F '[ (]' '/extern/ { print $$4 }' libremoteio.h >>libremoteio.def
	"$(VSLIB)" /def:libremoteio.def /out:libremoteio.lib /machine:x64
endif

install: build
	$(INSTALL)

clean:
	sed -i 's/--PRAGMA Link_With/  PRAGMA Link_With/g' $(LIBSIMPLEIO)/ada/objects/hid-hidapi.ads
	rm -rf obj *.def *.dll *.exp *.lib *.so
