# Makefile definitions for building GNAT Ada application programs

# Copyright (C)2016-2018, Philip Munts, President, Munts AM Corp.
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

# Do not remove intermediate files

.SECONDARY:

# Definitions for MuntsOS

ifneq ($(BOARDNAME),)
ifeq  ($(BOARDBASE),)
EMBLINUXBASE	?= $(HOME)/arm-linux-mcu
include $(EMBLINUXBASE)/include/$(BOARDNAME).mk
endif
endif

# Definitions for Microsoft Windows

ifeq ($(OS),Windows_NT)
EXESUFFIX	= .exe
endif

# General toolchain definitions

ADA_OBJ		?= $(shell pwd)/obj
GNATENV		+= ADA_SRC=$(ADA_SRC) ADA_OBJ=$(ADA_OBJ)

# Definitions for gnatmake

GNATMAKE	?= env $(GNATENV) $(GNATPREFIX)gnatmake
GNATMAKEFLAGS	= -D $(ADA_OBJ)
GNATMAKECFLAGS	+= -gnat2012 $(ADA_CFLAGS) $(ADA_INCLUDES)
GNATMAKELDFLAGS	+= $(ADA_LDFLAGS)

# Definitions for strip

GNATSTRIP	?= env $(GNATENV) $(GNATPREFIX)strip

# Definitions for gprbuild

GPRBUILD	?= env $(GNATENV) gprbuild
GPRBUILDFLAGS	= -p $(GPRBUILDCONFIG) $(GPRBUILDTARGET) $(GPRBUILDPROJECTS)
GPRBUILDCFLAGS	+= -gnat2012 $(ADA_CFLAGS)
GPRBUILDLDFLAGS	+= $(ADA_LDFLAGS)

# Definitions for AdaCore GNAT native toolchains

ifneq ($(GNAT_ADACORE),)
GNATENV		+= PATH=$(GNAT_ADACORE)/bin:$(PATH)
ifeq ($(OS), Windows_NT)
# Windows needs even more help with the path
GNATMAKE	= env $(GNATENV) $(GNAT_ADACORE)/bin/gnatmake
GNATSTRIP	= env $(GNATENV) $(GNAT_ADACORE)/bin/strip
GPRBUILD	= env $(GNATENV) $(GNAT_ADACORE)/bin/gprbuild
endif
endif

# Define pattern rules for building Ada programs

%: %.gpr
	$(GPRBUILD) $< $(GPRBUILDFLAGS) -cargs $(GPRBUILDCFLAGS) -largs $(GPRBUILDLDFLAGS)
	$(GNATSTRIP) $@$(EXESUFFIX)

%: %.adb
	mkdir -p $(ADA_OBJ)
	$(GNATMAKE) $(GNATMAKEFLAGS) $< -cargs $(GNATMAKECFLAGS) -largs $(GNATMAKELDFLAGS)
	$(GNATSTRIP) $@$(EXESUFFIX)

# Default make target

ada_mk_default: default

# Remove working files

ada_mk_clean:
	rm -rf $(ADA_OBJ) *.exe *.o *.ali b~* *.stackdump

ada_mk_reallyclean: ada_mk_clean

ada_mk_distclean: ada_mk_reallyclean
