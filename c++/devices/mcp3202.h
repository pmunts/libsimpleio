// MCP3202 ADC (Analog to Digital Converter) input services

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

#ifndef _MCP3202_H
#define _MCP3202_H

#include <cstdint>
#include <cstdlib>

#include <adc-interface.h>
#include <spi-interface.h>

namespace MCP3202
{
  const unsigned MaxChannels = 2;
  const unsigned Resolution = 12;
  const unsigned Steps = 4096;
  const bool SingleEnded = false;
  const bool Differential = true;

  // MCP3202 device class

  struct DeviceClass
  {
    DeviceClass(const char *name);

    uint16_t read(unsigned channel, bool differential = SingleEnded);

  private:

    Interfaces::SPI dev;
  };

  typedef DeviceClass *Device;

  // MCP3202 analog input class

  struct InputClass: public Interfaces::ADC_Interface
  {
    InputClass(Device dev, unsigned channel, bool differential = false,
      double reference = 3.3, double gain = 1.0, double offset = 0.0);

    // ADC input methods

    virtual int read(void);

    virtual double voltage(void);

    // ADC input operators

    virtual operator int(void);

    virtual operator double(void);

  private:

    Device dev;
    unsigned channel;
    bool differential;
    double reference;
    double gain;
    double offset;
  };
}

#endif
