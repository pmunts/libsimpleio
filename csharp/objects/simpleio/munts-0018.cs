// MUNTS-0018 Tutoral Board Definitions

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

using IO.Objects.libsimpleio.Device;
using static IO.Objects.libsimpleio.Platforms.RaspberryPi;

namespace IO.Objects.libsimpleio.Platforms
{
  public static class MUNTS_0018
  {
    // On board LED

    public static readonly Designator D1 = GPIO26;

    // On board pushbutton switch

    public static readonly Designator SW1 = GPIO6;

    // Grove GPIO Connectors

    public static readonly Designator J4D0 = GPIO23;
    public static readonly Designator J4D1 = GPIO24;

    public static readonly Designator J5D0 = GPIO5;
    public static readonly Designator J5D1 = GPIO4;

    public static readonly Designator J6D0 = GPIO12;
    public static readonly Designator J6D1 = GPIO13;

    public static readonly Designator J7D0 = GPIO19;
    public static readonly Designator J7D1 = GPIO18;

    // Servo headers

    public static readonly Designator J2PWM = PWM0_0;
    public static readonly Designator J3PWM = PWM0_1;

    // DC motor control outputs (PWM and direction)

    public static readonly Designator J6PWM = J2PWM;
    public static readonly Designator J6DIR = J6D1;

    public static readonly Designator J7PWM = J3PWM;
    public static readonly Designator J7DIR = J7D1;

    // I2C buses

    public static readonly Designator J5I2C = I2C3;
    public static readonly Designator J9I2C = I2C1;

    // Analog inputs (on board MCP3204)

    public static readonly Designator J10A0 = new Designator(0, 2);
    public static readonly Designator J10A1 = new Designator(0, 3);

    public static readonly Designator J11A0 = new Designator(0, 0);
    public static readonly Designator J11A1 = new Designator(0, 1);
  }
}
