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

namespace Interfaces::Temperature
{
  const double AbsoluteZero  = -273.15;
  const double FreezingPoint = 0.0;
  const double BoilingPoint  = 100.0;

  // Temperature conversion routines

  double C_to_F(double T)  // Celsius to Fahrenheit
  {
    return T*9.0/5.0 + 32.0;
  }

  double C_to_K(double T)  // Celsius to Kelvins
  {
    return T - AbsoluteZero;
  }

  double F_to_C(double T)  // Fahrenheit to Celsius
  {
    return (T - 32.0)*5.0/9.0;
  }

  double F_to_K(double T)  // Fahrenheit to Kelvins
  {
    return (T + 459.67)*5.0/9.0;
  }

  double K_to_C(double T)  // Kelvins to Celsius
  {
    return T + AbsoluteZero;
  }

  double K_to_F(double T)  // Kelvins to Fahrenheit
  {
    return T*9.0/5.0 - 459.67;
  }
}
