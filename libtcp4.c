// Simple IPv4 TCP client and server routines

// Copyright (C)2016-2017, Philip Munts, President, Munts AM Corp.
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

#include <errno.h>
#include <netdb.h>
#include <signal.h>
#include <stdio.h>
#include <string.h>
#include <unistd.h>
#include <arpa/inet.h>
#include <sys/types.h>
#include <sys/socket.h>
#include <netinet/in.h>

#include "libtcp4.h"

// Resolve host name to IPV4 address

void TCP4_resolve(const char *name, int32_t *addr, int32_t *error)
{
  struct hostent *he;

  he = gethostbyname2(name, AF_INET);

  if (he == NULL)
  {
    // Map h_errno to errno

    switch(h_errno)
    {
      case HOST_NOT_FOUND :
      case NO_ADDRESS :
        *error = ENONET;
        break;

      case TRY_AGAIN :
        *error = EAGAIN;
        break;

      default :
        *error = EIO;
        break;
    }

    return;
  }

  *addr = htonl(*(int32_t *)he->h_addr);
  *error = 0;
}

// Convert IPV4 address to dotted decimal string

void TCP4_ntoa(int32_t addr, char *dst, int32_t dstsize, int32_t *error)
{
  struct in_addr in;

  // Validate parameters

  if (dstsize < 16)
  {
    *error = EINVAL;
    return;
  }

  in.s_addr = ntohl(addr);

  memset(dst, 0, dstsize);

  strncpy(dst, inet_ntoa(in), dstsize - 1);
  *error = 0;
}

// Connect to a TCP server

void TCP4_connect(int32_t addr, int32_t port, int32_t *fd, int32_t *error)
{
  int s;
  struct sockaddr_in destaddr;

  // Validate parameters

  if ((port < 1) || (port > 65535))
  {
    *error = EINVAL;
    return;
  }

  // Attempt to create a socket

  s = socket(AF_INET, SOCK_STREAM, 0);
  if (s < 0)
  {
    *error = errno;
    return;
  }

  // Build address structure for the specified server

  memset(&destaddr, 0, sizeof(destaddr));
  destaddr.sin_family = AF_INET;
  destaddr.sin_addr.s_addr = htonl(addr);
  destaddr.sin_port = htons(port);

  // Attempt to open connection to the server

  if (connect(s, (struct sockaddr *)&destaddr, sizeof(destaddr)))
  {
    *error = errno;
    return;
  }

  // Prevent SIGPIPE

  signal(SIGPIPE, SIG_IGN);

  *fd = s;
  *error = 0;
}

// Wait (block) for exactly one connection from a TCP client, then
// return a file descriptor for the new connection

void TCP4_accept(int32_t addr, int32_t port, int32_t *fd, int32_t *error)
{
  int s1, s2;
  struct sockaddr_in myaddr;

  // Validate parameters

  if ((port < 1) || (port > 65535))
  {
    *error = EINVAL;
    return;
  }

  // Attempt to create a socket

  s1 = socket(AF_INET, SOCK_STREAM, 0);
  if (s1 < 0)
  {
    *error = errno;
    return;
  }

  // Attempt to bind socket

  memset(&myaddr, 0, sizeof(myaddr));
  myaddr.sin_family = AF_INET;
  myaddr.sin_addr.s_addr = htonl(addr);
  myaddr.sin_port = htons(port);

  if (bind(s1, (struct sockaddr *)&myaddr, sizeof(myaddr)))
  {
    *error = errno;
    return;
  }

  // Establish incoming connection queue

  if (listen(s1, 5))
  {
    *error = errno;
    return;
  }

  // Wait for incoming connection

  s2 = accept(s1, NULL, NULL);
  if (s2 == -1)
  {
    *error = errno;
    return;
  }

  close(s1);

  // Prevent SIGPIPE

  signal(SIGPIPE, SIG_IGN);

  *fd = s2;
  *error = 0;
}

// Wait (block) until a client connects, then fork and return a file
// descriptor to the child process

void TCP4_server(int32_t addr, int32_t port, int32_t *fd, int32_t *error)
{
  int s1, s2;
  struct sockaddr_in myaddr;

  // Validate parameters

  if ((port < 1) || (port > 65535))
  {
    *error = EINVAL;
    return;
  }

  // Attempt to create a socket

  s1 = socket(AF_INET, SOCK_STREAM, 0);
  if (s1 < 0)
  {
    *error = errno;
    return;
  }

  // Attempt to bind socket

  memset(&myaddr, 0, sizeof(myaddr));
  myaddr.sin_family = AF_INET;
  myaddr.sin_addr.s_addr = htonl(addr);
  myaddr.sin_port = htons(port);

  if (bind(s1, (struct sockaddr *)&myaddr, sizeof(myaddr)))
  {
    *error = errno;
    return;
  }

  // Establish incoming connection queue

  if (listen(s1, 5))
  {
    *error = errno;
    return;
  }

  // Prevent zombie children

  signal(SIGCHLD, SIG_IGN);

  // Main service loop

  for (;;)
  {
    // Wait for incoming connection

    s2 = accept(s1, NULL, NULL);
    if (s2 == -1)
    {
      *error = errno;
      return;
    }

    // Spawn child process for the new connection

    if (fork() == 0)
    {
      close(s1);

      // Prevent SIGPIPE

      signal(SIGPIPE, SIG_IGN);

      *error = 0;
      *fd = s2;
      return;
    }

    close(s2);
  }
}
