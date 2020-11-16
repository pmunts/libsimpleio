// MCP3208 ADC (Analog to Digital Converter) input services

// Copyright (C)2017-2020, Philip Munts, President, Munts AM Corp.
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

#include <exception-raisers.h>
#include <mcp3208.h>

using namespace Devices::MCP3208;

// Device class constructor

Device_Class::Device_Class(Interfaces::SPI::Device dev)
{
  // Validate parameters

  if (dev == nullptr) THROW_MSG("The dev parameter is NULL");

  this->dev = dev;
}

// Sample_Class constructor

Sample_Class::Sample_Class(Device dev, unsigned channel, bool differential)
{
  // Validate parameters

  if (dev == nullptr)         THROW_MSG("The dev parameter is NULL");
  if (channel >= MaxChannels) THROW_MSG("The channel parameter is out of range");

  this->dev = dev;
  this->channel = channel;
  this->differential = differential;
}

// Sample_Class methods

int Sample_Class::sample(void)
{
  uint8_t cmd[1];
  uint8_t resp[2];

  cmd[0] = (differential ? 0x40 : 0x60) + (channel << 2);
  this->dev->dev->Transaction(cmd, 1, resp, 2);

  return (resp[0] << 4) + (resp[1] >> 4);
}

unsigned Sample_Class::resolution(void)
{
  return Resolution;
}
