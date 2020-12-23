// Raw HID device services using Posix file I/O

// Copyright (C)2020, Philip Munts, President, Munts AM Corp.
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

#include <cerrno>
#include <climits>
#include <cstdio>
#include <cstring>
#include <exception-raisers.h>
#include <fcntl.h>
#include <poll.h>
#include <unistd.h>

#include <hid-posix.h>

using namespace HID::Posix;

// Constructors

Messenger_Class::Messenger_Class(const char *name, unsigned timeoutms)
{
  int32_t fd;

  // Open raw HID device

  fd = open(name, O_RDWR);

  if (fd < 0) THROW_MSG_ERR("open() failed", errno);

  this->fd = fd;
  this->timeout = timeoutms;
}

Messenger_Class::Messenger_Class(uint16_t VID, uint16_t PID,
  const char *serial, unsigned timeoutms)
{
  char name[PATH_MAX];
  int32_t fd;

  if ((serial != NULL) && (strlen(serial) > 0))
    snprintf(name, sizeof(name)-1, "/dev/hidraw-%04x:%04x-%s", VID, PID, serial);
  else
    snprintf(name, sizeof(name)-1, "/dev/hidraw-%04x:%04x", VID, PID);

  fd = open(name, O_RDWR);

  if (fd < 0) THROW_MSG_ERR("open() failed", errno);

  this->fd = fd;
  this->timeout = timeoutms;
}

// Methods

void Messenger_Class::Send(Interfaces::Message64::Message cmd)
{
  ssize_t count = write(this->fd, cmd->payload, Interfaces::Message64::Size);

  if (count < 0)
    THROW_MSG_ERR("write() failed", errno);

  if (count != Interfaces::Message64::Size)
    THROW_MSG("Returned byte count is invalid");
}

void Messenger_Class::Receive(Interfaces::Message64::Message cmd)
{
  if (this->timeout > 0)
  {
    struct pollfd fds[1] = { this->fd, POLLIN, 0 };
    int status = poll(fds, 1, this->timeout);

    if (status < 0)
      THROW_MSG_ERR("poll() failed", errno);

    if (status == 0)
      THROW_MSG_ERR("poll() timed out", EAGAIN);
  }

  ssize_t count = read(this->fd, cmd->payload, Interfaces::Message64::Size);

  if (count < 0)
    THROW_MSG_ERR("read() failed", errno);

  if (count != Interfaces::Message64::Size)
    THROW_MSG("Returned byte count is invalid");
}

void Messenger_Class::Transaction(Interfaces::Message64::Message cmd,
  Interfaces::Message64::Message resp)
{
  this->Send(cmd);
  this->Receive(resp);
}
