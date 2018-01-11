// PCA9685 LED controller services

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
#include <cstring>
#include <pca9685.h>

// PCA9685 Register addresses -- Only a few are defined: Those that we
// will need below

#define MODE1		0x00
#define MODE2		0x01
#define LED0_ON_L	0x06
#define PRE_SCALE	0xFE

// DeviceClass constructor

PCA9685::DeviceClass::DeviceClass(Interfaces::I2C bus, unsigned addr,
  unsigned freq, unsigned clock)
{
  // Validate parameters

  if (bus == NULL) throw EINVAL;
  if (addr > 127) throw EINVAL;
  if (clock > 50000000) throw EINVAL;

  // Save some parameters

  this->bus = bus;
  this->addr = addr;
  this->freq = freq;

  // Configure the PCA9685 device

  if (clock == 0)
  {
    WriteRegister(MODE1, 0x30); // Set SLEEP
    WriteRegister(PRE_SCALE, 25000000/4096/freq - 1);
    WriteRegister(MODE1, 0x20); // Clear SLEEP
  }
  else
  {
    WriteRegister(MODE1, 0x70); // Set SLEEP
    WriteRegister(PRE_SCALE, clock/4096/freq - 1);
    WriteRegister(MODE1, 0x60); // Clear SLEEP
  }

  WriteRegister(MODE2, 0x0C); // Totem-pole outputs, change on ACK
}

// DeviceClass methods

void PCA9685::DeviceClass::WriteRegister(uint8_t regaddr, uint8_t regdata)
{
  uint8_t cmd[2];

  cmd[0] = regaddr;
  cmd[1] = regdata;

  this->bus->Transaction(this->addr, cmd, sizeof(cmd), NULL, 0);
}

void PCA9685::DeviceClass::ReadChannel(unsigned channel, uint8_t *regdata)
{
  // Validate parameters

  if (channel >= MaxChannels) throw EINVAL;

  uint8_t cmd[1];

  cmd[0] = LED0_ON_L + channel*4;

  this->bus->Transaction(this->addr, cmd, sizeof(cmd), regdata, 4);
}

void PCA9685::DeviceClass::WriteChannel(unsigned channel,
  const uint8_t *regdata)
{
  // Validate parameters

  if (channel >= MaxChannels) throw EINVAL;

  uint8_t cmd[5];

  cmd[0] = LED0_ON_L + channel*4;
  cmd[1] = regdata[0];
  cmd[2] = regdata[1];
  cmd[3] = regdata[2];
  cmd[4] = regdata[3];

  this->bus->Transaction(this->addr, cmd, sizeof(cmd), NULL, 0);
}

unsigned PCA9685::DeviceClass::frequency(void)
{
  return this->freq;
}

//*****************************************************************************

// Predefined PCA9685 GPIO output channel settings

static const uint8_t GPIO_ON[]  = { 0x00, 0x10, 0x00, 0x00 };
static const uint8_t GPIO_OFF[] = { 0x00, 0x00, 0x00, 0x10 };

// GPIO constructor

PCA9685::GPIO::GPIO(Device dev, unsigned channel, bool state)
{
  // Validate parameters

  if (dev == NULL) throw EINVAL;
  if (channel >= MaxChannels) throw EINVAL;

  // Write the channel settings

  dev->WriteChannel(channel, state ? GPIO_ON : GPIO_OFF);

  this->dev = dev;
  this->channel = channel;
}

// GPIO methods

bool PCA9685::GPIO::read(void)
{
  uint8_t regdata[4];

  this->dev->ReadChannel(this->channel, regdata);
  return memcmp(regdata, GPIO_OFF, sizeof(regdata));
}

void PCA9685::GPIO::write(bool state)
{
  // Write the channel settings

  this->dev->WriteChannel(this->channel, state ? GPIO_ON : GPIO_OFF);
}

//*****************************************************************************

// PWM output constructor

PCA9685::PWM::PWM(Device dev, unsigned channel, double dutycycle)
{
  // Validate parameters

  if (dev == NULL) throw EINVAL;
  if (channel >= MaxChannels) throw EINVAL;
  if (dutycycle < Interfaces::PWM_Interface::DUTYCYCLE_MIN) throw EINVAL;
  if (dutycycle > Interfaces::PWM_Interface::DUTYCYCLE_MAX) throw EINVAL;

  // Calculate the channel settings for the desired duty cycle

  uint16_t offtime = uint16_t(dutycycle*40.95 + 0.5);
  uint8_t data[4] = { 0, 0, uint8_t(offtime % 256), uint8_t(offtime / 256) };

  // Write the channel settings

  dev->WriteChannel(channel, data);

  this->dev = dev;
  this->channel = channel;
}

// PWM methods

void PCA9685::PWM::write(double dutycycle)
{
  // Validate parameters

  if (dutycycle < Interfaces::PWM_Interface::DUTYCYCLE_MIN) throw EINVAL;
  if (dutycycle > Interfaces::PWM_Interface::DUTYCYCLE_MAX) throw EINVAL;

  // Calculate the channel settings for the desired duty cycle

  uint16_t offtime = uint16_t(dutycycle*40.95 + 0.5);
  uint8_t data[4] = { 0, 0, uint8_t(offtime % 256), uint8_t(offtime / 256) };

  // Write the channel settings

  this->dev->WriteChannel(channel, data);
}

//*****************************************************************************

// Servo output constructor

PCA9685::Servo::Servo(Device dev, unsigned channel, double position)
{
  // Validate parameters

  if (dev == NULL) throw EINVAL;
  if (channel >= MaxChannels) throw EINVAL;
  if (position < Interfaces::Servo_Interface::POSITION_MIN) throw EINVAL;
  if (position > Interfaces::Servo_Interface::POSITION_MAX) throw EINVAL;

  // Calculate the channel settings for the desired position

  unsigned freq = this->dev->frequency();
  uint16_t offtime = uint16_t((2.0475*position + 6.1425)*freq + 0.5);
  uint8_t data[4] = { 0, 0, uint8_t(offtime % 256), uint8_t(offtime / 256) };

  // Write the channel settings

  dev->WriteChannel(channel, data);

  this->dev = dev;
  this->channel = channel;
}

void PCA9685::Servo::write(double position)
{
  // Validate parameters

  if (position < Interfaces::Servo_Interface::POSITION_MIN) throw EINVAL;
  if (position > Interfaces::Servo_Interface::POSITION_MAX) throw EINVAL;

  // Calculate the channel settings for the desired position

  unsigned freq = this->dev->frequency();
  uint16_t offtime = uint16_t((2.0475*position + 6.1425)*freq + 0.5);
  uint8_t data[4] = { 0, 0, uint8_t(offtime % 256), uint8_t(offtime / 256) };

  // Write the channel settings

  this->dev->WriteChannel(channel, data);
}
