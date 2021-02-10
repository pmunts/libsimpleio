// GPIO services using PWM outputs

// Copyright (C)2021, Philip Munts, President, Munts AM Corp.
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

#ifndef _GPIO_PWM_H
#define _GPIO_PWM_H

#include <gpio-interface.h>
#include <pwm-interface.h>

namespace GPIO::PWM
{
  struct Pin_Class: public Interfaces::GPIO::Pin_Interface
  {
    // GPIO pin constructor

    Pin_Class(Interfaces::PWM::Output pwmout, bool state = false,
      double dutycycle = Interfaces::PWM::DUTYCYCLE_MAX);

    // GPIO pin methods

    virtual bool read(void);

    virtual void write(bool state);

  private:

    Interfaces::PWM::Output myoutput;
    double myduty;
    bool mystate;
  };
}

#endif
