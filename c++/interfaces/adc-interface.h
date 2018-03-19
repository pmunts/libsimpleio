// Abstract interface for ADC (Analog to Digital Converter) inputs

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

#ifndef _ADC_INTERFACE_H
#define _ADC_INTERFACE_H

namespace Interfaces::ADC
{
  // Abstract interface for ADC raw sampled data inputs

  struct Sample_Interface
  {
    // Methods

    virtual int sample(void) = 0;

    virtual unsigned resolution(void) = 0;

    // Operators

    operator int(void);
  };

  typedef Sample_Interface *Sample;

  // Abstract interface for ADC scaled voltage inputs

  struct Voltage_Interface
  {
    // Methods

    virtual double voltage(void) = 0;

    // Operators

    operator double(void);
  };

  typedef Voltage_Interface *Voltage;

  // Utility class for converting ADC raw sample data to scaled voltage

  struct Input_Class: public Voltage_Interface
  {
    // Constructors

    Input_Class(Sample input, double reference, double gain = 1.0);

    // Methods

    virtual double voltage(void);

  private:

    Sample input;
    double stepsize;
    double gain;
  };

  typedef Input_Class *Input;
}

#endif
