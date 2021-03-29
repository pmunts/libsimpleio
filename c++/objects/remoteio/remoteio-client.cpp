// Remote I/O Protocol Client Services

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

// The Remote I/O Protocol specification is available online at:
//
// http://git.munts.com/libsimpleio/doc/RemoteIOProtocol.pdf

#include <cstring>

#include <exception-raisers.h>
#include <remoteio-client.h>

#if defined(HID_USE_HIDAPI)
#include <hid-hidapi.h>
#elif defined(HID_USE_LIBSIMPLEIO)
#include <hid-libsimpleio.h>
#elif defined(HID_USE_LIBUSB)
#include <hid-libusb.h>
#elif defined(HID_USE_POSIX)
#include <hid-posix.h>
#elif defined(HID_USE_LIBREMOTEIO)
#include <hid-libremoteio.h>
#else
#error Must define one of HID_USE_HIDAPI, HID_USE_LIBSIMPLEIO, HID_USE_LIBUSB, HID_USE_POSIX or HID_USE_LIBREMOTEIO.
#endif

#include <hid-munts.h>

using namespace RemoteIO;
using namespace RemoteIO::Client;

// Default Constructor
Device_Class::Device_Class(uint16_t VID, uint16_t PID, const char *serial,
  int timeoutms)
{
#if defined(HID_USE_HIDAPI)
  this->msg = new HID::hidapi::Messenger_Class(VID, PID, serial, timeoutms);
#elif defined(HID_USE_LIBSIMPLEIO)
  this->msg = new libsimpleio::HID::Messenger_Class(VID, PID, serial, timeoutms);
#elif defined(HID_USE_LIBUSB)
  this->msg = new HID::libusb::Messenger_Class(VID, PID, serial, timeoutms);
#elif defined(HID_USE_POSIX)
  this->msg = new HID::Posix::Messenger_Class(VID, PID, serial, timeoutms);
#elif defined(HID_USE_LIBREMOTEIO)
  this->msg = new HID::libremoteio::Messenger_Class(VID, PID, serial, timeoutms);
#endif

  this->num = 0;
  this->Version = QueryVersion();
  this->Capability = QueryCapability();

  if (this->Capability.find("ADC") != std::string::npos)
    this->ADC_Inputs = QueryChannels(ADC_PRESENT_REQUEST);

  if (this->Capability.find("DAC") != std::string::npos)
    this->DAC_Outputs = QueryChannels(DAC_PRESENT_REQUEST);

  if (this->Capability.find("GPIO") != std::string::npos)
    this->GPIO_Pins = QueryChannels(GPIO_PRESENT_REQUEST);

  if (this->Capability.find("I2C") != std::string::npos)
    this->I2C_Buses = QueryChannels(I2C_PRESENT_REQUEST);

  if (this->Capability.find("PWM") != std::string::npos)
    this->PWM_Outputs = QueryChannels(PWM_PRESENT_REQUEST);

  if (this->Capability.find("SPI") != std::string::npos)
    this->SPI_Slaves = QueryChannels(SPI_PRESENT_REQUEST);

  if (this->Capability.find("DEVICE") != std::string::npos)
    this->Abstract_Devices = QueryChannels(DEVICE_PRESENT_REQUEST);
}

// Constructor

Device_Class::Device_Class(Interfaces::Message64::Messenger transport)
{
  // Validate parameters

  if (transport == nullptr)
    THROW_MSG("The transport parameter is NULL");

  this->msg = transport;
  this->num = 0;
  this->Version = QueryVersion();
  this->Capability = QueryCapability();

  if (this->Capability.find("ADC") != std::string::npos)
    this->ADC_Inputs = QueryChannels(ADC_PRESENT_REQUEST);

  if (this->Capability.find("DAC") != std::string::npos)
    this->DAC_Outputs = QueryChannels(DAC_PRESENT_REQUEST);

  if (this->Capability.find("GPIO") != std::string::npos)
    this->GPIO_Pins = QueryChannels(GPIO_PRESENT_REQUEST);

  if (this->Capability.find("I2C") != std::string::npos)
    this->I2C_Buses = QueryChannels(I2C_PRESENT_REQUEST);

  if (this->Capability.find("PWM") != std::string::npos)
    this->PWM_Outputs = QueryChannels(PWM_PRESENT_REQUEST);

  if (this->Capability.find("SPI") != std::string::npos)
    this->SPI_Slaves = QueryChannels(SPI_PRESENT_REQUEST);

  if (this->Capability.find("DEVICE") != std::string::npos)
    this->Abstract_Devices = QueryChannels(DEVICE_PRESENT_REQUEST);
}

// Execute a Remote I/O operation

void Device_Class::Transaction(Interfaces::Message64::Message cmd,
  Interfaces::Message64::Message resp)
{
  // Validate parameters

  if (cmd == nullptr)
    THROW_MSG("The command parameter is NULL");

  if (resp == nullptr)
    THROW_MSG("The response parameter is NULL");

  // Dispatch transaction

  this->num += 37;

  cmd->payload[1] = this->num;

  this->msg->Transaction(cmd, resp);

  // Handle errors

  if (resp->payload[0] != cmd->payload[0] + 1)
    THROW_MSG("Invalid response message type");

  if (resp->payload[1] != cmd->payload[1])
    THROW_MSG("Invalid response message number");

  if (resp->payload[2] != 0)
    THROW_MSG_ERR("Command failed", resp->payload[2]);
}

// Retrieve the Remote I/O server version string

std::string Device_Class::QueryVersion()
{
  Interfaces::Message64::Message_Class cmd;
  Interfaces::Message64::Message_Class resp;

  memset(cmd.payload, 0, Interfaces::Message64::Size);
  memset(resp.payload, 0, Interfaces::Message64::Size);

  cmd.payload[0] = VERSION_REQUEST;
  this->Transaction(&cmd, &resp);

  return std::string((char *) (resp.payload + 3));
}

// Retrieve the Remote I/O server capability string

std::string Device_Class::QueryCapability()
{
  Interfaces::Message64::Message_Class cmd;
  Interfaces::Message64::Message_Class resp;

  memset(cmd.payload, 0, Interfaces::Message64::Size);
  memset(resp.payload, 0, Interfaces::Message64::Size);

  cmd.payload[0] = CAPABILITY_REQUEST;
  this->Transaction(&cmd, &resp);

  return std::string((char *) (resp.payload + 3));
}

// Retrieve the set of channels available for the specified resource type

ChannelSet_t Device_Class::QueryChannels(unsigned query)
{
  Interfaces::Message64::Message_Class cmd;
  Interfaces::Message64::Message_Class resp;
  ChannelSet_t channels;
  unsigned c;

  memset(cmd.payload, 0, Interfaces::Message64::Size);
  memset(resp.payload, 0, Interfaces::Message64::Size);

  cmd.payload[0] = query;

  this->Transaction(&cmd, &resp);

  for (c = 0; c < MAX_CHANNELS; c++)
    if (resp.payload[3 + c/8] & (1 << (7 - c % 8)))
      channels.insert(c);

  return channels;
}
