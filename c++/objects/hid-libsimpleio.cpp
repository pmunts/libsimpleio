// Raw HID device services using libsimpleio

// Copyright (C)2018, Philip Munts, President, Munts AM Corp.
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

#include <cstdint>

#include <exception-libsimpleio.h>
#include <hid-libsimpleio.h>
#include <libsimpleio/libhidraw.h>
#include <libsimpleio/liblinux.h>

// Constructors

libsimpleio::HID::Messenger_Class::Messenger_Class(const char *name,
  unsigned timeoutms)
{
  int32_t fd;
  int32_t error;

  HIDRAW_open(name, &fd, &error);
  if (error) THROW_MSG_ERR("HIDRAW_open() failed", error);

  this->fd = fd;
  this->timeout = timeoutms;
}

libsimpleio::HID::Messenger_Class::Messenger_Class(uint16_t VID, uint16_t PID,
  unsigned timeoutms)
{
  int32_t fd;
  int32_t error;

  HIDRAW_open_id(VID, PID, &fd, &error);
  if (error) THROW_MSG_ERR("HIDRAW_open_id() failed", error);

  this->fd = fd;
  this->timeout = timeoutms;
}

// Methods

void libsimpleio::HID::Messenger_Class::Send(
  Interfaces::Message64::Message cmd)
{
  int32_t count;
  int32_t error;

  HIDRAW_send(this->fd, cmd->payload, Interfaces::Message64::Size, &count,
    &error);

  if (error)
    THROW_MSG_ERR("HIDRAW_send() failed", error);

  if (count != Interfaces::Message64::Size)
    THROW_MSG("Returned byte count is invalid");
}

void libsimpleio::HID::Messenger_Class::Receive(
  Interfaces::Message64::Message cmd)
{
  int32_t count;
  int32_t error;

  if (this->timeout > 0)
  {
    int32_t files[1]   = { this->fd };
    int32_t events[1]  = { POLLIN };
    int32_t results[1] = { 0 };

    LINUX_poll(1, files, events, results, this->timeout, &error);
    if (error) THROW_MSG_ERR("LINUX_poll() failed", error);
  }

  HIDRAW_receive(this->fd, cmd->payload, Interfaces::Message64::Size, &count,
    &error);

  if (error)
    THROW_MSG_ERR("HIDRAW_receive() failed", error);

  if (count != Interfaces::Message64::Size)
    THROW_MSG("Returned byte count is invalid");
}

void libsimpleio::HID::Messenger_Class::Transaction(
  Interfaces::Message64::Message cmd, Interfaces::Message64::Message resp)
{
  this->Send(cmd);
  this->Receive(resp);
}
