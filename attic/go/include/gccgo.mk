# Makefile definitions for using gccgo to compile Go packages and programs

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

# The following targets are not files

.PHONY: go_mk_default go_mk_lib go_mk_clean go_mk_reallyclean go_mk_distclean

# Do not remove intermediate files

.SECONDARY:

ifneq ($(BOARDNAME),)
# Cross-compile for MuntsOS
MUNTSOS		?= /usr/local/share/muntsos
include $(MUNTSOS)/include/$(BOARDNAME).mk
GCCGO		:= $(CROSS_COMPILE)gccgo
AR		:= $(CROSS_COMPILE)ar
RANLIB		:= $(CROSS_COMPILE)ranlib
STRIP		:= $(CROSS_COMPILE)strip
else
# Native compile for Unix
GCCGO		?= $(CROSS_COMPILE)gccgo
AR		?= $(CROSS_COMPILE)ar
RANLIB		?= $(CROSS_COMPILE)ranlib
STRIP		?= $(CROSS_COMPILE)strip
endif

GO_SRC		?= $(LIBSIMPLEIO)/attic/go
GO_LIB		:= $(GO_SRC)/lib
GO_LIBFILE	:= $(GO_LIB)/munts.com.a
GO_LIBSRC	+= $(GO_SRC)/interfaces
GO_LIBSRC	+= $(GO_SRC)/objects

CFLAGS		+= -Wall $(DEBUGFLAGS) $(EXTRAFLAGS) -I$(GO_LIB)
LDFLAGS		+= $(GO_LIBFILE)

# Define a pattern rule to compile a Go program

%:%.go
	$(GCCGO) $(CFLAGS) -o $@ $*.go $(LDFLAGS)
	$(STRIP) $@

# Default make target

go_mk_default: default

# Compile subordinate modules

$(GO_LIBFILE):
	mkdir -p $(GO_LIB)
	for D in $(GO_LIBSRC) ; do $(MAKE) -C $$D GO_SRC=$(GO_SRC) GO_LIB=$(GO_LIB) ; done
	$(AR) rcs $@ $(GO_LIB)/*.o
	rm -f $(GO_LIB)/*.o
	$(RANLIB) $(GO_LIBFILE)

go_mk_lib: $(GO_LIBFILE)

# Remove working files

go_mk_clean:

go_mk_reallyclean: go_mk_clean

go_mk_distclean: go_mk_reallyclean
	rm -rf $(GO_LIB)
