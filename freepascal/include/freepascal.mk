# Makefile definitions for building Free Pascal application programs

# Copyright (C)2013-2023, Philip Munts, President, Munts AM Corp.
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

FPC		?= $(FREEPASCALPREFIX)fpc
OBJ		?= obj
FPC_FLAGS	+= -Mobjfpc -CX -Sh -Xs -XX -g -gl -FE. -FU$(OBJ) $(FPC_EXTRAFLAGS)

PTOP		?= $(FREEPASCALPREFIX)ptop
PTOP_CFG	= $(PASCAL_SRC)/ptop.cfg
PTOP_FLAGS	= -i 2 -c $(PTOP_CFG)

###############################################################################

# Check for MacOS X

ifeq ($(shell uname), Darwin)
ifeq ($(shell uname -m), arm64)
FPC_FLAGS	+= -Paarch64
ifeq ($(wildcard /opt/homebrew), /opt/homebrew)
FPC_FLAGS	+= -Fl/opt/homebrew/lib
endif
endif
endif

###############################################################################

# Windows programs need the .EXE file extension

ifeq ($(OS),Windows_NT)
EXESUFFIX	= .exe
endif

###############################################################################

# Define a pattern rule to compile a Pascal program

%: %.pas
	mkdir -p $(OBJ)
	$(FPC) $(FPC_FLAGS) $(FPC_LDFLAGS) -o$@$(EXESUFFIX) $^

# We dislike the .pp file extension, but we support it anyway

%: %.pp
	mkdir -p $(OBJ)
	$(FPC) $(FPC_FLAGS) $(FPC_LDFLAGS) -o$@$(EXESUFFIX) $^

###############################################################################

# Define a pattern rule to compile a Pascal unit

%.ppu: %.pas
	mkdir -p $(OBJ)
	$(FPC) $(FPC_FLAGS) -o$@ $^

# We dislike the .pp file extension, but we support it anyway

%.ppu: %.pp
	mkdir -p $(OBJ)
	$(FPC) $(FPC_FLAGS) -o$@ $^

###############################################################################

# Define a pattern rule to format a Pascal source file

%.prettyprint: %.pas
	$(PTOP) $(PTOP_FLAGS) $< $<.tmp && mv $<.tmp $<

# We dislike the .pp file extension, but we support it anyway

%.prettyprint: %.pp
	$(PTOP) $(PTOP_FLAGS) $< $<.tmp && mv $<.tmp $<

###############################################################################

# Define default target placeholder

freepascal_mk_default: default

###############################################################################

# Clean out working files

freepascal_mk_clean:
	if [ "$(OBJ)" != "." ]; then rm -rf $(OBJ) ; fi

freepascal_mk_reallyclean: freepascal_mk_clean

freepascal_mk_distclean: freepascal_mk_reallyclean
