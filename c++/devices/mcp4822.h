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

#ifndef _MCP4822_H
#define _MCP4822_H

#include <cstdint>
#include <cstdlib>

#include <dac-interface.h>
#include <spi-interface.h>

namespace MCP4822
{
  const unsigned MaxChannels = 2;
  const unsigned Resolution = 12;
  const unsigned Steps = 4096;

  // MCP4822 device class

  struct DeviceClass
  {
    DeviceClass(const char *name);

    void write(unsigned channel, int level);

  private:

    Interfaces::SPI dev;
  };

  typedef DeviceClass *Device;

  // MCP4822 analog output class

  struct OutputClass: public Interfaces::DAC_Interface
  {
    OutputClass(Device dev, unsigned channel, double gain = 1.0,
      double offset = 0.0);

    // DAC output methods

    virtual void write(const int level);

    virtual void write(const double voltage);

    // DAC output operators

    virtual void operator =(const int level);

    virtual void operator =(const double voltage);

  private:

    Device dev;
    unsigned channel;
    double gain;
    double offset;
  };
}

#endif
