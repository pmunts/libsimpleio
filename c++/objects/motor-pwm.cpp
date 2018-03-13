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

#include <cerrno>

#include <motor-pwm.h>

// Type 1 motor control systems:

// One PWM output for speed control
// One GPIO output for direction control

Motor::PWM::Output_Class::Output_Class(Interfaces::PWM::Output speed,
  Interfaces::GPIO::Pin dir, const double velocity)
{
  // Validate parameters

  if (speed == nullptr) throw EINVAL;
  if (dir == nullptr) throw EINVAL;
  if (velocity < Interfaces::Motor::VELOCITY_MIN) throw EINVAL;
  if (velocity > Interfaces::Motor::VELOCITY_MAX) throw EINVAL;

  this->dir = dir;
  this->pwm1 = speed;
  this->pwm2 = nullptr;

  this->write(velocity);
}

// Type 2 motor control systems:

// One PWM output for clockwise rotation
// One PWM output for counter-clockwise rotation

Motor::PWM::Output_Class::Output_Class(Interfaces::PWM::Output cw,
  Interfaces::PWM::Output ccw, const double velocity)
{
  // Validate parameters

  if (cw == nullptr) throw EINVAL;
  if (ccw == nullptr) throw EINVAL;
  if (velocity < Interfaces::Motor::VELOCITY_MIN) throw EINVAL;
  if (velocity > Interfaces::Motor::VELOCITY_MAX) throw EINVAL;

  this->dir = nullptr;
  this->pwm1 = cw;
  this->pwm2 = ccw;

  this->write(velocity);
}

// Motor output methods

void Motor::PWM::Output_Class::write(const double velocity)
{
  // Validate parameters

  if (velocity < Interfaces::Motor::VELOCITY_MIN) throw EINVAL;
  if (velocity > Interfaces::Motor::VELOCITY_MAX) throw EINVAL;

  if (velocity >= Interfaces::Motor::VELOCITY_STOP)
  {
    if (this->dir == nullptr)
    {
      this->pwm2->write(Interfaces::Motor::VELOCITY_STOP);
      this->pwm1->write(100.0*velocity);
    }
    else
    {
      this->pwm1->write(Interfaces::Motor::VELOCITY_STOP);
      this->dir->write(true);
      this->pwm1->write(100.0*velocity);
    }
  }
  else
  {
    if (this->dir == nullptr)
    {
      this->pwm1->write(Interfaces::Motor::VELOCITY_STOP);
      this->pwm2->write(-100.0*velocity);
    }
    else
    {
      this->pwm1->write(Interfaces::Motor::VELOCITY_STOP);
      this->dir->write(false);
      this->pwm1->write(-100.0*velocity);
    }
  }
}
