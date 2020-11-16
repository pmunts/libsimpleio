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

#ifndef _TEMPERATURE_INTERFACE_H
#define _TEMPERATURE_INTERFACE_H

namespace Interfaces::Temperature
{
  // Abstract interface for temperature (Celsius) sensors

  struct Sensor_Interface
  {
    // Read temperature in degrees Celsius
    virtual double temperature(void) = 0;
  };

  typedef Sensor_Interface *Sensor;

  // Temperature constants (Celsius)

  extern const double AbsoluteZero;
  extern const double FreezingPoint;
  extern const double BoilingPoint;

  // Temperature conversion routines

  double C_to_F(double T);  // Celsius to Fahrenheit
  double C_to_K(double T);  // Celsius to Kelvins
  double F_to_C(double T);  // Fahrenheit to Celsius
  double F_to_K(double T);  // Fahrenheit to Kelvins
  double K_to_C(double T);  // Kelvins to Celsius
  double K_to_F(double T);  // Kelvins to Fahrenheit
}

#endif
