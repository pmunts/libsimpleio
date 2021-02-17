# C++ make definitions for building Remote I/O Protocol clients

# Copyright (C)2020-2021, Philip Munts, President, Munts AM Corp.
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

LIBFILE		:= subordinates.a
OBJDIR		:= subordinates.obj

CXXDEPS		+= $(LIBFILE)

CXXFLAGS	+= -DWITH_ASSIGNMENT_OPERATORS
CXXFLAGS	+= -I$(LIBSIMPLEIO)/c++/devices
CXXFLAGS	+= -I$(LIBSIMPLEIO)/c++/interfaces
CXXFLAGS	+= -I$(LIBSIMPLEIO)/c++/objects
CXXFLAGS	+= -I$(LIBSIMPLEIO)/c++/objects/remoteio

CXXSRCS		+= $(LIBSIMPLEIO)/c++/devices/*.cpp
CXXSRCS		+= $(LIBSIMPLEIO)/c++/interfaces/*.cpp
CXXSRCS		+= $(LIBSIMPLEIO)/c++/objects/*.cpp
CXXSRCS		+= $(LIBSIMPLEIO)/c++/objects/remoteio/*.cpp

LDFLAGS		+= -L. $(LIBFILE)

# Different targets need different HID implementations

ifneq ($(BOARDNAME),)
# Cross-compile for MuntsOS
HID_USE		?= libsimpleio
else
# Native compile for Unix
ifeq ($(findstring CYGWIN, $(shell uname)), CYGWIN)
HID_USE		?= hidapi
endif
ifeq ($(shell uname), Linux)
HID_USE		?= posix
endif
ifeq ($(shell uname), FreeBSD)
HID_USE		?= posix
endif
ifeq ($(shell uname), OpenBSD)
HID_USE		?= posix
endif
endif

# Select which USB raw HID library to use

ifeq ($(HID_USE), hidapi)
CXXFLAGS	+= -DHID_USE_HIDAPI
LDFLAGS		+= -lhidapi
else ifeq ($(HID_USE), libsimpleio)
CXXFLAGS	+= -DHID_USE_LIBSIMPLEIO
CXXFLAGS	+= -I$(LIBSIMPLEIO)/c++/objects/simpleio
CXXSRCS		+= $(LIBSIMPLEIO)/c++/objects/simpleio/hid-libsimpleio.cpp
LDFLAGS		+= -lsimpleio
else ifeq ($(HID_USE), libusb)
CXXFLAGS	+= -DHID_USE_LIBUSB
ifeq ($(shell uname), FreeBSD)
LDFLAGS		+= -lusb
else
LDFLAGS		+= -lusb-1.0
endif
else ifeq ($(HID_USE), posix)
CXXFLAGS	+= -DHID_USE_POSIX
endif

# Build the C++ class library

$(LIBFILE):
	mkdir -p $(OBJDIR)
	for F in $(CXXSRCS) ; do $(CXX) $(CXXFLAGS) -c -o $(OBJDIR)/`basename $$F .c`.o $$F ; done
	$(AR) rcs $@ $(OBJDIR)/*.o
	rm -rf $(OBJDIR)

remoteio_mk_lib: $(LIBFILE)

# Remove working files

remoteio_mk_clean:
	rm -rf $(LIBFILE) $(OBJDIR)

remoteio_mk_reallyclean: remoteio_mk_clean

remoteio_mk_distclean: remoteio_mk_reallyclean
