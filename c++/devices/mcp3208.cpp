// MCP3208 ADC (Analog to Digital Converter) input services

// Copyright (C)2017-2018, Philip Munts, President, Munts AM Corp.
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
#include <mcp3208.h>
#include <spi-libsimpleio.h>

// Device class constructor

MCP3208::DeviceClass::DeviceClass(const char *name)
{
  // Validate parameters

  if (name == NULL) throw EINVAL;

  this->dev = new SPI_libsimpleio(name, 0, 8, 1000000);
}

// Device class methods

uint16_t MCP3208::DeviceClass::read(unsigned channel, bool differential)
{
  // Validate parameters

  if (channel > MaxChannels) throw EINVAL;

  uint8_t cmd[1];
  uint8_t resp[2];

  cmd[0] = (differential ? 0x40 : 0x60) + (channel << 2);
  this->dev->Transaction(cmd, 1, 0, resp, 2);

  return (resp[0] << 4) + (resp[1] >> 4);
}

// InputClass constructor

MCP3208::InputClass::InputClass(Device dev, unsigned channel,
  bool differential, double reference, double gain, double offset)
{
  // Validate parameters

  if (dev == NULL) throw EINVAL;
  if (channel >= MaxChannels) throw EINVAL;

  this->dev = dev;
  this->channel = channel;
  this->differential = differential;
  this->reference = reference;
  this->gain = gain;
  this->offset = offset;
}

// InputClass methods

int MCP3208::InputClass::read(void)
{
  return this->dev->read(this->channel, this->differential);
}

double MCP3208::InputClass::voltage(void)
{
  return double(read())*this->reference/double(Steps)/this->gain -
    this->offset;
}

// InputClass operators

MCP3208::InputClass::operator int(void)
{
  return this->read();
}

MCP3208::InputClass::operator double(void)
{
  return this->voltage();
}
