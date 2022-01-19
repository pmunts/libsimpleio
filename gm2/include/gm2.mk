# Common make definitons for compiling GNU Modula-2 programs

# Copyright (C)2018-2022, Philip Munts, President, Munts AM Corp.
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

ifeq ($(BOARDBASE),)
MUNTSOS		?= $(HOME)/muntsos
include $(MUNTSOS)/include/$(BOARDNAME).mk
endif

###############################################################################

GM2		?= $(CROSS_COMPILE)gm2
AR		?= $(CROSS_COMPILE)ar
RANLIB		?= $(CROSS_COMPILE)ranlib
STRIP		?= $(CROSS_COMPILE)strip

GM2_DIALECT	?= iso
GM2_FLAGS	+= -f$(GM2_DIALECT) -fsoft-check-all -Wpedantic -Wstudents
GM2_FLAGS	+= -ftarget-ar=$(AR) -ftarget-ranlib=$(RANLIB)
GM2_LIBS	+= -l:libm2iso.a -l:libm2pim.a -l:libsimpleio.a

###############################################################################

# Define a rule for compiling a Modula-2 program

%: %.mod subordinates.a
	$(GM2) $(GM2_FLAGS) -o$@ $^ $(GM2_LIBS)
	$(STRIP) $@

###############################################################################

# Default target placeholder

gm2_mk_default: default

##############################################################################

# Compile subordinate implementation modules

subordinates.a:
	$(LIBSIMPLEIO)/gm2/include/subordinates.py $(GM2) $(AR) "$(GM2_FLAGS)"

###############################################################################

# Clean out working files

gm2_mk_clean:
	rm -f *.s *.o

gm2_mk_reallyclean: gm2_mk_clean
	rm -rf subordinates.a

gm2_mk_distclean: gm2_mk_reallyclean
