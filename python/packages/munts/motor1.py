# Type 1 Motor Driver: 1 PWM output for speed and 1 GPIO output for direction
# Both the PWM output and GPIO output must be fully configured

# Copyright (C)2024, Philip Munts dba Munts Technologies
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

__author__	= "Philip Munts <phil@munts.net>"

import munts.interfaces.gpio
import munts.interfaces.motor
import munts.interfaces.pwm

from munts.interfaces.motor import MAXIMUM_VELOCITY
from munts.interfaces.motor import MINIMUM_VELOCITY
from munts.interfaces.motor import STOPPED_VELOCITY
from munts.interfaces.pwm   import MAXIMUM_DUTYCYCLE

##############################################################################

# Motor driver output class

class Output(munts.interfaces.motor.MotorOutputInterface):

  # Constructor

  def __init__(self, speed, direction, velocity = STOPPED_VELOCITY):
    if not munts.interfaces.pwm.PWMOutputInterface in speed.__class__.__mro__:
      raise TypeError("speed argument does NOT implement PWMOutputInterface ")

    if not munts.interfaces.gpio.GPIOPinInterface in direction.__class__.__mro__:
      raise TypeError("direction argument does NOT implement GPIOPinInterface")

    if velocity < MINIMUM_VELOCITY or velocity > MAXIMUM_VELOCITY:
      raise ValueError("Velocity is out of range")

    self.__pwmout__   = speed
    self.__dirout__   = direction
    self.__velocity__ = STOPPED_VELOCITY

    # Set initial velocity

    self.velocity = velocity

  # Velocity property getter

  @property
  def velocity(self):
    return self.__velocity__

  # Velocity property setter

  @velocity.setter
  def velocity(self, value):
    if value < MINIMUM_VELOCITY or value > MAXIMUM_VELOCITY:
      raise ValueError("Velocity is out of range")

    if value < STOPPED_VELOCITY:
      self.__dirout__.state = False  # Nominal reverse rotation
    else:
      self.__dirout__.state = True   # Nominal forward rotation

    self.__pwmout__.dutycycle = abs(value*MAXIMUM_DUTYCYCLE)
    self.__velocity__ = value
