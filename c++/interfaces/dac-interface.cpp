// Abstract interface for DAC (Digital to Analog Converter) outputs

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

#include <cerrno>

#include <dac-interface.h>

void Interfaces::DAC::Sample_Interface::operator =(const int sample)
{
  this->write(sample);
}

void Interfaces::DAC::Voltage_Interface::operator =(const double voltage)
{
  this->write(voltage);
}

Interfaces::DAC::Output_Class::Output_Class(Interfaces::DAC::Sample output,
  double reference, double gain)
{
  // Validate parameters

  if (reference == 0.0) throw EINVAL;
  if (gain == 0.0) throw EINVAL;

  this->output = output;
  this->stepsize = reference/(1 << output->resolution())/gain;
}

void Interfaces::DAC::Output_Class::write(const double voltage)
{
  this->output->write(voltage/stepsize);
}
