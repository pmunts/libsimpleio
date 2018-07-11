# Makefile for building Pascal example programs for MuntsOS

# Copyright (C)2013-2018, Philip Munts, President, Munts AM Corp.
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
LIBSIMPLEIO	?= $(GCCSYSROOT)/usr/share/libsimpleio
else
# Native compile for Linux
LIBSIMPLEIO	?= /usr/local/share/libsimpleio
endif

# Override the follow macro to build out of tree

PASCAL_SRC	?= $(LIBSIMPLEIO)/pascal

include $(PASCAL_SRC)/include/pascal.mk

FPC_FLAGS	+= -Fu$(PASCAL_SRC)/bindings
FPC_FLAGS	+= -Fu$(PASCAL_SRC)/devices
FPC_FLAGS	+= -Fu$(PASCAL_SRC)/interfaces
FPC_FLAGS	+= -Fu$(PASCAL_SRC)/objects
FPC_FLAGS	+= -Fu$(PASCAL_SRC)/remoteio

# Compile the test programs

default:
	for F in *.pas ; do $(MAKE) `basename $$F .pas` ; done

# Remove working files

clean: pascal_mk_clean
	for F in *.pas ; do rm -f `basename $$F .pas` ; done

reallyclean: pascal_mk_reallyclean clean

distclean: pascal_mk_distclean reallyclean
