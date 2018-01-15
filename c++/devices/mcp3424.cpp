// MCP3424 ADC (Analog to Digital Converter) input services

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
#include <mcp3424.h>

// Define some sign extending functions

static int SignExtend12(unsigned n)
{
  struct { signed int x : 12; } w;
  w.x = n;
  return w.x;
}

static int SignExtend14(unsigned n)
{
  struct { signed int x : 14; } w;
  w.x = n;
  return w.x;
}

static int SignExtend16(unsigned n)
{
  struct { signed int x : 16; } w;
  w.x = n;
  return w.x;
}

static int SignExtend18(unsigned n)
{
  struct { signed int x : 18; } w;
  w.x = n;
  return w.x;
}

// DeviceClass constructor

MCP3424::DeviceClass::DeviceClass(Interfaces::I2C bus, unsigned addr)
{
  // Validate parameters

  if (bus == NULL) throw EINVAL;
  if (addr > 127) throw EINVAL;

  this->bus = bus;
  this->addr = addr;
}

// DeviceClass read() method

int MCP3424::DeviceClass::read(unsigned channel, unsigned resolution,
  unsigned range)
{
  // Validate parameters

  if (channel >= MaxChannels) throw EINVAL;
  if (resolution > RES18) throw EINVAL;
  if (range > PGA8) throw EINVAL;

  // Issue command to begin a conversion

  uint8_t cmd[1] = { uint8_t(0x80 + (channel << 5) + (resolution << 2) + range) };
  this->bus->Transaction(this->addr, cmd, sizeof(cmd), NULL, 0);

  // Process results

  switch (resolution)
  {
    case RES12 :
    {
      uint8_t resp[3];

      do
      {
        this->bus->Transaction(this->addr, NULL, 0, resp, sizeof(resp));
      } while (resp[sizeof(resp)-1] & 0x80);

      return SignExtend12((resp[0] << 8) + resp[1]);
    }
    break;

    case RES14 :
    {
      uint8_t resp[3];

      do
      {
        this->bus->Transaction(this->addr, NULL, 0, resp, sizeof(resp));
      } while (resp[sizeof(resp)-1] & 0x80);

      return SignExtend14((resp[0] << 8) + resp[1]);
    }
    break;

    case RES16 :
    {
      uint8_t resp[3];

      do
      {
        this->bus->Transaction(this->addr, NULL, 0, resp, sizeof(resp));
      } while (resp[sizeof(resp)-1] & 0x80);

      return SignExtend16((resp[0] << 8) + resp[1]);
    }
    break;

    case RES18 :
    {
      uint8_t resp[4];

      do
      {
        this->bus->Transaction(this->addr, NULL, 0, resp, sizeof(resp));
      } while (resp[sizeof(resp)-1] & 0x80);

      return SignExtend18((resp[0] << 16) + (resp[1] << 8) + resp[2]);
    }
    break;

    default :
      return 0;
  }
}

// Analog input class constructor

MCP3424::InputClass::InputClass(Device dev, unsigned channel,
  unsigned resolution, unsigned range, double gain, double offset)
{
  this->dev = dev;
  this->channel = channel;
  this->resolution = resolution;
  this->range = range;
  this->gain = gain;
  this->offset = offset;
}

// Analog input class methods

int MCP3424::InputClass::read(void)
{
  return dev->read(this->channel, this->resolution, this->range);
}

static const int Steps[] = { 2048, 8192, 32768, 131072 };
static const int Gains[] = { 1, 2, 4, 8 };

double MCP3424::InputClass::voltage(void)
{
  return double(this->read())/Steps[this->resolution]*2.048*Gains[this->range]/
    this->gain - this->offset;
}

// InputClass operators

MCP3424::InputClass::operator int(void)
{
  return this->read();
}

MCP3424::InputClass::operator double(void)
{
  return this->voltage();
}
