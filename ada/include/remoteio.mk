# GNAT Ada definitions for Remote I/O

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

ADA_INCLUDES	+= -I$(LIBSIMPLEIO)/ada/bindings
ADA_INCLUDES	+= -I$(LIBSIMPLEIO)/ada/clickboards
ADA_INCLUDES	+= -I$(LIBSIMPLEIO)/ada/clickboards/remoteio
ADA_INCLUDES	+= -I$(LIBSIMPLEIO)/ada/devices
ADA_INCLUDES	+= -I$(LIBSIMPLEIO)/ada/interfaces
ADA_INCLUDES	+= -I$(LIBSIMPLEIO)/ada/objects
ADA_INCLUDES	+= -I$(LIBSIMPLEIO)/ada/platforms
ADA_INCLUDES	+= -I$(LIBSIMPLEIO)/ada/remoteio
ADA_INCLUDES	+= -I$(LIBSIMPLEIO)/ada/remoteio/client
ADA_INCLUDES	+= -I$(LIBSIMPLEIO)/ada/remoteio/server

# Special goop for AdaCore GNAT for Windows

ifneq ($(GNAT_ADACORE),)
ifeq ($(OS), Windows_NT)
WINARCH		?= win64
GNATMAKELDFLAGS	+= -L$(LIBSIMPLEIO)/win/$(WINARCH)

hidapi.dll:
	cp $(LIBSIMPLEIO)/win/$(WINARCH)/hidapi.dll .

libusb-1.0.dll:
	cp $(LIBSIMPLEIO)/win/$(WINARCH)/libusb-1.0.dll .
endif
endif
