# Makefile for creating Visual Studio 2019 project templates

# Copyright (C)2019, Philip Munts, President, Munts AM Corp.
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

ifeq ($(shell uname), Darwin)
FIRETEMPLATES	?= $(HOME)/"Library/Application Support/RemObjects Software/Elements/Templates"
CSHARPTEMPLATES	:= $(FIRETEMPLATES)/Hydrogene/Echoes/Projects/Core
JAVATEMPLATES	:= $(FIRETEMPLATES)/Iodine/Echoes/Projects/Core
PASCALTEMPLATES	:= $(FIRETEMPLATES)/Oxygene/Echoes/Projects/Core
SWIFTTEMPLATES	:= $(FIRETEMPLATES)/Silver/Echoes/Projects/Core
endif

ifeq ($(OS), Windows_NT)
VSTEMPLATES	?= $(HOME)/Documents/Visual Studio 2019/Templates/ProjectTemplates
endif

###############################################################################

# Define a pattern rule for packing a template archive

%.zip: %.d
	rm -f $@
	cd $< ; zip -r ../$@ *

# Define a pattern rule for unpacking a template archive

%.d: %.zip
	mkdir -p $@
	cd $@ ; unzip ../$<

# Define a pattern rule for installing a template for Windows Visual Studio

ifeq ($(OS), Windows_NT)
%.install: %.zip
	install -cm 0644 $< "$(VSTEMPLATES)"
endif

# Define pattern rules for installing a template for MacOS Fire

ifeq ($(shell uname), Darwin)
csharp%.install: csharp%.zip
	rm -rf $(CSHARPTEMPLATES)/`basename $@ .install`
	mkdir -p $(CSHARPTEMPLATES)/`basename $@ .install`
	unzip $< -d $(CSHARPTEMPLATES)/`basename $@ .install`

java%.install: java%.zip
	rm -rf $(JAVATEMPLATES)/`basename $@ .install`
	mkdir -p $(JAVATEMPLATES)/`basename $@ .install`
	unzip $< -d $(JAVATEMPLATES)/`basename $@ .install`

pascal%.install: pascal%.zip
	rm -rf $(PASCALTEMPLATES)/`basename $@ .install`
	mkdir -p $(PASCALTEMPLATES)/`basename $@ .install`
	unzip $< -d $(PASCALTEMPLATES)/`basename $@ .install`

swift%.install: swift%.zip
	rm -rf $(SWIFTTEMPLATES)/`basename $@ .install`
	mkdir -p $(SWIFTTEMPLATES)/`basename $@ .install`
	unzip $< -d $(SWIFTTEMPLATES)/`basename $@ .install`
endif

###############################################################################

# Pack all template archives

packall:
	for D in *.d ; do $(MAKE) `basename $$D .d`.zip ; done

# Unpack all template archives

unpackall:
	for A in *.zip ; do $(MAKE) `basename $$A .zip`.d ; done

# Install all template archives

install:
	for A in *.zip ; do $(MAKE) `basename $$A .zip`.install ; done

# Remove working files

clean:
	rm -rf *.d
