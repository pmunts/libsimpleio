/* epoll wrapper services for Linux */

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
#include <string.h>
#include <unistd.h>

#include <libevent.h>
#include "errmsg.inc"

#define EPFD_UNINITALIZED	-1

static int epfd = EPFD_UNINITALIZED;

void EVENT_open(int *error)
{
  if (epfd == EPFD_UNINITALIZED)
  {
    epfd = epoll_create(256);
    if (epfd < 0)
    {
      epfd = EPFD_UNINITALIZED;
      *error = errno;
      ERRORMSG("epoll_create() failed", *error, __LINE__ - 4);
      return;
    }
  }

  *error = 0;
}

void EVENT_close(int *error)
{
  if (epfd == EPFD_UNINITALIZED)
  {
    *error = EBADF;
    ERRORMSG("epoll() file descriptor has not been opened", *error, __LINE__ - 3);
    return;
  }

  if (close(epfd))
  {
    epfd = EPFD_UNINITALIZED;
    *error = errno;
    ERRORMSG("close() failed", *error, __LINE__ - 3);
    return;
  }

  epfd = EPFD_UNINITALIZED;
  *error = 0;
}

void EVENT_register_fd(int fd, int events, int *error)
{
  struct epoll_event ev;

  if (epfd == EPFD_UNINITALIZED)
  {
    *error = EBADF;
    ERRORMSG("epoll() file descriptor has not been opened", *error, __LINE__ - 3);
    return;
  }

  memset(&ev, 0, sizeof(ev));
  ev.events = events;
  ev.data.fd = fd;

  if (epoll_ctl(epfd, EPOLL_CTL_ADD, fd, &ev))
  {
    *error = errno;
    ERRORMSG("epoll_ctl() failed", *error, __LINE__ - 3);
    return;
  }

  *error = 0;
}

void EVENT_unregister_fd(int fd, int *error)
{
  if (epfd == EPFD_UNINITALIZED)
  {
    *error = EBADF;
    ERRORMSG("epoll() file descriptor has not been opened", *error, __LINE__ - 3);
    return;
  }

  if (epoll_ctl(epfd, EPOLL_CTL_DEL, fd, NULL))
  {
    *error = errno;
    ERRORMSG("epoll_ctl() failed", *error, __LINE__ - 3);
    return;
  }

  *error = 0;
}

void EVENT_wait(int *fd, int *event, int timeoutms, int *error)
{
  int status;
  struct epoll_event ev;

  if (epfd == EPFD_UNINITALIZED)
  {
    *error = EBADF;
    ERRORMSG("epoll() file descriptor has not been opened", *error, __LINE__ - 3);
    return;
  }

  status = epoll_wait(epfd, &ev, 1, timeoutms);
  if (status < 0)
  {
    *error = errno;
    ERRORMSG("epoll_wait() failed", *error, __LINE__ - 3);
    return;
  }

  if (status == 0)
  {
    *error = EAGAIN;
    return;
  }

  *fd  = ev.data.fd;
  *event = ev.events;
  *error = 0;
}
