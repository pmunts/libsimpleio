// Remote I/O Protocol PWM output services

// Copyright (C)2020, Philip Munts, President, Munts AM Corp.
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
#include <cstring>

#include <exception-raisers.h>
#include <remoteio.h>
#include <remoteio-pwm.h>

using namespace RemoteIO::PWM;

// PWM output constructor

Output_Class::Output_Class(RemoteIO::Client::Device dev, unsigned num,
  unsigned frequency, double dutycycle)
{
  // Validate parameters

  if (dev == nullptr)
    THROW_MSG("dev parameter is NULL");

  if (num >= RemoteIO::MAX_CHANNELS)
    THROW_MSG("num parameter is out of range");

  if (frequency < 50)
    THROW_MSG("frequency parameter is out of range");

  if (dutycycle < Interfaces::PWM::DUTYCYCLE_MIN)
    THROW_MSG("dutycycle parameter is out of range");

  if (dutycycle > Interfaces::PWM::DUTYCYCLE_MAX)
    THROW_MSG("dutycycle parameter is out of range");

  // Calculate the PWM output pulse period in nanoseconds

  uint32_t period = 1000000000/frequency;

  // Configure the PWM output

  Interfaces::Message64::Message_Class cmd;
  Interfaces::Message64::Message_Class resp;

  memset(cmd.payload, 0, Interfaces::Message64::Size);
  memset(resp.payload, 0, Interfaces::Message64::Size);

  cmd.payload[0] = PWM_CONFIGURE_REQUEST;
  cmd.payload[2] = num;
  cmd.payload[3] = (period >> 24) & 0xFF;
  cmd.payload[4] = (period >> 16) & 0xFF;
  cmd.payload[5] = (period >> 8)  & 0xFF;
  cmd.payload[6] = period & 0xFF;

  dev->Transaction(&cmd, &resp);

  this->dev = dev;
  this->num = num;
  this->freq = frequency;
  this->period = period;

  // Write initial output duty cycle

  this->write(dutycycle);
}

// PWM output methods

void Output_Class::write(const double dutycycle)
{
  // Validate parameters

  if (dutycycle < Interfaces::PWM::DUTYCYCLE_MIN)
    THROW_MSG("dutycycle parameter is out of range");

  if (dutycycle > Interfaces::PWM::DUTYCYCLE_MAX)
    THROW_MSG("dutycycle parameter is out of range");

  // Calculate PWM output pulse duration in nanoseconds

  uint32_t ontime = dutycycle/100.0*this->period;

  // Build the command message

  Interfaces::Message64::Message_Class cmd;
  Interfaces::Message64::Message_Class resp;

  memset(cmd.payload, 0, Interfaces::Message64::Size);
  memset(resp.payload, 0, Interfaces::Message64::Size);

  cmd.payload[0] = PWM_WRITE_REQUEST;
  cmd.payload[2] = this->num;
  cmd.payload[3] = (ontime >> 24) & 0xFF;
  cmd.payload[4] = (ontime >> 16) & 0xFF;
  cmd.payload[5] = (ontime >> 8)  & 0xFF;
  cmd.payload[6] = ontime & 0xFF;

  // Dispatch the command

  this->dev->Transaction(&cmd, &resp);
}

// Query the configured PWM output pulse frequency

unsigned Output_Class::frequency(void)
{
  return this->freq;
}
