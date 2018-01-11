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
#include <libpwm.h>

// Constructor

PWM_libsimpleio::PWM_libsimpleio(unsigned chip, unsigned channel,
  unsigned frequency, double dutycycle, unsigned polarity)
{
  const unsigned period = 1.0E9/frequency;		// nanoseconds
  const unsigned ontime = dutycycle/100.0*period;	// nanoseconds
  int fd;
  int error;

  // Configure the PWM output

  PWM_configure(chip, channel, period, ontime, polarity, &error);
  if (error) throw(error);

  PWM_open(chip, channel, &fd, &error);
  if (error) throw(error);

  this->fd = fd;
  this->period = period;
}

// Write method

void PWM_libsimpleio::write(double dutycycle)
{
  const unsigned ontime = dutycycle/100.0*this->period;
  int error;

  PWM_write(this->fd, ontime, &error);
  if (error) throw(error);
}
