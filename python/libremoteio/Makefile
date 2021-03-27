# Copyright (C)2021, Philip Munts, President, Munts AM Corp.
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

LIBSIMPLEIO ?= /usr/local/share/libsimpleio

.PHONY: build install clean

ifneq ($(GNAT),)
GPRBUILD := $(GNAT)/bin/gprbuild
else
GPRBUILD := gprbuild
endif

ifeq ($(shell uname), Linux)
OS       := Linux
LIBFILE  := obj/lib/libremoteio.so
LIBDIR   := /usr/local/lib
INSTALL  := sudo install -cm 0555 $(LIBFILE) $(LIBDIR) && sudo ldconfig
else
LIBFILE  := obj/lib/libremoteio.dll
LIBDIR   := $(LIBSIMPLEIO)/win/win64
INSTALL  := install -cm 0644 $(LIBFILE) $(LIBDIR)
endif

build:
	sed -i 's/  PRAGMA Link_With/--PRAGMA Link_With/g' $(LIBSIMPLEIO)/ada/objects/hid-hidapi.ads
	LIBSIMPLEIO=$(LIBSIMPLEIO) OS=$(OS) $(GPRBUILD) -p

install: build
	$(INSTALL)

clean:
	sed -i 's/--PRAGMA Link_With/  PRAGMA Link_With/g' $(LIBSIMPLEIO)/ada/objects/hid-hidapi.ads
	rm -rf obj
