# Makefile for building Ada example programs

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

ifneq ($(BOARDNAME),)
# Cross compile for MuntsOS
EMBLINUXBASE	?= $(HOME)/arm-linux-mcu
ADA_SRC		?= $(EMBLINUXBASE)/examples/ada
include $(ADA_SRC)/include/ada.mk
LIBSIMPLEIO	?= $(GCCSYSROOT)/usr/share/libsimpleio
else
# Native compile for Linux
LIBSIMPLEIO	?= /usr/local/share/libsimpleio
ADA_SRC		?= $(LIBSIMPLEIO)/ada
include $(ADA_SRC)/include/ada.mk
endif

include $(LIBSIMPLEIO)/ada/include/libsimpleio.mk
include $(LIBSIMPLEIO)/ada/include/remoteio.mk

ifneq ($(DLL),)
GNATMAKELDFLAGS	+= -L$(DLL)
endif

# Compile the test programs

default:
	for F in *.adb ; do $(MAKE) `basename $$F .adb` ; done

ifeq ($(OS), Windows_NT)
ifneq ($(DLL),)
# Copy Windows DLL files, if any

hidapi.dll:
	cp $(DLL)/hidapi.dll $@

libusb-1.0.dll:
	cp $(DLL)/libusb-1.0.dll $@

dll: hidapi.dll libusb-1.0.dll
endif
endif

# Remove working files

clean: ada_mk_clean
	for F in *.adb ; do rm -f `basename $$F .adb` ; done

reallyclean: clean ada_mk_reallyclean
	rm -rf *.dll

distclean: reallyclean ada_mk_distclean
