// PWM output services using libsimpleio

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

#include <exception-raisers.h>
#include <pwm-libsimpleio.h>
#include <libsimpleio/libpwm.h>

using namespace libsimpleio::PWM;

// Constructor

Output_Class::Output_Class(unsigned chip, unsigned channel, unsigned frequency,
  double dutycycle, unsigned polarity)
{
  // Validate parameters

  if (frequency < 1)
    THROW_MSG("The frequency parameter is out of range");

  if (dutycycle < Interfaces::PWM::DUTYCYCLE_MIN)
    THROW_MSG("The dutycycle parameter is out of range");

  if (dutycycle > Interfaces::PWM::DUTYCYCLE_MAX)
    THROW_MSG("The dutycycle parameter is out of range");

  if (polarity > ActiveHigh)
    THROW_MSG("The polarity parameter is out of range");

  // Calculate the PWM pulse frequency and initial pulse width in nanoseconds

  unsigned period = 1.0E9/frequency;
  unsigned ontime = dutycycle/100.0*period;

  // Configure the PWM output

  int fd;
  int error;

  PWM_configure(chip, channel, period, ontime, polarity, &error);
  if (error) THROW_MSG_ERR("PWM_configure() failed", error);

  PWM_open(chip, channel, &fd, &error);
  if (error) THROW_MSG_ERR("PWM_open() failed", error);

  this->fd = fd;
  this->freq = frequency;
  this->period = period;
}

// PWM output methods

void Output_Class::write(const double dutycycle)
{
  // Validate parameters

  if (dutycycle < Interfaces::PWM::DUTYCYCLE_MIN)
    THROW_MSG("The dutycycle parameter is out of range");

  if (dutycycle > Interfaces::PWM::DUTYCYCLE_MAX)
    THROW_MSG("The dutycycle parameter is out of range");

  // Calculate the required PWM pulse width in nanoseconds

  unsigned ontime = dutycycle/100.0*this->period;
  int error;

  // Set the PWM pulse width

  PWM_write(this->fd, ontime, &error);
  if (error) THROW_MSG_ERR("PWM_write() failed", error);
}

// Query the configured PWM output pulse frequency

unsigned Output_Class::frequency(void)
{
  return this->freq;
}
