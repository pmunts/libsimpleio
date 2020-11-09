// Raw HID device services using libhidapi

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

#include <cstdint>
#include <cstring>
#include <string>

#include <hidapi/hidapi.h>

#include <exception-libsimpleio.h>
#include <hid-hidapi.h>

// Constructors

hidapi::HID::Messenger_Class::Messenger_Class(uint16_t VID, uint16_t PID,
  const char *serial, int timeoutms)
{
  // Validate parameters

  if (timeoutms < -1)
    THROW_MSG("timeoutms parameter is out of range");

  if (serial != nullptr)
    if (strlen(serial) > 126)
      THROW_MSG("serial number parameter is too long");

  // Initialize hidapi library

  if (hid_init() != 0)
    THROW_MSG("hid_init() failed");

  // Open device

  if (serial == nullptr)
    this->handle = (void *) hid_open(VID, PID, nullptr);
  else if (*serial == 0)
    this->handle = (void *) hid_open(VID, PID, nullptr);
  else
  {
    wchar_t wserial[256];
    swprintf(wserial, 256, L"%hs", serial);
    this->handle = (void *) hid_open(VID, PID, wserial);
  }

  if (this->handle == nullptr)
    THROW_MSG("hid_open() failed");

  this->timeout = timeoutms;
}

// Methods

void hidapi::HID::Messenger_Class::Send(Interfaces::Message64::Message cmd)
{
  // Validate parameters

  if (cmd == nullptr)
    THROW_MSG("cmd parameter is NULL");

  int count = hid_write((hid_device *) this->handle, cmd->payload,
    Interfaces::Message64::Size);

  if (count != Interfaces::Message64::Size)
    THROW_MSG("hid_write() failed");
}

void hidapi::HID::Messenger_Class::Receive(Interfaces::Message64::Message resp)
{
  // Validate parameters

  if (resp == nullptr)
    THROW_MSG("resp parameter is NULL");

 int32_t count = hid_read_timeout((hid_device *) this->handle, resp->payload,
      Interfaces::Message64::Size, this->timeout);

  // Handle the various outcomes

  if (count == 0)
    THROW_MSG("hid_read_timeout() timed out");

  if (count != Interfaces::Message64::Size)
    THROW_MSG("hid_read_timeout() failed");
}

void hidapi::HID::Messenger_Class::Transaction(
  Interfaces::Message64::Message cmd, Interfaces::Message64::Message resp)
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

std::string hidapi::HID::Messenger_Class::Manufacturer(void)
{
  wchar_t wbuf[256];
  char buf[256];

  if (hid_get_manufacturer_string((hid_device *) this->handle, wbuf, sizeof(wbuf)) != 0)
    THROW_MSG("hid_get_manufacturer_string() failed");

  wcstombs(buf, wbuf, 256);
  return std::string(buf);
}

std::string hidapi::HID::Messenger_Class::Product(void)
{
  wchar_t wbuf[256];
  char buf[256];

  if (hid_get_product_string((hid_device *) this->handle, wbuf, sizeof(wbuf)) != 0)
    THROW_MSG("hid_get_product_string() failed");

  wcstombs(buf, wbuf, 256);
  return std::string(buf);
}

std::string hidapi::HID::Messenger_Class::SerialNumber(void)
{
  wchar_t wbuf[256];
  char buf[256];

  if (hid_get_serial_number_string((hid_device *) this->handle, wbuf, sizeof(wbuf)) != 0)
    THROW_MSG("hid_get_serial_number_string() failed");

  wcstombs(buf, wbuf, 256);
  return std::string(buf);
}
