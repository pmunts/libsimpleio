// Motor services using PWM and GPIO outputs

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

#ifndef _MOTOR_PWM_H
#define _MOTOR_PWM_H

#include <gpio-interface.h>
#include <motor-interface.h>
#include <pwm-interface.h>

namespace Motor::PWM
{
  struct Output_Class: public Interfaces::Motor::Output_Interface
  {
    // Type 1 motor control systems:

    // One PWM output for speed control
    // One GPIO output for direction control

    Output_Class(Interfaces::PWM::Output speed, Interfaces::GPIO::Pin dir,
      const double velocity = 0.0);

    // Type 2 motor control systems:

    // One PWM output for clockwise rotation
    // One PWM output for counter-clockwise rotation

    Output_Class(Interfaces::PWM::Output cw, Interfaces::PWM::Output ccw,
      const double velocity = 0.0);

    // Motor output methods

    virtual void write(const double velocity);

  private:

    Interfaces::GPIO::Pin dir;
    Interfaces::PWM::Output pwm1;
    Interfaces::PWM::Output pwm2;
  };
}

#endif
