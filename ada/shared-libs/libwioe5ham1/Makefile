# Copyright (C)2025, Philip Munts dba Munts Technologies.
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

include $(LIBSIMPLEIO)/ada/include/ada.mk
include $(LIBSIMPLEIO)/ada/include/libsimpleio.mk

default: libwioe5ham1.so

###############################################################################

# Gather subordinates

subordinates:
	mkdir -p							$@
	cp $(LIBSIMPLEIO)/ada/devices/wio_e5.*				$@
	cp $(LIBSIMPLEIO)/ada/devices/wio_e5-ham1.*			$@
	touch $@

###############################################################################

# Build the shared library project

libwioe5ham1.so: subordinates
	$(GPRBUILD) $(GPRBUILDFLAGS)
ifeq ($(shell uname), Linux)
	$(CROSS_COMPILE)strip lib/libwioe5ham1.so
ifeq ($(shell uname -m), x86_64)
	cp lib/libwioe5ham1.so ../../../linux/amd64
endif
ifeq ($(shell uname -m), aarch64)
	cp lib/libwioe5ham1.so ../../../linux/arm64
endif
endif
ifeq ($(OS), Windows_NT)
	cp lib/libwioe5ham1.dll ../../../win64/wioe5ham1.dll
endif

###############################################################################

ifeq ($(shell uname), Linux)
install: libwioe5ham1.so
	install -cm 0444 *.h		/usr/local/include
	install -cm 0555 lib/*.so	/usr/local/lib
endif

###############################################################################

# Remove working files

clean:
	rm -rf lib obj subordinates
