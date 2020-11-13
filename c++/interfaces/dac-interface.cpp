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

#include <dac-interface.h>
#include <exception-raisers.h>

using namespace Interfaces::DAC;

#ifdef WITH_ASSIGNMENT_OPERATORS
void Sample_Interface::operator =(const int sample)
{
  this->write(sample);
}

void Voltage_Interface::operator =(const double voltage)
{
  this->write(voltage);
}
#endif

Output_Class::Output_Class(Sample output, double reference, double gain)
{
  // Validate parameters

  if (reference == 0.0)
    THROW_MSG("The reference parameter cannot be zero");

  if (gain == 0.0)
    THROW_MSG("The gain parameter cannot be zero");

  this->output = output;
  this->stepsize = reference/(1 << output->resolution())/gain;
}

void Output_Class::write(const double voltage)
{
  this->output->write(voltage/stepsize);
}
