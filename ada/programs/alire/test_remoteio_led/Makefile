# Makefile to build an Alire program project and optionally deploy the
# executable program file(s) to the target computer

# Copyright (C)2023-2024, Philip Munts dba Munts Technologies.
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

default: build

ifneq ($(BOARDNAME),)
MUNTSOS	?= /usr/local/share/muntsos
include $(MUNTSOS)/include/$(BOARDNAME).mk
STRIP	:= $(CROSS_COMPILE)strip
endif

FIND	?= find
STRIP	?= strip

###############################################################################

# Build the Alire project

build:
	alr build $(ALRFLAGS)
ifneq ($(STRIP),)
	@if [ -x $(STRIP) ]; then $(FIND) bin -type f -not -name '*.dll' -exec $(STRIP) {} ";" ; fi
endif
ifneq ($(TARGETCOMPUTER),)
	scp $(SCPFLAGS) bin/* $(TARGETCOMPUTER)
endif

###############################################################################

# Clean the Alire project

clean:
	-$(FIND) bin -type f -not -name '*.dll' -delete
	rm -rf obj/*

reallyclean: clean

distclean:
	rm -rf alire bin config obj share
ifeq ($(shell uname), Darwin)
	rm -rf ~/.local/share/alire/builds
	rm -rf ~/.local/share/alire/releases
endif
ifeq ($(shell uname), Linux)
	rm -rf ~/.local/share/alire/builds
	rm -rf ~/.local/share/alire/releases
endif
ifeq ($(OS), Windows_NT)
	rm -rf ~/AppData/Local/alire/cache/builds
	rm -rf ~/AppData/Local/alire/cache/releases
endif
