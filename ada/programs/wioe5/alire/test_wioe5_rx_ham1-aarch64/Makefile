# Makefile to build a MuntsOS Embedde Linux  Alire program project and
# optionally deploy the executable program file(s) to a target computer via scp

# Copyright (C)2024, Philip Munts dba Munts Technologies.
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

STRIP	?= /usr/local/gcc-aarch64-muntsos-linux-gnu-ctng/bin/aarch64-muntsos-linux-gnu-strip

###############################################################################

# Build the Alire project

build:
	alr build $(ALRFLAGS)
ifneq ($(STRIP),)
	$(STRIP) bin/*
endif
ifneq ($(TARGETCOMPUTER),)
	scp $(SCPFLAGS) bin/* $(TARGETCOMPUTER)
endif

###############################################################################

# Clean the Alire project

clean:
	rm -rf bin/* obj/*

reallyclean: clean
	rm -rf alire bin config obj share

distclean: reallyclean
	rm -rf ~/.local/share/alire/builds
	rm -rf ~/.local/share/alire/releases
