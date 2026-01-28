# Copyright (C)2026, Philip Munts dba Munts Technologies.
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
# JDK programs

LIBSIMPLEIO	?= /usr/local/share/libsimpleio

include $(LIBSIMPLEIO)/java/include/java.mk

JAVAC_FLAGS	:= -cp .:$(LIBSIMPLEIO)/java/jars/jna.jar -d .

SRCFILES	+= ../interfaces/*/*.java
SRCFILES	+= bindings/*.java
SRCFILES	+= common/*.java
SRCFILES	+= platforms/*.java
SRCFILES	+= subsystems/*/*.java

BUILDNUM	?= 1
VERSION		:= $(shell date +%Y.%j).$(BUILDNUM)
MANIFEST	:= libsimpleio.manifest
JARFILE		:= ../../jars/libsimpleio.jar

default:
	$(JAVAC) $(JAVAC_FLAGS) $(SRCFILES)
	echo "Implementation-Title:      Java binding to the Linux Simple I/O Library"	 >$(MANIFEST)
	echo "Implementation-Vendor:     Philip Munts dba Munts Technologies"		>>$(MANIFEST)
	echo "Implementation-Version:    $(VERSION)"					>>$(MANIFEST)
	echo "Implementation-Build-Date: $(shell date)"					>>$(MANIFEST)
	$(JAR) -cmf $(MANIFEST) $(JARFILE) com
	if [ -f $(JARSIGNER_KEYSTORE) ]; then $(JARSIGNER) -keystore $(JARSIGNER_KEYSTORE) $(JARSIGNER_FLAGS) $(JARFILE) $(JARSIGNER_ALIAS) ; fi
	rm -rf $(MANIFEST) com
