# Build library containing compiled implementation modules

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

# NOTE: Build with: gmake -R

###############################################################################

# Definitions for MuntsOS Embedded Linux

ifneq ($(BOARDNAME),)
MUNTSOS		?= /usr/local/share/muntsos
include $(MUNTSOS)/include/$(BOARDNAME).mk
endif

# Override the following macro to build out of tree:

LIBSIMPLEIO	?= /usr/local/share/libsimpleio

include $(LIBSIMPLEIO)/gm2/include/gm2.mk
#include $(LIBSIMPLEIO)/gm2/include/libremoteio.mk
include $(LIBSIMPLEIO)/gm2/include/libsimpleio.mk

default: $(LIBSIMPLEIOGM2)

##############################################################################

# Compile subordinate implementation modules

$(LIBSIMPLEIOGM2):
	$(GM2_SRC)/lib/makelib.py $(GM2) $(AR) "$(GM2_CFLAGS)" "$@"

###############################################################################

# Clean out working files

clean: gm2_mk_clean
	rm -f $(LIBSIMPLEIOGM2)

reallyclean: gm2_mk_reallyclean

distclean: gm2_mk_distclean
