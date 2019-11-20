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

WATERTEMPLATES	?= $(HOME)/"Application Data/RemObjects Software/Elements/Templates"
CSHARPTEMPLATES	:= $(WATERTEMPLATES)/Hydrogene/Echoes/Projects/Core
JAVATEMPLATES	:= $(WATERTEMPLATES)/Iodine/Echoes/Projects/Core
PASCALTEMPLATES	:= $(WATERTEMPLATES)/Oxygene/Echoes/Projects/Core
SWIFTTEMPLATES	:= $(WATERTEMPLATES)/Silver/Echoes/Projects/Core
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

# Define pattern rules for installing a template for MacOS Fire

ifeq ($(shell uname), Darwin)
csharp%.installfire: csharp%.zip
	rm -rf $(CSHARPTEMPLATES)/`basename $@ .installfire`
	mkdir -p $(CSHARPTEMPLATES)/`basename $@ .installfire`
	unzip $< -d $(CSHARPTEMPLATES)/`basename $@ .installfire`

java%.installfire: java%.zip
	rm -rf $(JAVATEMPLATES)/`basename $@ .installfire`
	mkdir -p $(JAVATEMPLATES)/`basename $@ .installfire`
	unzip $< -d $(JAVATEMPLATES)/`basename $@ .installfire`

pascal%.installfire: pascal%.zip
	rm -rf $(PASCALTEMPLATES)/`basename $@ .installfire`
	mkdir -p $(PASCALTEMPLATES)/`basename $@ .installfire`
	unzip $< -d $(PASCALTEMPLATES)/`basename $@ .installfire`

swift%.installfire: swift%.zip
	rm -rf $(SWIFTTEMPLATES)/`basename $@ .installfire`
	mkdir -p $(SWIFTTEMPLATES)/`basename $@ .installfire`
	unzip $< -d $(SWIFTTEMPLATES)/`basename $@ .installfire`
endif

# Define a pattern rule for installing a template for Windows Visual Studio

ifeq ($(OS), Windows_NT)
%.installvs: %.zip
	install -cm 0644 $< "$(VSTEMPLATES)"
endif

# Define pattern rules for installing a template for Windows water

ifeq ($(OS), Windows_NT)
csharp%.installwater: csharp%.zip
	rm -rf $(CSHARPTEMPLATES)/`basename $@ .installwater`
	mkdir -p $(CSHARPTEMPLATES)/`basename $@ .installwater`
	unzip $< -d $(CSHARPTEMPLATES)/`basename $@ .installwater`

java%.installwater: java%.zip
	rm -rf $(JAVATEMPLATES)/`basename $@ .installwater`
	mkdir -p $(JAVATEMPLATES)/`basename $@ .installwater`
	unzip $< -d $(JAVATEMPLATES)/`basename $@ .installwater`

pascal%.installwater: pascal%.zip
	rm -rf $(PASCALTEMPLATES)/`basename $@ .installwater`
	mkdir -p $(PASCALTEMPLATES)/`basename $@ .installwater`
	unzip $< -d $(PASCALTEMPLATES)/`basename $@ .installwater`

swift%.installwater: swift%.zip
	rm -rf $(SWIFTTEMPLATES)/`basename $@ .installwater`
	mkdir -p $(SWIFTTEMPLATES)/`basename $@ .installwater`
	unzip $< -d $(SWIFTTEMPLATES)/`basename $@ .installwater`
endif

###############################################################################

# Pack all template archives

packall:
	for D in *.d ; do $(MAKE) `basename $$D .d`.zip ; done

# Unpack all template archives

unpackall:
	for A in *.zip ; do $(MAKE) `basename $$A .zip`.d ; done

# Install all template archives

ifeq ($(shell uname), Darwin)
installfire:
	for A in *.zip ; do $(MAKE) `basename $$A .zip`.installfire ; done
endif

ifeq ($(OS), Windows_NT)
installvs:
	for A in *.zip ; do $(MAKE) `basename $$A .zip`.installvs ; done
endif

ifeq ($(OS), Windows_NT)
installwater:
	for A in *.zip ; do $(MAKE) `basename $$A .zip`.installwater ; done
endif

# Remove working files

clean:
	rm -rf *.d
