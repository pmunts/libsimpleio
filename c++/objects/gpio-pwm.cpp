// GPIO services using PWM outputs

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

// Use cases for this package include on/off things like an LED or a solenoid
// valve driven from a PWM output.

// WARNING: Depending on the PWM hardware implementation, the off duty cycle
// may be slightly greater than 0 % and/or the on duty cycle may be slightly
// less than 100 %.

#include <exception-raisers.h>
#include <gpio-pwm.h>

using namespace GPIO::PWM;

// GPIO pin constructor

Pin_Class::Pin_Class(Interfaces::PWM::Output pwmout, bool state, double dutycycle)
{
  // Validate parameters

  if (dutycycle < Interfaces::PWM::DUTYCYCLE_MIN)
    THROW_MSG("The dutycycle parameter is out of range");

  if (dutycycle > Interfaces::PWM::DUTYCYCLE_MAX)
    THROW_MSG("The dutycycle parameter is out of range");

  this->myoutput = pwmout;
  this->myduty = dutycycle;
  this->mystate = state;
}

// GPIO pin methods

bool Pin_Class::read(void)
{
  return this->mystate;
}

void Pin_Class::write(bool state)
{
  if (state)
    this->myoutput->write(this->myduty);
  else
    this->myoutput->write(Interfaces::PWM::DUTYCYCLE_MIN);

  this->mystate = state;
}
