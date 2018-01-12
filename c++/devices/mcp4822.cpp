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
#include <spi-libsimpleio.h>

// Device class constructor

MCP4822::DeviceClass::DeviceClass(const char *name)
{
  // Validate parameters

  if (name == NULL) throw EINVAL;

  this->dev = new SPI_libsimpleio(name, 0, 8, 20000000);
}

// Device class methods

void MCP4822::DeviceClass::write(unsigned channel, int level)
{
  // Validate parameters

  if (channel >= MaxChannels) throw EINVAL;
  if ((level < 0) || (level >= int(Steps))) throw EINVAL;

  uint8_t cmd[2];

  cmd[0] = 0x10 + (channel << 7) + (level >> 8);
  cmd[1] = level & 0xFF;

  this->dev->Transaction(cmd, 2, 0, NULL, 0);
}

// Output class constructor

MCP4822::OutputClass::OutputClass(Device dev, unsigned channel,
  double gain, double offset)
{
  // Validate parameters

  if (dev == NULL) throw EINVAL;
  if (channel >= MaxChannels) throw EINVAL;

  this->dev = dev;
  this->channel = channel;
  this->gain = gain;
  this->offset = offset;
}

// Output class methods

void MCP4822::OutputClass::write(int level)
{
  if ((level < 0) || (level >= int(Steps))) throw EINVAL;

  this->dev->write(this->channel, level);
}

void MCP4822::OutputClass::write(double voltage)
{
 OutputClass::write(uint16_t((voltage + this->offset)*1000));
}
