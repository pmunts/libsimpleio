# Makefile for creating Visual Studio 2019 C++ project templates

# Copyright (C)2021, Philip Munts, President, Munts AM Corp.
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

VSTEMPLATES	?= $(HOME)/"Documents/Visual Studio 2019/Templates/ProjectTemplates"

###############################################################################

# Define a pattern rule for packing a template archive

%.zip: %.d
	rm -f $@
	cd $< ; zip -r ../$@ *

# Define a pattern rule for installing a template for Windows Visual Studio

%.install: %.zip
	mkdir -p $(VSTEMPLATES)
	install -cm 0644 $< $(VSTEMPLATES)

###############################################################################

# Pack all template archives

pack:
	for D in *.d ; do $(MAKE) `basename $$D .d`.zip ; done

# Install all template archives

install: pack
	for A in *.zip ; do $(MAKE) `basename $$A .zip`.install ; done

clean:
	rm -rf *.zip
