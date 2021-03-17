# Makefile definitions for building C++ example programs

# Copyright (C)2018-2021, Philip Munts, President, Munts AM Corp.
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

# Do not remove intermediate files

.SECONDARY:

ifneq ($(BOARDNAME),)
# Cross-compile for MuntsOS
MUNTSOS		?= $(HOME)/muntsos
include $(MUNTSOS)/include/$(BOARDNAME).mk

CXX	 	:= $(CROSS_COMPILE)g++
STRIP		:= $(CROSS_COMPILE)strip
else
# Native compile for Unix
ifeq ($(shell uname), FreeBSD)
CXX		:= g++10
STRIP		:= strip
endif
ifeq ($(shell uname), OpenBSD)
CXX		:= eg++
CXXFLAGS	+= -I/usr/local/include
STRIP		:= strip
endif
CXX		?= g++
STRIP		?= strip
endif

LIBFILE		:= subordinates.a
OBJDIR		:= subordinates.obj

CXXDEPS		+= $(LIBFILE)

CXXFLAGS	+= -Wall $(CFLAGS) $(DEBUGFLAGS) $(EXTRAFLAGS) -std=c++11
CXXFLAGS	+= -DWITH_ASSIGNMENT_OPERATORS
CXXFLAGS	+= -I$(LIBSIMPLEIO)/c
CXXFLAGS	+= -I$(LIBSIMPLEIO)/c++/devices
CXXFLAGS	+= -I$(LIBSIMPLEIO)/c++/interfaces
CXXFLAGS	+= -I$(LIBSIMPLEIO)/c++/objects

CXXSRCS		+= $(LIBSIMPLEIO)/c++/devices/*.cpp
CXXSRCS		+= $(LIBSIMPLEIO)/c++/interfaces/*.cpp
CXXSRCS		+= $(LIBSIMPLEIO)/c++/objects/*.cpp

LDFLAGS		+= $(LIBFILE)

# Define a pattern rule to compile a C++ program

%: %.cpp
	$(MAKE) $(CXXDEPS)
	$(CXX) $(CXXFLAGS) -o $@ $< $(LDFLAGS)
	$(STRIP) $@

# Default make target

cxx_mk_default: default

# Build the C++ class library

$(LIBFILE):
	mkdir -p $(OBJDIR)
	for F in $(CXXSRCS) ; do $(CXX) $(CXXFLAGS) -c -o $(OBJDIR)/`basename $$F .c`.o $$F ; done
	$(AR) rcs $@ $(OBJDIR)/*.o
	rm -rf $(OBJDIR)

# Remove working files

cxx_mk_clean:
	rm -rf *.o *.core

cxx_mk_reallyclean: cxx_mk_clean
	rm -f $(CXXDEPS)

cxx_mk_distclean: cxx_mk_reallyclean
