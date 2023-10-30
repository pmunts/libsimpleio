// Servo output services using libsimpleio

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

#include <exception-raisers.h>
#include <servo-libsimpleio.h>
#include <libsimpleio/libpwm.h>

using namespace libsimpleio::Servo;

// Constructor

Output_Class::Output_Class(unsigned chip, unsigned channel, unsigned frequency,
  double position)
{
  // Validate parameters

  if (frequency < 1)
    THROW_MSG("The frequency parameter is out of range");

  if (frequency > 400)
    THROW_MSG("The frequency parameter is out of range");

  if (position < Interfaces::Servo::POSITION_MIN)
    THROW_MSG("The position parameter is out of range");

  if (position > Interfaces::Servo::POSITION_MAX)
    THROW_MSG("The position parameter is out of range");

  // Calculate the PWM pulse frequency and initial pulse width in nanoseconds

  unsigned period = 1.0E9/frequency;
  unsigned ontime = 1500000.0 + 500000.0*position;

  // Configure the PWM output

  int fd;
  int error;

  PWM_configure(chip, channel, period, ontime, PWM_POLARITY_ACTIVEHIGH, &error);
  if (error) THROW_MSG_ERR("PWM_configure() failed", error);

  PWM_open(chip, channel, &fd, &error);
  if (error) THROW_MSG_ERR("PWM_open() failed", error);

  this->fd = fd;
}

// Servo output methods

void Output_Class::write(const double position)
{
  // Validate parameters

  if (position < Interfaces::Servo::POSITION_MIN)
    THROW_MSG("The position parameter is out of range");

  if (position > Interfaces::Servo::POSITION_MAX)
    THROW_MSG("The position parameter is out of range");

  // Calculate the required PWM pulse width in nanoseconds

  unsigned ontime = 1500000.0 + 500000.0*position;

  // Set the PWM pulse width

  int error;

  PWM_write(this->fd, ontime, &error);
  if (error) THROW_MSG_ERR("PWM_write() failed", error);
}
