# Makefile for building Java libsimpleio example programs

# Copyright (C)2017-2021, Philip Munts, President, Munts AM Corp.
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

.PHONY: default clean reallyclean distclean

LIBSIMPLEIO	?= /usr/local/share/libsimpleio

include $(LIBSIMPLEIO)/java/include/java.mk

ifeq ($(OS), Windows_NT)
JAVAC_CLASSPATH	:= ".;$(LIBSIMPLEIO)/java/classes"
else
JAVAC_CLASSPATH	:= .:$(LIBSIMPLEIO)/java/classes
endif

JAR_COMPONENTS	+= com

# Override the .class rule, to remove debris and include JNA

%.class: %.java
	rm -rf $(JAR_COMPONENTS)
	jar xf $(LIBSIMPLEIO)/java/components/jna-4.4.0.jar com/sun/jna
	$(JAVAC) $(JAVAC_FLAGS) $<

# Build the applicaton JAR files

default:
	for F in *.java ; do $(MAKE) `basename $$F .java`.jar ; rm -rf $(JAR_COMPONENTS) *.manifest ; done

# Remove working files

clean: java_mk_clean
	rm -rf $(JAR_COMPONENTS)

reallyclean: java_mk_reallyclean

distclean: java_mk_distclean
