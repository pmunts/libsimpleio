// Raw HID device services using libremoteio.dll (Windows 64 only)

// Copyright (C)2021, Philip Munts, President, Munts AM Corp.
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

#ifdef HID_USE_LIBREMOTEIO

#include <cstdint>
#include <cstring>
#include <string>

#include <exception-raisers.h>
#include <hid-libremoteio.h>
#include <libremoteio.h>

using namespace HID::libremoteio;

// Constructors

Messenger_Class::Messenger_Class(uint16_t VID, uint16_t PID, const char *serial,
  int timeoutms)
{
  int h;
  int error;

  // Validate parameters

  if (timeoutms < -1)
    THROW_MSG("timeoutms parameter is out of range");

  if (serial != nullptr)
    if (strlen(serial) > 126)
      THROW_MSG("serial number parameter is too long");

  // Open device

  open_hid(VID, PID, serial, timeoutms, &h, &error);

  if (error != 0)
    THROW_MSG("libremoteio.open_hid() failed");

  this->handle = h;
}

// Methods

void Messenger_Class::Send(Interfaces::Message64::Message cmd)
{
  int error;

  // Validate parameters

  if (cmd == nullptr)
    THROW_MSG("cmd parameter is NULL");

  send(this->handle, (uint8_t *) cmd, &error);

  if (error != 0)
    THROW_MSG("libremoteio.send() failed");
}

void Messenger_Class::Receive(Interfaces::Message64::Message resp)
{
  int error;

  // Validate parameters

  if (resp == nullptr)
    THROW_MSG("resp parameter is NULL");

  receive(this->handle, (uint8_t *) resp, &error);

  if (error != 0)
    THROW_MSG("libremoteio.receive() failed");
}

void Messenger_Class::Transaction(Interfaces::Message64::Message cmd,
  Interfaces::Message64::Message resp)
{
  // Validate parameters

  if (cmd == nullptr)
    THROW_MSG("cmd parameter is NULL");

  if (resp == nullptr)
    THROW_MSG("resp parameter is NULL");

  // Dispatch the command

  this->Send(cmd);
  this->Receive(resp);
}

#endif
