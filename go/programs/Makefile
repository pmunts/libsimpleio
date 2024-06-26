# Makefile for building Go programs with gccgo

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

# Override the following macros to build out of tree

LIBSIMPLEIO	?= /usr/local/share/libsimpleio
GO_SRC		?= $(LIBSIMPLEIO)/go

# Include subordinate makefiles

include $(GO_SRC)/include/gccgo.mk
include $(GO_SRC)/include/libsimpleio.mk

# Compile the test programs

default:
	for F in *.go ; do $(MAKE) `basename $$F .go` ; done

# Remove working files

clean: go_mk_clean
	for F in *.go ; do rm -f `basename $$F .go` ; done

reallyclean: clean go_mk_reallyclean

distclean: reallyclean go_mk_distclean
