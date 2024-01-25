# Makefile for compiling a collection of packages with gccgo

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

include $(GO_SRC)/include/gccgo.mk

MYCOLLECTION	:= munts.com/classes
OBJ		:= $(GO_LIBDIR)/$(MYCOLLECTION)

# What this collection depends on

CFLAGS		+= -I$(GO_LIBDIR)/munts.com/interfaces

# What to compile for this collection

MYMODULES	+= unsafeConvert
MYMODULES	+= Error

# Compile the modules in this collection

default:
	mkdir -p $(OBJ)
	for P in $(MYMODULES) ; do $(GCCGO) $(CFLAGS) -I$(OBJ) -c -o$(OBJ)/$$P.o $$P.go ; cp $(OBJ)/$$P.o $(GO_LIBDIR)/$(shell echo $(MYCOLLECTION) | sed 's@/@-@g')-$$P.o ; done
