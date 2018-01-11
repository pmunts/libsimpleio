// Analog input services using libsimpleio

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

#include <cerrno>
#include <cstdint>

#include <libadc.h>

#include <adc-libsimpleio.h>

// Constructor

ADC_libsimpleio::InputClass::InputClass(unsigned chip, unsigned channel,
  unsigned resolution, double reference, double gain, double offset)
{
  int fd;
  int error;

  ADC_open(chip, channel, &fd, &error);
  if (error) throw(error);

  this->fd = fd;
  this->stepsize = reference/((double)(1 << resolution));
  this->gain = gain;
  this->offset = offset;
}

// Read methods

int ADC_libsimpleio::InputClass::read(void)
{
  int32_t sample;
  int32_t error;

  ADC_read(this->fd, &sample, &error);
  if (error) throw(error);

  return sample;
}

double ADC_libsimpleio::InputClass::voltage(void)
{
  return this->read()*this->stepsize/this->gain - this->offset;
}
