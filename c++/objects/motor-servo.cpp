// Motor services using servo outputs (e.g. continuous rotation servos)

// Copyright (C)2018-2020, Philip Munts, President, Munts AM Corp.
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
#include <motor-servo.h>

using namespace Motor::Servo;

// Motor output constructor

Output_Class::Output_Class(Interfaces::Servo::Output servo,
  const double velocity)
{
  // Validate parameters

  if (servo == nullptr)
    THROW_MSG("The servo parameter is NULL");

  if (velocity < Interfaces::Motor::VELOCITY_MIN)
    THROW_MSG("The velocity parameter is out of range");

  if (velocity > Interfaces::Motor::VELOCITY_MAX)
    THROW_MSG("The velocity parameter is out of range");

  this->servo = servo;
  this->servo->write(velocity);
}

// Motor output methods

void Output_Class::write(const double velocity)
{
  // Validate parameters

  if (velocity < Interfaces::Motor::VELOCITY_MIN)
    THROW_MSG("The velocity parameter is out of range");

  if (velocity > Interfaces::Motor::VELOCITY_MAX)
    THROW_MSG("The velocity parameter is out of range");

  this->servo->write(velocity);
}
