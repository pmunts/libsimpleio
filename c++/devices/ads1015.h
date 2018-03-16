// ADS1015 ADC (Analog to Digital Converter) input services

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

#ifndef _ADS1015_H
#define _ADS1015_H

#include <cstdint>

#include <adc-interface.h>
#include <i2c-interface.h>

namespace ADS1015
{
  const unsigned MaxChannels = 4;
  const unsigned Resolution = 12;
  const unsigned Steps = 4096;

  enum Registers { CONVERSION, CONFIG, LOW_THRESHOLD, HIGH_THRESHOLD };

  // The ADC conversion range is +/- 6144 mV etc. as selected by one of the
  // following FullScaleRange values for the PGA (Programmable Gain Amplifier).

  // WARNING: The analog input voltage must be limited to 0 to VDD,
  // not +/- 6144 mV!

  enum FullScaleRange { FSR6144, FSR4096, FSR2048, FSR1024, FSR512, FSR256 };

  // Input channels can either be single ended or differential

  enum Channels { AIN0, AIN1, AIN2, AIN3, Diff01, Diff03, Diff13, Diff23 };

  // Device class (incomplete)

  struct Device_Class;

  typedef Device_Class *Device;

  // Analog input class

  struct Input_Class: public Interfaces::ADC::Sample_Interface,
    public Interfaces::ADC::Voltage_Interface
  {
    Input_Class(Device dev, unsigned channel, unsigned range, double gain = 1.0,
      double offset = 0.0);

    virtual int sample(void);

    virtual unsigned resolution(void);

    virtual double voltage(void);

  private:

    Device dev;
    unsigned channel;
    unsigned range;
    double gain;
    double offset;
  };

  // Device class (completed)

  struct Device_Class
  {
    Device_Class(Interfaces::I2C::Bus bus, unsigned addr);

  private:

    uint16_t ReadRegister(unsigned reg);

    void WriteRegister(unsigned reg, uint16_t value);

    Interfaces::I2C::Bus bus;
    unsigned addr;

    friend class Input_Class;
  };
}

#endif
