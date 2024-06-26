// Abstract interface for continuously variable motor control outputs

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

#ifndef _MOTOR_INTERFACE_H
#define _MOTOR_INTERFACE_H

namespace Interfaces::Motor
{
  // Normalized motor velocity constants

  static constexpr double VELOCITY_MIN  = -1.0; // Full speed reverse
  static constexpr double VELOCITY_MAX  = +1.0; // Full speed forward
  static constexpr double VELOCITY_STOP = 0.0;

  struct Output_Interface
  {
    // Motor output methods

    virtual void write(const double velocity) = 0;

    // Motor output operators

#ifdef WITH_ASSIGNMENT_OPERATORS
    void operator =(const double velocity);
#endif
  };

  typedef Output_Interface *Output;
}

#endif
