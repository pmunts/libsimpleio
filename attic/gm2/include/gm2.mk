# Common make definitons for compiling GNU Modula-2 programs

# Copyright (C)2018-2023, Philip Munts dba Munts Technologies.
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

###############################################################################

# Definitions for MuntsOS Embedded Linux

ifneq ($(BOARDNAME),)
MUNTSOS		?= /usr/local/share/muntsos
include $(MUNTSOS)/include/$(BOARDNAME).mk
endif

###############################################################################

AR		?= $(CROSS_COMPILE)ar
RANLIB		?= $(CROSS_COMPILE)ranlib
STRIP		?= $(CROSS_COMPILE)strip

GM2		?= $(CROSS_COMPILE)gm2
GM2_SRC		?= $(LIBSIMPLEIO)/attic/gm2
GM2_FLAGS	+= -fiso
GM2_FLAGS	+= -fsoft-check-all
#GM2_FLAGS	+= -Wpedantic
GM2_FLAGS	+= -I$(GM2_SRC)/bindings
GM2_FLAGS	+= -I$(GM2_SRC)/devices
GM2_FLAGS	+= -I$(GM2_SRC)/modules
GM2_LIBS	+= -L.
GM2_LIBS	+= -lsimpleio -lsimpleio-gm2

###############################################################################

# Define a rule for compiling a Modula-2 program

%: %.mod libsimpleio-gm2.a
	$(GM2) $(GM2_FLAGS) -o$@ $< $(GM2_LIBS)
	$(STRIP) $@

###############################################################################

# Default target placeholder

gm2_mk_default: default

##############################################################################

# Compile subordinate implementation modules

libsimpleio-gm2.a:
	$(GM2_SRC)/include/libsimpleio-gm2.py $(GM2) $(AR) "$(GM2_FLAGS)"

###############################################################################

# Clean out working files

gm2_mk_clean:
	rm -f *.s *.o

gm2_mk_reallyclean: gm2_mk_clean
	rm -rf libsimpleio-gm2.a

gm2_mk_distclean: gm2_mk_reallyclean
