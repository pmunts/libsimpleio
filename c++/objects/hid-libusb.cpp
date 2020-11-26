// Raw HID device services using libusb 1.0

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

#include <exception-raisers.h>
#include <hid-libusb.h>
#include <libusb-1.0/libusb.h>

using namespace HID::libusb;

// Constructors

Messenger_Class::Messenger_Class(uint16_t VID, uint16_t PID, const char *serial,
  unsigned timeoutms, unsigned iface, unsigned epin, unsigned epout)
{
  // Validate parameters

  if (serial != nullptr)
    if (strlen(serial) > 126)
      THROW_MSG("serial number parameter is too long");

  // Initialize the libusb internals.  It is safe to call libusb_init()
  // multiple times.

  if (libusb_init(NULL))
    THROW_MSG("libusb_init() failed");

  // Fetch the list of USB devices.

  libusb_device **devlist;

  if (libusb_get_device_list(NULL, &devlist) < 0)
    THROW_MSG("libusb_get_device_list() failed");

  // Iterate over the list of USB devices, looking for matching VID, PID,
  // and serial number.

  libusb_device **dev;
  libusb_device_handle *devhandle = nullptr;

  for (dev = devlist; *dev != nullptr; dev++)
  {
    // Get the device descriptor for this candidate USB device

    struct libusb_device_descriptor devdesc;
    libusb_get_device_descriptor(*dev, &devdesc);

    // Check for matching VID and PID

    if (VID != devdesc.idVendor) continue;
    if (PID != devdesc.idProduct) continue;

    // Try to open this candidate USB device

    if (libusb_open(*dev, &devhandle)) continue;

    // If no specific serial number was requested, we are done.

    if (serial == nullptr) break;
    if (strlen(serial) == 0) break;

    // Check whether this candidate USB device has a serial number

    if (devdesc.iSerialNumber == 0)
      goto CLOSE_AND_CONTINUE;

    // This candidate USB device does indeed have a serial number,
    // so fetch it.

    char devserial[256];
    memset(devserial, 0, sizeof(devserial));

    if (libusb_get_string_descriptor_ascii(devhandle, devdesc.iSerialNumber,
      (unsigned char *) devserial, sizeof(devserial) - 1) < 0)
      goto CLOSE_AND_CONTINUE;

    // If we have a matching serial number, we are done.

    if (!strcmp(serial, devserial)) break;

    // This candidate USB device didn't match, for whatever reason,
    // so close it and try again with the next device on the list.

CLOSE_AND_CONTINUE:

    libusb_close(devhandle);
  }

  // Free the device list

  libusb_free_device_list(devlist, 1);

  if (devhandle == nullptr)
    THROW_MSG("Unable to find matching device");

  if (libusb_has_capability(LIBUSB_CAP_SUPPORTS_DETACH_KERNEL_DRIVER))
    if (libusb_set_auto_detach_kernel_driver(devhandle, 1))
      THROW_MSG("libusb_set_auto_detach_kernel_driver() failed");

  if (libusb_claim_interface(devhandle, iface))
    THROW_MSG("libusb_claim_interface() failed");

  this->handle = devhandle;
  this->epin = epin;
  this->epout = epout;
  this->timeout = timeoutms;
}

// Methods

void Messenger_Class::Send(Interfaces::Message64::Message cmd)
{
  int status, count;

  // Validate parameters

  if (cmd == nullptr)
    THROW_MSG("cmd parameter is NULL");

  // Send the report

  status = libusb_interrupt_transfer((libusb_device_handle *) this->handle,
    this->epout, cmd->payload, Interfaces::Message64::Size, &count,
    this->timeout);

  // Handle error conditions

  if (status == LIBUSB_ERROR_TIMEOUT)
    THROW_MSG("libusb_interrupt_transfer() timed out");

  if (status < LIBUSB_SUCCESS)
    THROW_MSG("libusb_interrupt_transfer() failed");

  if ((count != Interfaces::Message64::Size) &&
      (count != Interfaces::Message64::Size + 1))
    THROW_MSG("incorrect send byte count");
}

void Messenger_Class::Receive(Interfaces::Message64::Message resp)
{
  int status, count;

  // Validate parameters

  if (resp == nullptr)
    THROW_MSG("resp parameter is NULL");

  // Receive the report

  status = libusb_interrupt_transfer((libusb_device_handle *) this->handle,
    this->epin, resp->payload, Interfaces::Message64::Size, &count,
    this->timeout);

  // Handle error conditions

  if (status == LIBUSB_ERROR_TIMEOUT)
    THROW_MSG("libusb_interrupt_transfer() timed out");

  if (status < LIBUSB_SUCCESS)
    THROW_MSG("libusb_interrupt_transfer() failed");

  if ((count != Interfaces::Message64::Size) &&
      (count != Interfaces::Message64::Size + 1))
    THROW_MSG("incorrect send byte count");
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

typedef enum
{
  MANUFACTURER,
  PRODUCT,
  SERIALNUMBER
} StringDescriptorKinds_t;

static void GetString(void *handle, unsigned which, char *dst,
  unsigned len)
{
  libusb_device *dev = libusb_get_device((libusb_device_handle *) handle);
  struct libusb_device_descriptor desc;
  libusb_get_device_descriptor(dev, &desc);
  unsigned index;

  memset(dst, 0, len);

  switch (which)
  {
    case MANUFACTURER:
      index = desc.iManufacturer;
      break;

    case PRODUCT:
      index = desc.iProduct;
      break;

    case SERIALNUMBER:
      index = desc.iSerialNumber;
      break;
   }

   if (index == 0) return;

   if (libusb_get_string_descriptor_ascii((libusb_device_handle *) handle,
     index, (unsigned char *) dst, len -1) < LIBUSB_SUCCESS)
     THROW_MSG("libusb_get_string_descriptor_ascii() failed");
}

std::string Messenger_Class::Manufacturer(void)
{
  char buf[256];
  GetString(this->handle, MANUFACTURER, buf, sizeof(buf));
  return std::string(buf);
}

std::string Messenger_Class::Product(void)
{
  char buf[256];
  GetString(this->handle, PRODUCT, buf, sizeof(buf));
  return std::string(buf);
}

std::string Messenger_Class::SerialNumber(void)
{
  char buf[256];
  GetString(this->handle, SERIALNUMBER, buf, sizeof(buf));
  return std::string(buf);
}
