// Analog input services using libsimpleio

// Copyright (C)2017-2023, Philip Munts dba Munts Technologies.
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

#include <cstdint>

#include <adc-libsimpleio.h>
#include <exception-raisers.h>
#include <libsimpleio/libadc.h>

using namespace libsimpleio::ADC;

// Constructors

Sample_Class::Sample_Class(unsigned chip, unsigned channel, unsigned resolution)
{
  int error;

  ADC_open(chip, channel, &this->fd, &error);
  if (error) THROW_MSG_ERR("ADC_open() failed", error);

  this->numbits = resolution;
}

// Methods

int Sample_Class::sample(void)
{
  int32_t sample;
  int32_t error;

  ADC_read(this->fd, &sample, &error);
  if (error) THROW_MSG_ERR("ADC_read() failed", error);

  return sample;
}

unsigned Sample_Class::resolution(void)
{
  return this->numbits;
}
