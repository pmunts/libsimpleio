// MCP3424 ADC (Analog to Digital Converter) input services

// Copyright (C)2017-2023, Philip Munts dba Munts Technologies.
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
#include <mcp3424.h>

using namespace Devices::MCP3424;

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

// Device_Class constructor

Device_Class::Device_Class(Interfaces::I2C::Bus bus, unsigned addr)
{
  // Validate parameters

  if (bus == nullptr) THROW_MSG("The bus parameter is NULL");
  if (addr > 127)     THROW_MSG("The addr parameter is out of range");

  this->bus = bus;
  this->addr = addr;
}

// Device_Class sample() method

int Device_Class::sample(unsigned channel, unsigned resolution, unsigned range)
{
  // Validate parameters

  if (channel >= MaxChannels) THROW_MSG("The channel parameter is out of range");
  if (resolution > RES18)     THROW_MSG("The resolution parameter is out of range");
  if (range > PGA8)           THROW_MSG("The range parameter is out of range");

  // Issue command to begin a conversion

  uint8_t cmd[1] = { uint8_t(0x80 + (channel << 5) + (resolution << 2) + range) };
  this->bus->Transaction(this->addr, cmd, sizeof(cmd), nullptr, 0);

  // Process results

  switch (resolution)
  {
    case RES12 :
    {
      uint8_t resp[3];

      do
      {
        this->bus->Transaction(this->addr, nullptr, 0, resp, sizeof(resp));
      } while (resp[sizeof(resp)-1] & 0x80);

      return SignExtend12((resp[0] << 8) + resp[1]);
    }
    break;

    case RES14 :
    {
      uint8_t resp[3];

      do
      {
        this->bus->Transaction(this->addr, nullptr, 0, resp, sizeof(resp));
      } while (resp[sizeof(resp)-1] & 0x80);

      return SignExtend14((resp[0] << 8) + resp[1]);
    }
    break;

    case RES16 :
    {
      uint8_t resp[3];

      do
      {
        this->bus->Transaction(this->addr, nullptr, 0, resp, sizeof(resp));
      } while (resp[sizeof(resp)-1] & 0x80);

      return SignExtend16((resp[0] << 8) + resp[1]);
    }
    break;

    case RES18 :
    {
      uint8_t resp[4];

      do
      {
        this->bus->Transaction(this->addr, nullptr, 0, resp, sizeof(resp));
      } while (resp[sizeof(resp)-1] & 0x80);

      return SignExtend18((resp[0] << 16) + (resp[1] << 8) + resp[2]);
    }
    break;

    default :
      return 0;
  }
}

// Analog input class constructor

Input_Class::Input_Class(Device dev, unsigned channel, unsigned resolution,
  unsigned range, double gain)
{
  this->dev = dev;
  this->channel = channel;
  this->res = resolution;
  this->range = range;
  this->gain = gain;
}

// Analog input class methods

int Input_Class::sample(void)
{
  return dev->sample(this->channel, this->res, this->range);
}

static const unsigned Bits[]  = { 12, 14, 16, 18 };

unsigned Input_Class::resolution(void)
{
  return Bits[this->res];
}

static const int Steps[] = { 2048, 8192, 32768, 131072 };
static const int Gains[] = { 1, 2, 4, 8 };

double Input_Class::voltage(void)
{
  return double(this->sample())/Steps[this->res]*2.048*Gains[this->range]/this->gain;
}
