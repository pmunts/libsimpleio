// Abstract interface for ADC (Analog to Digital Converter) inputs

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

#include <adc-interface.h>
#include <exception-raisers.h>

using namespace Interfaces::ADC;

#ifdef WITH_ASSIGNMENT_OPERATORS
Sample_Interface::operator int(void)
{
  return this->sample();
}

Voltage_Interface::operator double(void)
{
  return this->voltage();
}
#endif

Input_Class::Input_Class(Sample input, double reference, double gain)
{
  // Validate parameters

  if (reference == 0.0)
    THROW_MSG("The reference parameter cannot be zero");

  if (gain == 0.0)
    THROW_MSG("The gain parameter cannot be zero");

  this->input = input;
  this->stepsize = reference/(1 << input->resolution())/gain;
}

double Input_Class::voltage(void)
{
  return this->input->sample()*this->stepsize;
}
