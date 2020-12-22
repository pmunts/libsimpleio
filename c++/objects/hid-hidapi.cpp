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

#include <exception-raisers.h>
#include <hid-hidapi.h>

#ifdef __OpenBSD__
#define hid_init() hidapi_hid_init()
#endif

using namespace HID::hidapi;

// Constructors

Messenger_Class::Messenger_Class(uint16_t VID, uint16_t PID, const char *serial,
  int timeoutms)
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

void Messenger_Class::Send(Interfaces::Message64::Message cmd)
{
  // Validate parameters

  if (cmd == nullptr)
    THROW_MSG("cmd parameter is NULL");

  uint8_t buf[Interfaces::Message64::Size + 1];

  // Prepend report ID byte

  buf[0] = 0;
  memcpy(buf + 1, cmd->payload, Interfaces::Message64::Size);

  // Send the report

  int count = hid_write((hid_device *) this->handle, buf, sizeof(buf));

  if (count != sizeof(buf))
    THROW_MSG("hid_write() failed");
}

void Messenger_Class::Receive(Interfaces::Message64::Message resp)
{
  // Validate parameters

  if (resp == nullptr)
    THROW_MSG("resp parameter is NULL");

  uint8_t buf[Interfaces::Message64::Size + 1];

  int32_t count = hid_read_timeout((hid_device *) this->handle, buf, sizeof(buf),
    this->timeout);

  // Handle the various outcomes

  if (count == 0)
    THROW_MSG("hid_read_timeout() timed out");
  else if (count == sizeof(buf))
    memcpy(resp->payload, buf + 1, Interfaces::Message64::Size);
  else if (count == Interfaces::Message64::Size)
    memcpy(resp->payload, buf, Interfaces::Message64::Size);
  else
    THROW_MSG("hid_read_timeout() failed");
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

std::string Messenger_Class::Manufacturer(void)
{
  wchar_t wbuf[256];
  char buf[256];

  if (hid_get_manufacturer_string((hid_device *) this->handle, wbuf, sizeof(wbuf)) != 0)
    THROW_MSG("hid_get_manufacturer_string() failed");

  wcstombs(buf, wbuf, 256);
  return std::string(buf);
}

std::string Messenger_Class::Product(void)
{
  wchar_t wbuf[256];
  char buf[256];

  if (hid_get_product_string((hid_device *) this->handle, wbuf, sizeof(wbuf)) != 0)
    THROW_MSG("hid_get_product_string() failed");

  wcstombs(buf, wbuf, 256);
  return std::string(buf);
}

std::string Messenger_Class::SerialNumber(void)
{
  wchar_t wbuf[256];
  char buf[256];

  if (hid_get_serial_number_string((hid_device *) this->handle, wbuf, sizeof(wbuf)) != 0)
    THROW_MSG("hid_get_serial_number_string() failed");

  wcstombs(buf, wbuf, 256);
  return std::string(buf);
}
