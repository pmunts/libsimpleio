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

#include <errno.h>
#include <netdb.h>
#include <stdint.h>
#include <stdio.h>
#include <string.h>
#include <unistd.h>
#include <sys/types.h>
#include <sys/socket.h>
#include <netinet/in.h>

#include "errmsg.inc"
#include "libtcp4.h"

// Resolve domain name to IPV4 address

void TCP4_resolve(char *name, IPV4_ADDR *addr, int *error)
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

  *addr = htonl(*(IPV4_ADDR *)he->h_addr);
  *error = 0;
}

// Connect to a TCP server

void TCP4_connect(IPV4_ADDR addr, IPV4_PORT port, int *fd, int *error)
{
  int s;
  struct sockaddr_in destaddr;

  /* Attempt to create a socket */

  s = socket(AF_INET, SOCK_STREAM, 0);
  if (s < 0)
  {
    *error = errno;
    return;
  }

  /* Build address structure for the specified server */

  memset(&addr, 0, sizeof(destaddr));
  destaddr.sin_family = AF_INET;
  destaddr.sin_addr.s_addr = htonl(addr);
  destaddr.sin_port = htons(port);

  /* Attempt to open connection to the server */

  if (connect(s, (struct sockaddr *)&destaddr, sizeof(destaddr)))
  {
    *error = errno;
    return;
  }

  *fd = s;
  *error = 0;
}

// Wait for exactly one connection from a TCP client

void TCP4_listen(IPV4_ADDR addr, IPV4_PORT port, int *fd, int *error)
{
  int s1, s2;
  struct sockaddr_in myaddr;

  /* Attempt to create a socket */

  s1 = socket(AF_INET, SOCK_STREAM, 0);
  if (s1 < 0)
  {
    *error = errno;
    return;
  }

  /* Attempt to bind socket */

  memset(&myaddr, 0, sizeof(myaddr));
  myaddr.sin_family = AF_INET;
  myaddr.sin_addr.s_addr = htonl(addr);
  myaddr.sin_port = htons(port);

  if (bind(s1, (struct sockaddr *)&myaddr, sizeof(myaddr)))
  {
    *error = errno;
    return;
  }

  /* Establish incoming connection queue */

  if (listen(s1, 5))
  {
    *error = errno;
    return;
  }

  /* Wait for incoming connection */

  s2 = accept(s1, NULL, NULL);
  if (s2 == -1)
  {
    *error = errno;
    return;
  }

  close(s1);

  *fd = s2;
  *error = 0;
}

// Start TCP server parent--Block until a client connects, then fork
// and return a file descriptor to the file process

void TCP4_server(IPV4_ADDR addr, IPV4_PORT port, int *fd, int *error)
{
  int s1, s2;
  struct sockaddr_in myaddr;

  /* Attempt to create a socket */

  s1 = socket(AF_INET, SOCK_STREAM, 0);
  if (s1 < 0)
  {
    *error = errno;
    return;
  }

  /* Attempt to bind socket */

  memset(&myaddr, 0, sizeof(myaddr));
  myaddr.sin_family = AF_INET;
  myaddr.sin_addr.s_addr = htonl(addr);
  myaddr.sin_port = htons(port);

  if (bind(s1, (struct sockaddr *)&myaddr, sizeof(myaddr)))
  {
    *error = errno;
    return;
  }

  /* Establish incoming connection queue */

  if (listen(s1, 5))
  {
    *error = errno;
    return;
  }

  // Main service loop

  for (;;)
  {
    /* Wait for incoming connection */

    s2 = accept(s1, NULL, NULL);
    if (s2 == -1)
    {
      *error = errno;
      return;
    }

    /* Spawn child process for the new connection */

    if (fork() == 0)
    {
       close(s1);
       
       *error = 0;
       *fd = s2;
       return;
    }

    close(s2);
  }
}
