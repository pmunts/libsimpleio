# Makefile to build Simple I/O Library for MuntsOS documentation

# $Id: Makefile 10057 2016-03-02 14:20:30Z svn $

# Copyright (C)2016, Philip Munts, President, Munts AM Corp.
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

default: html pdf

# Create HTML documentation

%.2.html: %.2
	man2html -r $^ >$@
	sed -i 's@\.\./index\.html@README.html@g' $@
	sed -i 's@\.\./man2/@@g' $@

html:
	for f in *.2 ; do $(MAKE) $$f.html ; done

# Create PDF documentation

%.2.ps: %.2
	groff -man -Tps $^ >$@

%.2.pdf: %.2.ps
	ps2pdf $^

pdf:
	for f in *.2 ; do $(MAKE) $$f.ps ; ps2pdf $$f.ps $$f.pdf ; done
	pdftk lib*2.pdf output libsimpleio.pdf
	rm -rf lib*2.ps lib*2.pdf

clean:

reallyclean: clean

distclean: reallyclean
