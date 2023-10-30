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

#ifndef _MCP3424_H
#define _MCP3424_H

#include <cstdint>

#include <adc-interface.h>
#include <i2c-interface.h>

namespace Devices::MCP3424
{
  static const unsigned MaxChannels = 4;

  // Resolution settings

  enum Resolutions { RES12, RES14, RES16, RES18 };

  // PGA (Programmable Gain Amplifier) settings

  enum PGAGains { PGA1, PGA2, PGA4, PGA8 };

  // Device class (incomplete)

  struct Device_Class;

  typedef Device_Class *Device;

  // Analog input class

  struct Input_Class: public Interfaces::ADC::Sample_Interface,
    public Interfaces::ADC::Voltage_Interface
  {
    Input_Class(Device dev, unsigned channel, unsigned resolution,
      unsigned range, double gain = 1.0);

    virtual int sample(void);

    virtual unsigned resolution(void);

    virtual double voltage(void);

  private:

    Device dev;
    unsigned channel;
    unsigned res;
    unsigned range;
    double gain;
  };

  // Device class (completed)

  struct Device_Class
  {
    Device_Class(Interfaces::I2C::Bus bus, unsigned addr);

  private:

    int sample(unsigned channel, unsigned resolution, unsigned range);

    Interfaces::I2C::Bus bus;
    unsigned addr;

    friend struct Input_Class;
  };
}

#endif
