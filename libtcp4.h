// Simple IPv4 TCP client and server routines

// Copyright (C)2016, Philip Munts, President, Munts AM Corp.
//
// Redistribution and use in source and binary forms, with or without
// modification, are permitted provided that the following conditions are met:
//
// * Redistributions of source code must retain the above copyright notice,
//   this list of conditions and the following disclaimer.
//
// THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
// AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
// IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
// ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE
// LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
// CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
// SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
// INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
// CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
// ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
// POSSIBILITY OF SUCH DAMAGE.

#ifndef _LIBTCP4_H_
#define _LIBTCP4_H_

#include <cplusplus.h>
#include <liblinux.h>
#include <stdint.h>

typedef uint32_t IPV4_ADDR;
typedef uint16_t IPV4_PORT;

_BEGIN_STD_C

// Resolve host name to IPV4 address

extern void TCP4_resolve(char *name, IPV4_ADDR *addr, int32_t *error);

// Connect to a TCP server

extern void TCP4_connect(IPV4_ADDR addr, IPV4_PORT port, int32_t *fd, int32_t *error);

// Wait (block) for exactly one connection from a TCP client, then
// return a file descriptor for the new connection

extern void TCP4_accept(IPV4_ADDR addr, IPV4_PORT port, int32_t *fd, int32_t *error);

// Wait (block) until a client connects, then fork and return a file
// descriptor for the new connection to the child process

extern void TCP4_server(IPV4_ADDR addr, IPV4_PORT port, int32_t *fd, int32_t *error);

_END_STD_C

// Convenience macros

#define TCP4_send(f, b, s, c, e)	LINUX_write(f, b, s, c, e)

#define TCP4_receive(f, b, s, c, e)	LINUX_read(f, b, s, c, e)

#define TCP4_close(f, e)		LINUX_close(f, e)

#endif
