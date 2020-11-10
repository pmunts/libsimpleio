// HDC1080 Temperature/Humidity Sensor services

// Copyright (C)2018, Philip Munts, President, Munts AM Corp.
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

#include <thread>
#include <chrono>

#include <exception-libsimpleio.h>
#include <hdc1080.h>

// HDC1080 register addresses

#define RegTemperature		0x00
#define RegHumidity		0x01
#define RegConfiguration	0x02
#define RegSerialNumberFirst	0xFB
#define RegSerialNumberMiddle	0xFC
#define RegSerialNumberLast	0xFD
#define RegManufacturerID	0xFE
#define RegDeviceID		0xFF

// Device_Class constructor

HDC1080::Device_Class::Device_Class(Interfaces::I2C::Bus bus)
{
  // Validate parameters

  if (bus == nullptr) THROW_MSG("The bus parameter is NULL");

  // Save some parameters

  this->bus = bus;
  this->addr = 0x40;

  // Issue software reset

  this->WriteRegister(RegConfiguration, 0x8000);
  std::this_thread::sleep_for(std::chrono::milliseconds(100));

  // Heater off, acquire temp or humidity, 14 bit resolutions

  this->WriteRegister(RegConfiguration, 0x0000);
}

// Read from an HDC1080 device register

uint16_t HDC1080::Device_Class::ReadRegister(uint8_t reg)
{
  uint8_t cmd[1];
  uint8_t resp[2];

  // Validate parameters

  if ((reg > RegConfiguration) && (reg < RegSerialNumberFirst))
    THROW_MSG("The reg parameter is out of range");

  // Build the command

  cmd[0] = reg;

  // Issue the command

  if ((reg == RegTemperature) || (reg == RegHumidity))
    this->bus->Transaction(this->addr, cmd, 1, resp, 2, 10000);
  else
    this->bus->Transaction(this->addr, cmd, 1, resp, 2);

  return resp[0]*256 + resp[1];
}

// Write to an HDC1080 device register

void HDC1080::Device_Class::WriteRegister(uint8_t reg, uint16_t data)
{
  uint8_t cmd[3];

  // Validate parameters

  if ((reg > RegConfiguration) && (reg < RegSerialNumberFirst))
    THROW_MSG("The reg parameter is out of range");

  // Build the command

  cmd[0] = reg;
  cmd[1] = data / 256;
  cmd[2] = data % 256;

  // Issue the command

  this->bus->Transaction(this->addr, cmd, 3, nullptr, 0);
}

// Aquire a temperature sample

double HDC1080::Device_Class::temperature(void)
{
  return this->ReadRegister(RegTemperature)/65536.0*165.0 - 40.0;
}

// Acquire a humidity sample

double HDC1080::Device_Class::humidity(void)
{
  return this->ReadRegister(RegHumidity)/65536.0*100.0;
}

// Fetch the manufacturer ID

uint16_t HDC1080::Device_Class::manufacturerID(void)
{
  return this->ReadRegister(RegManufacturerID);
}

// Fetch the device ID

uint16_t HDC1080::Device_Class::deviceID(void)
{
  return this->ReadRegister(RegDeviceID);
}
