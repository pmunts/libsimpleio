// ADS1015 ADC (Analog to Digital Converter) input services

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

#include <ads1015.h>
#include <exception-raisers.h>

using namespace Devices::ADS1015;

// Map full scale range enum to double

static const double Ranges[] = { 6.144, 4.096, 2.048, 1.024, 0.512, 0.256 };

// Device_Class constructor

Device_Class::Device_Class(Interfaces::I2C::Bus bus, unsigned addr)
{
  // Validate parameters

  if (bus == nullptr) THROW_MSG("The bus parameter is NULL");
  if (addr > 127)     THROW_MSG("The addr parameter is out of range");

  this->bus = bus;
  this->addr = addr;
}

// Device_Class ReadRegister() method

uint16_t Device_Class::ReadRegister(unsigned reg)
{
  // Validate parameters

  if (reg > HIGH_THRESHOLD) THROW_MSG("The reg parameter is out of range");

  uint8_t cmd[1];
  uint8_t resp[2];

  cmd[0] = reg;

  this->bus->Transaction(this->addr, cmd, 1, resp, 2);

  return (resp[0] << 8) + resp[1];
}

// Device_Class WriteRegister() method

void Device_Class::WriteRegister(unsigned reg, uint16_t value)
{
  // Validate parameters

  if (reg > HIGH_THRESHOLD) THROW_MSG("The reg parameter is out of range");

  uint8_t cmd[3];

  cmd[0] = reg;
  cmd[1] = value / 256;
  cmd[2] = value % 256;

  this->bus->Transaction(this->addr, cmd, 3, nullptr, 0);
}

// Permute the channel numbers so that the single ended channels are 0-3

static const unsigned PermuteChannels[] = { 4, 5, 6, 7, 0, 1, 2, 3 };

// Input_Class constructor

Input_Class::Input_Class(Device dev, unsigned channel, unsigned range,
  double gain)
{
  // Validate parameters


  if (dev == nullptr)   THROW_MSG("The dev parameter is NULL");
  if (channel > Diff23) THROW_MSG("The channel parameter is out of range");
  if (range > FSR256)   THROW_MSG("The range parameter is out of range");

  this->dev = dev;
  this->channel = PermuteChannels[channel];
  this->range = range;
  this->gain = gain;
}

// Input_Class methods

int Input_Class::sample(void)
{
  // Start conversion

  this->dev->WriteRegister(CONFIG, (1 << 15) + (this->channel << 12) +
    (this->range << 9) + (1 << 8));

  // Wait until conversion complete

  while ((this->dev->ReadRegister(CONFIG) & 0x8000) == 0);

  // Get conversion result

  return int16_t(this->dev->ReadRegister(CONVERSION))/16;
}

unsigned Input_Class::resolution(void)
{
  return Resolution;
}

double Input_Class::voltage(void)
{
  return double(this->sample())*Ranges[this->range]/double(Steps)*2.0/this->gain;
}
