// MCP3204 ADC (Analog to Digital Converter) input services

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

#ifndef _MCP3204_H
#define _MCP3204_H

#include <cstdint>

#include <adc-interface.h>
#include <spi-interface.h>

namespace Devices::MCP3204
{
  static const unsigned MaxChannels = 4;
  static const unsigned Resolution = 12;
  static const unsigned Steps = 4096;
  static const bool SingleEnded = false;
  static const bool Differential = true;

  // MCP3204 device class (incomplete)

  struct Device_Class;

  typedef Device_Class *Device;

  // MCP3204 analog input class

  struct Sample_Subclass: public Interfaces::ADC::Sample_Interface
  {
    Sample_Subclass(Device dev, unsigned channel, bool differential = false);

    // ADC input methods

    virtual int sample(void);

    virtual unsigned resolution(void);

  private:

    Device dev;
    unsigned channel;
    bool differential;
  };

  // MCP3204 device class (completed)

  struct Device_Class
  {
    Device_Class(Interfaces::SPI::Device dev);

  private:

    Interfaces::SPI::Device dev;

    friend class Sample_Subclass;
  };
}

#endif
