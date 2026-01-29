// Copyright (C)2026, Philip Munts dba Munts Technologies.
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

// Each resource designator constant declared here is named relative to the
// connector providing that resource.  Application programs should use the
// designator constants declared here instead of literals or constants from
// the RaspberryPi package.
//
// The following device tree overlay statements must be added to
// /boot/config.txt:
//
// dtparam=i2c=on
// dtparam=spi=on
// dtoverlay=anyspi,spi0-1,dev="microchip,mcp3204",speed=1000000
// dtoverlay=pwm-2chan,pin=12,func=4,pin2=19,func2=2
//
// GPIO12 and GPIO19 will be unavailable for GPIO, as they will be mapped
// as PWM outputs.  If you need to use these pins for GPIO, omit the pwm-2chan
// device tree overlay.

package com.munts.libsimpleio;

import com.munts.libsimpleio.Designator;
import com.munts.libsimpleio.RaspberryPi;

public final class MUNTS_0018
{
  private MUNTS_0018()
  {
  }

  // Servo headers

  public static final Designator J2PWM  = RaspberryPi.PWM0;
  public static final Designator J3PWM  = RaspberryPi.PWM1;

  // Grove GPIO Connectors

  public static final Designator J4D0   = RaspberryPi.GPIO23;
  public static final Designator J4D1   = RaspberryPi.GPIO24;

  public static final Designator J5D0   = RaspberryPi.GPIO5;
  public static final Designator J5D1   = RaspberryPi.GPIO4;

  public static final Designator J6D0   = RaspberryPi.GPIO12;
  public static final Designator J6D1   = RaspberryPi.GPIO13;

  public static final Designator J7D0   = RaspberryPi.GPIO19;
  public static final Designator J7D1   = RaspberryPi.GPIO18;

  // DC Motor control outputs

  public static final Designator J6PWM  = RaspberryPi.PWM0;
  public static final Designator J6DIR  = J6D1;

  public static final Designator J7PWM  = RaspberryPi.PWM1;
  public static final Designator J7DIR  = J7D1;

  // Serial ports

  public static final String     J8UART = "/dev/ttyAMA0";

  // I2C buses

  public static final Designator J9I2C  = RaspberryPi.I2C1;

  // Grove ADC Connector J10

  public static final Designator J10A0  = RaspberryPi.AIN2; // MCP3204 CH2
  public static final Designator J10A1  = RaspberryPi.AIN3; // MCP3204 CH3

  // Grove ADC Connector J11

  public static final Designator J11A0  = RaspberryPi.AIN0; // MCP3204 CH0
  public static final Designator J11A1  = RaspberryPi.AIN1; // MCP3204 CH1

  // On board momentary switch

  public static final Designator SW1    = RaspberryPi.GPIO6;

  // On board LED indicator

  public static final Designator D1     = RaspberryPi.GPIO26;
}
