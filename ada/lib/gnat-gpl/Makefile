# Makefile for building the Ada Linux Simple I/O library project for
# GNAT Community Edition

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

LIBSIMPLEIO	?= ../../..
GNAT		?= undefined

default: build.done

# Build the Ada libsimpleio library project for GNAT Community Edition

build.done:
	test -n "$(GNAT)"
	test "$(GNAT)" != "undefined"
	$(MAKE) -C $(LIBSIMPLEIO)/ada/lib GNAT=$(GNAT)
	cp -R -P -p ../libsimpleio.lib .
	mkdir -p libsimpleio.src
	cp -R -P -p $(LIBSIMPLEIO)/ada/bindings   libsimpleio.src
	cp -R -P -p $(LIBSIMPLEIO)/ada/devices    libsimpleio.src
	cp -R -P -p $(LIBSIMPLEIO)/ada/interfaces libsimpleio.src
	cp -R -P -p $(LIBSIMPLEIO)/ada/objects    libsimpleio.src
	touch $@

# Install the library project

install: build.done uninstall
	test -n "$(GNAT)"
	test "$(GNAT)" != "undefined"
	sudo install -cm 0444 libsimpleio.gpr			$(GNAT)/share/gpr
	sudo sed -i 's:@@GNAT@@:$(GNAT):g'			$(GNAT)/share/gpr/libsimpleio.gpr
	sudo cp -R --preserve=timestamps libsimpleio.lib	$(GNAT)/lib/libsimpleio
	sudo chown -R root.root					$(GNAT)/lib/libsimpleio
	sudo chmod -R ugo-w					$(GNAT)/lib/libsimpleio
	sudo cp -R --preserve=timestamps libsimpleio.src	$(GNAT)/include/libsimpleio
	sudo chown -R root.root					$(GNAT)/include/libsimpleio
	sudo chmod -R ugo-w					$(GNAT)/include/libsimpleio

# Uninstall the library project

uninstall:
	test -n "$(GNAT)"
	test "$(GNAT)" != "undefined"
	sudo rm -rf $(GNAT)/share/gpr/libsimpleio.gpr
	sudo rm -rf $(GNAT)/include/libsimpleio
	sudo rm -rf $(GNAT)/lib/libsimpleio

# Remove working files

clean:
	$(MAKE) -C $(LIBSIMPLEIO)/ada/lib clean
	rm -rf build.done libsimpleio.lib libsimpleio.src
