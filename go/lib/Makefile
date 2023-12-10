# Makefile for building the Go import library for libsimpleio

# Copyright (C)2020-2023, Philip Munts dba Munts Technologies.
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

.PHONY: default clean reallyclean distclean

LIBSIMPLEIO	:= $(shell pwd)/../..
GO_SRC		:= $(LIBSIMPLEIO)/go

include $(GO_SRC)/include/gccgo.mk

GO_LIBSRC	+= $(GO_SRC)/src/interfaces
GO_LIBSRC	+= $(GO_SRC)/src/classes
GO_LIBSRC	+= $(GO_SRC)/src/classes/simpleio

default: $(GO_LIBFILE)

# Populate the import library directory

$(GO_LIBFILE):
	mkdir -p $(GO_LIB)
	for D in $(GO_LIBSRC) ; do $(MAKE) -C $$D GO_SRC=$(GO_SRC) GO_LIB=$(GO_LIB) ; done
	$(AR) rcs $@ $(GO_LIB)/*.o
	rm -f $(GO_LIB)/*.o
	$(RANLIB) $(GO_LIBFILE)

# Remove working files

clean:
	rm -rf $(GO_LIBNAME) $(GO_LIBFILE)
