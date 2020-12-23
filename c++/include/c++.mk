# Makefile definitions for building C++ example programs

# Copyright (C)2018-2020, Philip Munts, President, Munts AM Corp.
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
CXX	 	:= $(CROSS_COMPILE)g++
STRIP		:= $(CROSS_COMPILE)strip
else
# Native compile for Unix
ifeq ($(shell uname), OpenBSD)
CXX		:= eg++
CXXFLAGS	+= -I/usr/local/include
STRIP		:= strip
endif
endif

CXXFLAGS	+= -Wall $(CFLAGS) $(DEBUGFLAGS) $(EXTRAFLAGS) -std=c++11

# Define a pattern rule to compile a C++ program

%: %.cpp
	$(MAKE) $(CXXDEPS)
	$(CXX) $(CXXFLAGS) -o $@ $< $(LDFLAGS)
	$(STRIP) $@

# Default make target

cxx_mk_default: default

# Remove working files

cxx_mk_clean:
	rm -rf *.a *.o *.core

cxx_mk_reallyclean: cxx_mk_clean

cxx_mk_distclean: cxx_mk_reallyclean
