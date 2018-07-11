# Makefile for building C++ example programs

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
include $(EMBLINUXBASE)/include/$(BOARDNAME).mk
endif

# Modify the following macro to build out of tree

CXX_SRC		?= $(LIBSIMPLEIO)/c++

CXX	 	= $(CROSS_COMPILE)g++
STRIP		= $(CROSS_COMPILE)strip

CXXFLAGS	+= -Wall $(CFLAGS) $(DEBUGFLAGS) $(EXTRAFLAGS) -std=c++11
CXXFLAGS	+= -I$(CXX_SRC)/devices
CXXFLAGS	+= -I$(CXX_SRC)/interfaces
CXXFLAGS	+= -I$(CXX_SRC)/objects
LDFLAGS		+= -L. -lsimpleio -lsimpleio++

# Default target placeholder

cxx_mk_default: default

# Define a pattern rule to compile a C++ program

%: %.cpp libsimpleio++.a
	$(CXX) $(CXXFLAGS) -o $@ $< $(LDFLAGS)
	$(STRIP) $@

# Build the C++ class library

libsimpleio++.a:
	for F in $(LIBSIMPLEIO)/c++/interfaces/*.cpp ; do $(CXX) $(CXXFLAGS) -c -o `basename $$F .c`.o $$F ; done
	for F in $(LIBSIMPLEIO)/c++/objects/*.cpp    ; do $(CXX) $(CXXFLAGS) -c -o `basename $$F .c`.o $$F ; done
	for F in $(LIBSIMPLEIO)/c++/devices/*.cpp    ; do $(CXX) $(CXXFLAGS) -c -o `basename $$F .c`.o $$F ; done
	$(AR) rcs $@ *.o
	rm -f *.o

# Remove working files

cxx_mk_clean:
	for F in *.cpp ; do rm -f `basename $$F .cpp` ; done

cxx_mk_reallyclean: cxx_mk_clean
	rm -f *.a

cxx_mk_distclean: cxx_mk_reallyclean
