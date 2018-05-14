// PWM output services using libsimpleio

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

#include <pwm-libsimpleio.h>
#include <libsimpleio/libpwm.h>

// Constructor

libsimpleio::PWM::Output_Class::Output_Class(unsigned chip, unsigned channel,
  unsigned frequency, double dutycycle, unsigned polarity)
{
  // Validate parameters

  if (frequency < 1) throw EINVAL;
  if (dutycycle < Interfaces::PWM::DUTYCYCLE_MIN) throw EINVAL;
  if (dutycycle > Interfaces::PWM::DUTYCYCLE_MAX) throw EINVAL;
  if (polarity > libsimpleio::PWM::ActiveHigh) throw EINVAL;

  // Calculate the PWM pulse frequency and initial pulse width in nanoseconds

  unsigned period = 1.0E9/frequency;
  unsigned ontime = dutycycle/100.0*period;

  // Configure the PWM output

  int fd;
  int error;

  PWM_configure(chip, channel, period, ontime, polarity, &error);
  if (error) throw error;

  PWM_open(chip, channel, &fd, &error);
  if (error) throw error;

  this->fd = fd;
  this->period = period;
}

// PWM output methods

void libsimpleio::PWM::Output_Class::write(const double dutycycle)
{
  // Validate parameters

  if (dutycycle < Interfaces::PWM::DUTYCYCLE_MIN) throw EINVAL;
  if (dutycycle > Interfaces::PWM::DUTYCYCLE_MAX) throw EINVAL;

  // Calculate the required PWM pulse width in nanoseconds

  unsigned ontime = dutycycle/100.0*this->period;
  int error;

  // Set the PWM pulse width

  PWM_write(this->fd, ontime, &error);
  if (error) throw error;
}
