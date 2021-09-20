# GNAT Ada definitions for building Remote I/O Protocol programs

# Copyright (C)2018-2021, Philip Munts, President, Munts AM Corp.
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

CFLAGS += -I$(LIBSIMPLEIO)/ada/bindings
CFLAGS += -I$(LIBSIMPLEIO)/ada/devices
CFLAGS += -I$(LIBSIMPLEIO)/ada/interfaces
CFLAGS += -I$(LIBSIMPLEIO)/ada/objects
CFLAGS += -I$(LIBSIMPLEIO)/ada/objects/clickboards
CFLAGS += -I$(LIBSIMPLEIO)/ada/objects/clickboards/remoteio
CFLAGS += -I$(LIBSIMPLEIO)/ada/objects/hid
CFLAGS += -I$(LIBSIMPLEIO)/ada/objects/remoteio
CFLAGS += -I$(LIBSIMPLEIO)/ada/objects/remoteio/client
CFLAGS += -I$(LIBSIMPLEIO)/ada/objects/remoteio/server
CFLAGS += -I$(LIBSIMPLEIO)/ada/objects/simpleio
