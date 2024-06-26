# Makefile definitions for RemObjects Elements programming

# Copyright (C)2018-2024, Philip Munts dba Munts Technologies.
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

include $(LIBSIMPLEIO)/include/common.mk

ifeq ($(shell uname), Darwin)
FIRERESOURCES	?= $(HOME)/Applications/Fire.app/Contents/Resources
MONO		?= $(FIRERESOURCES)/Mono/bin/mono-sgen
EBUILD		?= $(MONO) $(FIRERESOURCES)/EBuild.exe
EBUILDFLAGS	+= --setting:Elements:IslandSDKFolder=$(FIRERESOURCES)/"Island SDKs"
endif

ifeq ($(OS), Windows_NT)
EBUILD		?= "C:/Program Files (x86)/RemObjects Software/Elements/Bin/EBuild.exe"
endif

CONFIGURATION	?= Release
EBUILDFLAGS	+= --configuration:$(CONFIGURATION)

ifneq ($(BOARDNAME),)
EBUILDFLAGS	+= --setting:ExtraConditionalDefines=$(BOARDNAME)
endif

# Don't delete intermediate files

.SECONDARY:

# Default target placeholder

elements_mk_default: default

# Build project using EBuild

elements_mk_build:
	$(EBUILD) $(EBUILDFLAGS)

# Fixup permissions etc.

elements_mk_fixup:
	$(FIND) . -type f -exec chmod 644 {} ";"
	$(FIND) . -type f -exec bom_remove {} ";"
	$(FIND) . -type f -exec unix2dos {} ";"
	$(FIND) . -name Makefile -exec dos2unix {} ";"

# Clean out working files

elements_mk_clean:
	rm -rf bin obj Bin Obj *.dll *.exe *.json *.log *.mdb *.nupkg *.pdb *.xml *~ *.cache *.user
	$(LIBSIMPLEIO)/include/vsclean.sh
