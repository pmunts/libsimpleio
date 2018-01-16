// MCP4822 DAC (Digital to Analog Converter) output services

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

#include <mcp4822.h>

// Device class constructor

MCP4822::Device_Class::Device_Class(Interfaces::SPI::Device dev)
{
  // Validate parameters

  if (dev == nullptr) throw EINVAL;

  this->dev = dev;
}

// Device class methods

void MCP4822::Device_Class::write(unsigned channel, int level)
{
  // Validate parameters

  if (channel >= MaxChannels) throw EINVAL;
  if ((level < 0) || (level >= int(Steps))) throw EINVAL;

  uint8_t cmd[2];

  cmd[0] = 0x10 + (channel << 7) + (level >> 8);
  cmd[1] = level & 0xFF;

  this->dev->Transaction(cmd, 2, 0, nullptr, 0);
}

// Output_Class constructor

MCP4822::Output_Class::Output_Class(Device dev, unsigned channel,
  double gain, double offset)
{
  // Validate parameters

  if (dev == nullptr) throw EINVAL;
  if (channel >= MaxChannels) throw EINVAL;

  this->dev = dev;
  this->channel = channel;
  this->gain = gain;
  this->offset = offset;
}

// Output_Class methods

void MCP4822::Output_Class::write(const int level)
{
  // Validate parameters

  if ((level < 0) || (level >= int(Steps))) throw EINVAL;

  this->dev->write(this->channel, level);
}

void MCP4822::Output_Class::write(const double voltage)
{
 Output_Class::write(uint16_t((voltage + this->offset)*1000));
}
