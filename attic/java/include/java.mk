# Makefile definitions for developing Java applications

# Copyright (C)2013-2026, Philip Munts, President, Munts AM Corp.
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

JAVA		?= $(JDKPATH)java

JAVAC		?= $(JDKPATH)javac
JAVAC_CLASSPATH	?= .
JAVAC_DESTDIR	?= .
JAVAC_FLAGS	?= -cp $(JAVAC_CLASSPATH) -d $(JAVAC_DESTDIR)

JAR		?= $(JDKPATH)jar
JAR_PERMISSIONS	?= sandbox
JAR_COMPONENTS	?= *.class

JARSIGNER	?= $(JDKPATH)jarsigner
JARSIGNER_FLAGS	?=
JARSIGNER_KEYSTORE ?= $(JAVA_SRC)/keystore
JARSIGNER_ALIAS	?= $(USER)

# Don't delete intermediate files

.SECONDARY:

# Java pattern rules

%.class: %.java
	$(JAVAC) $(JAVAC_FLAGS) $<

%.manifest: %.class
	echo "Main-Class: $*" >$@
	echo "Permissions: $(JAR_PERMISSIONS)" >>$@
	echo "Enable-Native-Access: ALL-UNNAMED" >>$@
	echo "" >>$@

%.jar: %.manifest
	$(JAR) -cmf $< $@ $(JAR_COMPONENTS)
	if [ -f $(JARSIGNER_KEYSTORE) ]; then $(JARSIGNER) -keystore $(JARSIGNER_KEYSTORE) $(JARSIGNER_FLAGS) $@ $(JARSIGNER_ALIAS) ; fi

# Default catchall target

java_mk_default: default

# Clean out working files

java_mk_clean:
	rm -rf *.class *.jar *.log *.manifest

java_mk_reallyclean: java_mk_clean

java_mk_distclean: java_mk_reallyclean
