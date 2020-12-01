# Makefile definitions for building GNAT Ada application programs

# Copyright (C)2016-2020, Philip Munts, President, Munts AM Corp.
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

# These targets are not files

.PHONY: ada_mk_default ada_mk_clean ada_mk_reallyclean ada_mk_distclean

ifneq ($(BOARDNAME),)
ifeq ($(BOARDBASE),)
# Definitions for MuntsOS cross-compile
EMBLINUXBASE	?= $(HOME)/muntsos
include $(EMBLINUXBASE)/include/$(BOARDNAME).mk
endif
else
# Definitions for native compile
LIBSIMPLEIO	?= /usr/local/share/libsimpleio
ifneq ($(GNAT),)
GNATPREFIX	= $(GNAT)/bin/
endif
endif

# Definitions for Microsoft Windows

ifeq ($(OS), Windows_NT)
EXESUFFIX	= .exe
WINARCH		?= win64
ADA_LDFLAGS	+= -L$(LIBSIMPLEIO)/win/$(WINARCH)
endif

# Definitions for MacOS X

ifeq ($(shell uname), Darwin)
ADA_LDFLAGS	+= -L/Library/Developer/CommandLineTools/SDKs/MacOSX.sdk/usr/lib
ADA_LDFLAGS	+= -L/usr/local/lib
endif

# General toolchain definitions

ADA_CFLAGS	+= -g -gnat2012
ADA_OBJ		?= $(shell pwd)/obj

# Definitions for gnatmake

GNATMAKE	?= $(GNATPREFIX)gnatmake$(EXESUFFIX)
GNATMAKEFLAGS	= -D $(ADA_OBJ)
GNATMAKECFLAGS	+= $(ADA_CFLAGS) $(ADA_INCLUDES)
GNATMAKELDFLAGS	+= $(ADA_LDFLAGS)

# Definitions for other GNAT programs

GNATBIND	?= $(GNATPREFIX)gnatbind$(EXESUFFIX)
GNATLINK	?= $(GNATPREFIX)gnatlink$(EXESUFFIX)
GNATSTRIP	?= $(GNATPREFIX)strip$(EXESUFFIX)

# Definitions for gprbuild

ifneq ($(GNAT),)
GPRBUILD	?= $(GNAT)/bin/gprbuild$(EXESUFFIX)
else
GPRBUILD	?= gprbuild$(EXESUFFIX)
endif
GPRBUILDFLAGS	= -p $(GPRBUILDCONFIG) $(GPRBUILDTARGET) $(GPRBUILDPROJECTS)

# Define pattern rules for building Ada programs

%: %.gpr
# Build with explicit Ada program project file
	$(GPRBUILD) -P$< $(GPRBUILDFLAGS) $@
	$(GNATSTRIP) $@$(EXESUFFIX)
	chmod 755 $@$(EXESUFFIX)

ifneq ($(wildcard default.gpr),)
# Build with default Ada program project file
%:
	$(GPRBUILD) $(GPRBUILDFLAGS) $@
	$(GNATSTRIP) $@$(EXESUFFIX)
	chmod 755 $@$(EXESUFFIX)
else
# Build with gnatmake (deprecated)
%: %.adb
	mkdir -p $(ADA_OBJ)
	$(GNATMAKE) $(GNATMAKEFLAGS) $@ -cargs $(GNATMAKECFLAGS) -largs $(GNATMAKELDFLAGS)
	$(GNATSTRIP) $@$(EXESUFFIX)
	chmod 755 $@$(EXESUFFIX)
endif

# Default make target

ada_mk_default: default

# Remove working files

ada_mk_clean:
	rm -rf $(ADA_OBJ) *.exe *.o *.ali b~* *.stackdump

ada_mk_reallyclean: ada_mk_clean

ada_mk_distclean: ada_mk_reallyclean
