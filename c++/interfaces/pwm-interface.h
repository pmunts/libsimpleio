// Abstract interface for PWM (Pulse Width Modulated) outputs

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

#ifndef _PWM_INTERFACE_H
#define _PWM_INTERFACE_H

namespace Interfaces::PWM
{
  // Duty cycle constants

  static constexpr double DUTYCYCLE_MIN = 0.0;
  static constexpr double DUTYCYCLE_MAX = 100.0;

  struct Output_Interface
  {
    // PWM output methods

    virtual void write(const double dutycycle) = 0;

    // PWM output operators

#ifdef WITH_ASSIGNMENT_OPERATORS
    void operator =(const double dutycycle);
#endif

    // Query the configured PWM output pulse frequency

    virtual unsigned frequency(void) = 0;
  };

  typedef Output_Interface *Output;
}

#endif
