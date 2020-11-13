// Abstract interface for DAC (Digital to Analog Converter) outputs

// Copyright (C)2018-2020, Philip Munts, President, Munts AM Corp.
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

#ifndef _DAC_INTERFACE_H
#define _DAC_INTERFACE_H

namespace Interfaces::DAC
{
  // Abstract interface for DAC raw sampled data outputs

  struct Sample_Interface
  {
    // Methods

    virtual void write(const int sample) = 0;

    virtual unsigned resolution(void) = 0;

    // Operators

#ifdef WITH_ASSIGNMENT_OPERATORS
    void operator =(const int sample);
#endif
  };

  typedef Sample_Interface *Sample;

  // Abstract interface for DAC scaled voltage outputs

  struct Voltage_Interface
  {
    // Methods

    virtual void write(const double voltage) = 0;

    // Operators

    void operator =(const double voltage);
  };

  typedef Voltage_Interface *Voltage;

  // Utility class for converting DAC raw sample data to scaled voltage

  struct Output_Class: public Voltage_Interface
  {
    // Constructors

    Output_Class(Sample output, double reference, double gain = 1.0);

    // Methods

    virtual void write(const double voltage);

  private:

    Sample output;
    double stepsize;
  };

  typedef Output_Class *Output;
}

#endif
