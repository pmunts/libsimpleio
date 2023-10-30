// HDC1080 Temperature/Humidity Sensor services

// Copyright (C)2018-2023, Philip Munts dba Munts Technologies.
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

#ifndef _HDC1080_H
#define _HDC1080_H

#include <cstdint>

#include <humidity-interface.h>
#include <i2c-interface.h>
#include <temperature-interface.h>

namespace Devices::HDC1080
{
  struct Device_Class:
    Interfaces::Temperature::Sensor_Interface,
    Interfaces::Humidity::Sensor_Interface
  {
    Device_Class(Interfaces::I2C::Bus bus);

    double temperature(void);

    double humidity(void);

    uint16_t manufacturerID(void);

    uint16_t deviceID(void);

  private:

    Interfaces::I2C::Bus bus;
    unsigned addr;

    uint16_t ReadRegister(uint8_t reg);

    void WriteRegister(uint8_t reg, uint16_t data);
  };

  typedef Device_Class *Device;

}

#endif
