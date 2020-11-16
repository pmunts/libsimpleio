// MCP4822 DAC (Digital to Analog Converter) output services

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
#include <mcp4822.h>

using namespace Devices::MCP4822;

// Device class constructor

Device_Class::Device_Class(Interfaces::SPI::Device dev)
{
  // Validate parameters

  if (dev == nullptr)
    THROW_MSG("The dev parameter is NULL");

  this->dev = dev;
}

// Device class methods

void Device_Class::write(unsigned channel, int sample)
{
  // Validate parameters

  if (channel >= MaxChannels)
    THROW_MSG("The channel parameter is out of range");

  if ((sample < 0) || (sample >= int(Steps)))
    THROW_MSG("The sample parameter is out of range");

  uint8_t cmd[2];

  cmd[0] = 0x10 + (channel << 7) + (sample >> 8);
  cmd[1] = sample & 0xFF;

  this->dev->Transaction(cmd, 2, nullptr, 0);
}

// Sample_Class constructor

Sample_Class::Sample_Class(Device dev, unsigned channel)
{
  // Validate parameters

  if (dev == nullptr)
    THROW_MSG("The dev parameter is NULL");

  if (channel >= MaxChannels)
    THROW_MSG("The channel parameter is out of range");

  this->dev = dev;
  this->channel = channel;
}

// Sample_Class methods

void Sample_Class::write(const int sample)
{
  // Validate parameters

  if ((sample < 0) || (sample >= int(Steps)))
    THROW_MSG("The sample parameter is out of range");

  this->dev->write(this->channel, sample);
}

unsigned Sample_Class::resolution(void)
{
  return Resolution;
}
