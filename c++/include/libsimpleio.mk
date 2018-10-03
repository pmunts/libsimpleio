# C++ make definitions for libsimpleio

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

CXXFLAGS	+= -I$(LIBSIMPLEIO)/c++/devices
CXXFLAGS	+= -I$(LIBSIMPLEIO)/c++/interfaces
CXXFLAGS	+= -I$(LIBSIMPLEIO)/c++/objects

LDFLAGS		+= -L. -lsimpleio -lsimpleio++

# Build the C++ class library

libsimpleio++.a:
	for F in $(LIBSIMPLEIO)/c++/devices/*.cpp    ; do $(CXX) $(CXXFLAGS) -c -o `basename $$F .c`.o $$F ; done
	for F in $(LIBSIMPLEIO)/c++/interfaces/*.cpp ; do $(CXX) $(CXXFLAGS) -c -o `basename $$F .c`.o $$F ; done
	for F in $(LIBSIMPLEIO)/c++/objects/*.cpp    ; do $(CXX) $(CXXFLAGS) -c -o `basename $$F .c`.o $$F ; done
	$(AR) rcs $@ *.o
	rm -f *.o

# Remove working files

libsimpleio_mk_clean:
	rm -f libsimpleio++.a

libsimpleio_mk_reallyclean: libsimpleio_mk_clean

libsimpleio_mk_distclean: libsimpleio_mk_reallyclean
