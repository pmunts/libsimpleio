# Makefile definitions for using gccgo to compile Go packages and programs

# Copyright (C)2020-2024, Philip Munts dba Munts Technologies.
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

.PHONY: go_mk_default go_mk_clean go_mk_reallyclean go_mk_distclean

# Do not remove intermediate files

.SECONDARY:

ifneq ($(BOARDNAME),)
# Cross-compile for MuntsOS
MUNTSOS		?= /usr/local/share/muntsos
include $(MUNTSOS)/include/$(BOARDNAME).mk
endif

GCCGO		?= $(CROSS_COMPILE)gccgo
AR		?= $(CROSS_COMPILE)ar
RANLIB		?= $(CROSS_COMPILE)ranlib
STRIP		?= $(CROSS_COMPILE)strip

GO_SRC		?= $(LIBSIMPLEIO)/go
GO_LIBDIR	:= $(shell pwd)/subordinates.d
GO_LIBFILE	:= $(GO_LIBDIR)/subordinates.a

GO_LIBSRC	+= $(GO_SRC)/interfaces
GO_LIBSRC	+= $(GO_SRC)/classes

CFLAGS		+= -Wall $(DEBUGFLAGS) $(EXTRAFLAGS) -I$(GO_LIBDIR)
LDFLAGS		+= $(GO_LIBFILE)

# Default make target

go_mk_default: default

# Define a pattern rule to compile a Go program using the component library

% : %.go
	$(MAKE) $(GO_LIBFILE)
	$(GCCGO) $(CFLAGS) -o $@ $*.go $(LDFLAGS)
	$(STRIP) $@

# Make the component library

$(GO_LIBFILE):
	mkdir -p $(GO_LIBDIR)
	for D in $(GO_LIBSRC) ; do $(MAKE) -C $$D GO_SRC=$(GO_SRC) GO_LIBDIR=$(GO_LIBDIR) ; done
	$(AR) rcs $(GO_LIBFILE) $(GO_LIBDIR)/*.o
	rm -f $(GO_LIBDIR)/*.o
	$(RANLIB) $(GO_LIBFILE)

go_mk_library: $(GO_LIBFILE)

# Remove working files

go_mk_clean:

go_mk_reallyclean: go_mk_clean
	rm -rf $(GO_LIBDIR)

go_mk_distclean: go_mk_reallyclean
