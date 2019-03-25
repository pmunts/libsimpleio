# Build libsimpleio.dll for Windows

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

GNAT		?= C:/PROGRA~1/gnat

CC		:= $(GNAT)/bin/gcc
CFLAGS		:= -Wall -I$(LIBSIMPLEIO)/c

# Only these libsimpleio components can be compiled for Windows

SOURCES		+= libstream.c

default: libsimpleio.dll

# Compile source files

compile.done:
	for F in $(SOURCES) ; do $(CC) $(CFLAGS) -c -o `basename $$F .c`.o $(LIBSIMPLEIO)/c/$$F ; done
	ls -l
	touch $@

# Build the library DLL

libsimpleio.dll: compile.done
	$(CC) -shared -o $@ *.o

# Remove working files

clean:
	rm -rf *.done *.o *.dll

reallyclean: clean

distclean: reallyclean
