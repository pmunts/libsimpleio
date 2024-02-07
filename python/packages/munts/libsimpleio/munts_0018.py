# Definitions for the MUNTS-0018 Raspberry Pi Tutorial I/O Board

# Copyright (C)2024, Philip Munts dba Munts Technologies.
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions are met:
#
# * Redistributions of source code must retain the above copyright notice,
#   this list of conditions and the following disclaimer.
#
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
# AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
# IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
# ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE
# LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
# CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
# SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
# INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
# CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
# ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
# POSSIBILITY OF SUCH DAMAGE.

import munts.libsimpleio.raspberrypi

# Servo headers

J2PWM = munts.libsimpleio.raspberrypi.PWM0;
J3PWM = munts.libsimpleio.raspberrypi.PWM1;

# Grove GPIO Connectors

J4D0  = munts.libsimpleio.raspberrypi.GPIO23;
J4D1  = munts.libsimpleio.raspberrypi.GPIO24;

J5D0  = munts.libsimpleio.raspberrypi.GPIO5;
J5D1  = munts.libsimpleio.raspberrypi.GPIO4;

J6D0  = munts.libsimpleio.raspberrypi.GPIO12;
J6D1  = munts.libsimpleio.raspberrypi.GPIO13;

J7D0  = munts.libsimpleio.raspberrypi.GPIO19;
J7D1  = munts.libsimpleio.raspberrypi.GPIO18;

# DC Motor control outputs

J6PWM = munts.libsimpleio.raspberrypi.PWM0;
J6DIR = J6D1;

J7PWM = munts.libsimpleio.raspberrypi.PWM1;
J7DIR = J7D1;

# I2C buses

J9I2C = munts.libsimpleio.raspberrypi.I2C1;

# Grove ADC Connector J10

J10A0 = munts.libsimpleio.raspberrypi.AIN2  # MCP3204 CH2
J10A1 = munts.libsimpleio.raspberrypi.AIN3  # MCP3204 CH3

# Grove ADC Connector J11

J11A0 = munts.libsimpleio.raspberrypi.AIN0  # MCP3204 CH0
J11A1 = munts.libsimpleio.raspberrypi.AIN1  # MCP3204 CH1

# On board LED indicator

D1     = munts.libsimpleio.raspberrypi.GPIO26;
LED1   = D1
# On board momentary switch

SW1    = munts.libsimpleio.raspberrypi.GPIO6;
BTN1   = SW1

###############################################################################

# Analog Input Object Factory

import munts.libsimpleio.adc

def AnalogInputFactory(desg):
  if not desg in (J10A0, J10A1, J11A0, J11A1):
    raise ValueError("Illegal GPIO pin designator")

  return munts.libsimpleio.adc.Input(desg, 12, 3.3)

###############################################################################

# GPIO Pin Object Factory

from munts.libsimpleio.gpio import Driver, Edge, Polarity

def GPIOPinFactory(desg, direction, state = False, edge = Edge.Neither,
  driver = Driver.PushPull, polarity = Polarity.ActiveHigh):
  if not desg in (J4D0, J4D1, J5D0, J5D1, J6D0, J6D1, J7D0, J7D1, LED1, BTN1):
    raise ValueError("Illegal GPIO pin designator")

  return munts.libsimpleio.gpio.Pin(desg, direction, state, edge, driver, polarity)

###############################################################################

# PWM Output Object Factory

import munts.libsimpleio.pwm

from munts.libsimpleio.pwm import MINIMUM_DUTYCYCLE, Polarity

def PWMOutputFactory(desg, frequency, dutycycle = MINIMUM_DUTYCYCLE,
  polarity = Polarity.ActiveHigh):
  if not desg in (J6PWM, J7PWM):
    raise ValueError("Illegal PWM output designator")

  return munts.libsimpleio.pwm.Output(desg, frequency, dutycycle, polarity)

###############################################################################

# Servo Output Object Factory

import munts.libsimpleio.servo

from munts.libsimpleio.servo import NEUTRAL_POSITION

def ServoOutputFactory(desg, frequency = 50, position = NEUTRAL_POSITION):
  if not desg in (J2PWM, J3PWM):
    raise ValueError("Illegal PWM output designator")

  return munts.libsimpleio.servo.Output(desg, frequency, position)

###############################################################################

# Motor Driver Output Object Factory

import munts.devices.motor1

from munts.interfaces.gpio  import Direction
from munts.interfaces.motor import STOPPED_VELOCITY

def MotorOutputFactory(pwmdesg, gpiodesg, frequency, velocity = STOPPED_VELOCITY):
  if not pwmdesg in (J6PWM, J7PWM):
    raise ValueError("Illegal PWM output designator")

  if not gpiodesg in (J6DIR, J7DIR):
    raise ValueError("Illegal GPIO pin designator")

  return munts.devices.motor1.Output(PWMOutputFactory(pwmdesg, frequency),
    GPIOPinFactory(gpiodesg, Direction.Output, True), velocity)
