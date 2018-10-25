// TH02 Temperature/Humidity Sensor services

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

#include <unistd.h>

#include <exception-libsimpleio.h>
#include <th02.h>

// TH02 register addresses

#define RegStatus	0x00
#define RegData		0x01
#define RegConfig	0x03
#define RegID		0x11

// TH02 command codes

#define cmdInit		0x00  // Turn off heater
#define cmdTemp		0x11  // Request temperature sample
#define cmdHumid	0x01  // Request humidity sample

// TH02 status masks

#define Busy		0x01  // Zero when conversion complete

// Device_Class constructor

TH02::Device_Class::Device_Class(Interfaces::I2C::Bus bus)
{
  // Validate parameters

  if (bus == nullptr) THROW_MSG("The bus parameter is NULL");

  // Save some parameters

  this->bus = bus;
  this->addr = 0x40;

  // Turn the heater off

  this->WriteRegister(RegConfig, cmdInit);
}

// Read from an TH02 device register

uint8_t TH02::Device_Class::ReadRegister(uint8_t reg)
{
  uint8_t cmd[1];
  uint8_t resp[1];

  // Validate parameters

  if (reg > RegID)
    THROW_MSG("The reg parameter is out of range");

  if ((reg > RegConfig) && (reg < RegID))
    THROW_MSG("The reg parameter is out of range");

  if ((reg > RegConfig) && (reg < RegID))
    THROW_MSG("The reg parameter is out of range");

  // Build the command

  cmd[0] = reg;

  // Issue the command

  this->bus->Transaction(this->addr, cmd, sizeof(cmd), resp, sizeof(resp));

  // Return the result

  return resp[0];
}

// Write to an TH02 device register

void TH02::Device_Class::WriteRegister(uint8_t reg, uint8_t data)
{
  uint8_t cmd[2];

  // Validate parameters

  if (reg > RegID)
    THROW_MSG("The reg parameter is out of range");

  if ((reg > RegConfig) && (reg < RegID))
    THROW_MSG("The reg parameter is out of range");

  if ((reg > RegConfig) && (reg < RegID))
    THROW_MSG("The reg parameter is out of range");

  // Build the command

  cmd[0] = reg;
  cmd[1] = data;

  // Issue the command

  this->bus->Transaction(this->addr, cmd, sizeof(cmd), nullptr, 0);
}

uint16_t TH02::Device_Class::ReadData(uint8_t which)
{
  uint8_t cmd[1];
  uint8_t resp[2];

  // Start conversion

  this->WriteRegister(RegConfig, which);

  // Wait for completion

  while (this->ReadRegister(RegStatus) & Busy);

  // Fetch result

  cmd[0] = RegData;
  this->bus->Transaction(this->addr, cmd, sizeof(cmd), resp, sizeof(resp));

  // Return result

  return resp[0]*256 + resp[1];
}

// Aquire a temperature sample

double TH02::Device_Class::temperature(void)
{
  return (ReadData(cmdTemp) >> 2)/32.0 - 50.0;
}

// Humidity linearization Coefficients

#define A0 (-4.7844)
#define A1 0.4008
#define A2 (-0.00393)

#define Q0 0.1973
#define Q1 0.00237

// Acquire a humidity sample

double TH02::Device_Class::humidity(void)
{
  // Get humidity sample

  double RHvalue = (ReadData(cmdHumid) >> 4)/16.0 - 24.0;

  // Perform linearization

  double RHlinear = RHvalue - (RHvalue*RHvalue*A2 + RHvalue*A1 + A0);

  // Perform temperature compensation

  return RHlinear + (this->temperature() - 30.0)*(RHlinear*Q1 + Q0);
}

// Fetch the device ID

uint8_t TH02::Device_Class::deviceID(void)
{
  return this->ReadRegister(RegID);
}
